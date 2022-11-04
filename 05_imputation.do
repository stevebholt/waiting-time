/*
Title: R3 Imputation For Waiting Time Paper
Author: Stephen B. Holt
*/
use "CPS_ASEC_selectvars_timeinequality.dta"


//varlist: white black native asian pacisl multi otherrc hisp age female hsdip somcol coldeg unemployed married hhchild yngchild metro year (2003-2019)
//Code to match ATUS version. Run regression and predict y_hat of income. Create percent of federal poverty line. Create concatenated variable of all controls in both. Merge on concatenated variable. Re-run with bins of federal poverty line var.

//Income
gen atus_inc = .
replace atus_inc = 1 if hhincome < 5000
replace atus_inc = 2 if hhincome >= 5000 & hhincome < 7500
replace atus_inc = 3 if hhincome >= 7500 & hhincome < 10000
replace atus_inc = 4 if hhincome >= 10000 & hhincome < 12500
replace atus_inc = 5 if hhincome >= 12500 & hhincome < 15000
replace atus_inc = 6 if hhincome >= 15000 & hhincome < 20000
replace atus_inc = 7 if hhincome >= 20000 & hhincome < 25000
replace atus_inc = 8 if hhincome >= 25000 & hhincome < 30000
replace atus_inc = 9 if hhincome >= 30000 & hhincome < 35000
replace atus_inc = 10 if hhincome >= 35000 & hhincome < 40000
replace atus_inc = 11 if hhincome >= 40000 & hhincome < 50000
replace atus_inc = 12 if hhincome >= 50000 & hhincome < 60000
replace atus_inc = 13 if hhincome >= 60000 & hhincome < 75000
replace atus_inc = 14 if hhincome >= 75000 & hhincome < 100000
replace atus_inc = 15 if hhincome >= 100000 & hhincome < 150000
replace atus_inc = 16 if hhincome >= 150000

//HH size
recode marst (3 = 5) (5 = 3), gen(pemaritl)
gen hhsize2 = (nchild + 2) if pemaritl == 1
replace hhsize2 = (nchild + 1) if pemaritl > 1

gen hh_size = hhsize2

//Education
recode educ (1 = .) (2 = 31) (10 = 32) (20 = 33) (30 = 34) (40 = 35) (50 = 36), gen(peeduca)
recode peeduca (60 = 37) (71 = 38) (73 = 39) (81 = 40) (91 = 41) (92 = 42) (111 = 43)
recode peeduca (123 = 44) (124 = 45) (125 = 46)

//Employment
recode empstat (0 = .) (1 10 12 = 1) (21 22 = 2) (32 34 36 = 3), gen(empstat2)

//metro
rename metro metro2
recode metro2 (0 1 = 0) (2 3 4 = 1), gen(metro)

//Race
gen race_cat = .
replace race_cat = 1 if race == 100 & hispan == 0
replace race_cat = 2 if race == 200 & hispan == 0
replace race_cat = 3 if hispan > 0
replace race_cat = 4 if (race == 651 & hispan == 0) | (race == 652 & hispan == 0)

//Gender
gen male = 0
replace male = 1 if sex == 1


//Fitted values of income
forval k = 1/16{
	reg hhincome i.race_cat i.male i.peeduca i.empstat2 hhsize2 i.pemaritl i.metro age i.year if atus_inc == `k'
	predict y_hat`k'
}


//Apply fitted values to appropriate income bracket.
gen predicted_inc = .
forval k = 1/16{
	replace predicted_inc = y_hat`k' if y_hat`k' != . & atus_inc == `k'
}

//Create ID for merging with ATUS.
egen matchid = concat(race_cat male metro empstat2 peeduca hhsize2 pemaritl atus_inc year)

merge m:1 year hh_size using "draft\nature\check\federal_poverty_threshold.dta"

keep matchid year pov_thresh predicted_inc

save "fitted_values.dta", replace

drop if predicted_inc == .
sort matchid
by matchid: drop if _n > 1

save "fitted_values2.dta", replace

clear
//Stuff to ATUS

use "atusall0319.dta"

recode prempnot (3 4 = 3), gen(empstat2)

recode hhchild (10 11 12 = 9), gen(nchild)

gen hhsize2 = (nchild + 2) if pemaritl == 1
replace hhsize2 = (nchild + 1) if pemaritl > 1

recode hefaminc (-1 = .), gen(atus_inc1)
recode hufaminc (-1 -2 -3 = .), gen(atus_inc2)
gen atus_inc = atus_inc1 if atus_inc1 != .
replace atus_inc = atus_inc2 if atus_inc2 != .

egen matchid = concat(race_cat male metro empstat2 peeduca hhsize2 pemaritl atus_inc year)

drop _merge

merge m:1 matchid year using "draft\nature\check\fitted_values2.dta"

save "combined2.dta", replace
keep if _merge == 3

gen prc_pov = ((predicted_inc / pov_thresh)*100)

xtile pt_pov = prc_pov, nq(5)

tab pt_pov, gen(pov)
label var pov1 "1st Quantile"
label var pov2 "2nd Quantile"
label var pov3 "3rd Quantile"
label var pov4 "4th Quantile"
label var pov5 "5th Quantile"

local summaryx waiting_all waiting_all_nz travel_all loinc inc2040 inc4060 inc6075 inc75100 inc100150 inc150p white black native asian pacisl multi otherrc hisp age female male nohsdip hsdip somcol coldeg married hhchild yngchild metro
local timex yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 yr2012 yr2013 yr2014 yr2015 yr2016 yr2017 yr2018 yr2019 feb mar apr may jun jul aug sep oct nov dec mon tue wed thr fri sat
local income pov2 pov3 pov4 pov5 
local demos  black native asian pacisl multi otherrc hisp age female
local edu hsdip somcol coldeg unemployed
local family married hhchild yngchild


estpost tabstat predicted_inc prc_pov if loinc == 1 [aweight=tufnwgtp], statistics(mean sd min max) columns(statistics)
est sto low
estpost tabstat predicted_inc prc_pov if inc150p == 1 [aweight=tufnwgtp], statistics(mean sd min max) columns(statistics)
est sto high
esttab low high using "output\tableSI10.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

xtset gestfips
reg waiting_all `income' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m1
reg waiting_all `income' metro travel_all `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m2
reg waiting_all `income' metro travel_all worktime `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m3
reg waiting_all `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m4
reg waiting_all `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m5
xtreg waiting_all `income' metro travel_all worktime `demos' `edu' `family' `timex', fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI11.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")


xtset gestfips
reg waiting_all_nz `income' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m1
reg waiting_all_nz `income' metro travel_all `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m2
reg waiting_all_nz `income' metro travel_all worktime `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m3
reg waiting_all_nz `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m4
reg waiting_all_nz `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m5
xtreg waiting_all_nz `income' metro travel_all worktime `demos' `edu' `family' `timex', fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI12.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

