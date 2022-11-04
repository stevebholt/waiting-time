use "atusall0319.dta"

local summaryx any_waiting waiting_all waiting_all_nz travel_all loinc inc2040 inc4060 inc6075 inc75100 inc100150 inc150p white black native asian pacisl multi otherrc hisp age female male nohsdip hsdip somcol coldeg married hhchild yngchild metro
local timex yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 yr2012 yr2013 yr2014 yr2015 yr2016 yr2017 yr2018 yr2019 feb mar apr may jun jul aug sep oct nov dec mon tue wed thr fri sat
local income loinc inc2040 inc4060 inc6075 inc75100 inc100150 
local demos  black native asian pacisl multi otherrc hisp age female
local edu hsdip somcol coldeg unemployed
local family married hhchild yngchild


** Table 1
xtset gestfips
reg any_waiting `income' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m1
reg any_waiting `income' metro travel_all `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m2
reg any_waiting `income' metro travel_all worktime `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m3
reg any_waiting `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m4
reg any_waiting `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m5
xtreg any_waiting `income' metro travel_all worktime `demos' `edu' `family' `timex' if any_time == 1, fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\table1_panelA.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

xtset gestfips
reg any_waiting `income' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m1
reg any_waiting `income' metro travel_all `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m2
reg any_waiting `income' metro travel_all worktime `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m3
reg any_waiting `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m4
reg any_waiting `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m5
xtreg any_waiting `income' metro travel_all worktime `demos' `edu' `family' `timex' if any_time == 1, fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\table1_panelB.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

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
esttab m1 m2 m3 m4 m5 m6 using "output\table1_panelC.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

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
esttab m1 m2 m3 m4 m5 m6 using "output\table1_panelC.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

** Table SI 1
reg any_waiting i.hiloinc metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
margins i.hiloinc, post
est sto m1
reg any_waiting i.hiloinc metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hiloinc, post
est sto m2
reg any_time i.hiloinc metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hiloinc, post
est sto m3
esttab m1 m2 m3 using "output\tableSI1.tex", replace b(2) se(2) ar2(2) star(* 0.10 ** 0.05 *** 0.01) compress nogaps obslast tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")


** Table SI 2
log using "logs\summary.log", replace

estpost tabstat `summaryx' [aweight=tufnwgtp], statistics(mean sd count) columns(statistics)
est sto sumall
estpost tabstat `summaryx' [aweight=tufnwgtp] if loinc == 1, statistics(mean sd count) columns(statistics)
est sto sumlow
estpost tabstat `summaryx' [aweight=tufnwgtp] if inc150p == 1, statistics(mean sd count) columns(statistics)
est sto sumhigh
estpost tabstat `summaryx' [aweight=tufnwgtp] if loinc == 1 & any_time == 1, statistics(mean sd count) columns(statistics)
est sto sumlowany
estpost tabstat `summaryx' [aweight=tufnwgtp] if inc150p == 1 & any_time == 1, statistics(mean sd count) columns(statistics)
est sto sumhighany
estpost tabstat `summaryx' [aweight=tufnwgtp] if loinc == 1 & waiting_all > 0, statistics(mean sd count) columns(statistics)
est sto sumlownz
estpost tabstat `summaryx' [aweight=tufnwgtp] if inc150p == 1 & waiting_all > 0, statistics(mean sd count) columns(statistics)
est sto sumhighnz

esttab sumall sumlow sumhigh sumlowany sumhighany sumlownz sumhighnz using "output\t1", cell(mean(fmt(2)) sd(par)) label unstack compress obslast tex mtitles("All" "Low income" "High income") addnotes("Standard deviations in parentheses; the statistical significance of mean differences between high and low income respondents is tested using t tests. *p < .10 **p < .05 ***p < .01.") replace

foreach x of varlist `summaryx'{
	reg `x' inc150p [pweight=tufnwgtp] if (inc150p == 1 | loinc == 1), r
	reg `x' inc150p [pweight=tufnwgtp] if (inc150p == 1 | loinc == 1) & any_time == 1, r
	reg `x' inc150p [pweight=tufnwgtp] if (inc150p == 1 | loinc == 1) & waiting_all > 0, r
}

log close

** Table SI 3
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
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI3.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

** Table SI 4
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
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI4.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

** Table SI 5
xtset gestfips
reg any_waiting `income' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m1
reg any_waiting `income' metro travel_all `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m2
reg any_waiting `income' metro travel_all worktime `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m3
reg any_waiting `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m4
reg any_waiting `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m5
xtreg any_waiting `income' metro travel_all worktime `demos' `edu' `family' `timex' if any_time == 1, fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI5.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

** Table SI 6
xtset gestfips
reg any_waiting `income' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m1
reg any_waiting `income' metro travel_all `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m2
reg any_waiting `income' metro travel_all worktime `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m3
reg any_waiting `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m4
reg any_waiting `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m5
xtreg any_waiting `income' metro travel_all worktime `demos' `edu' `family' `timex' if any_time == 1, fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI6.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

**Table SI 7
xtset gestfips
reg waiting_all `income' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m1
reg waiting_all `income' metro travel_all `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m2
reg waiting_all `income' metro travel_all worktime `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m3
reg waiting_all `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m4
reg waiting_all `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m5
xtreg waiting_all `income' metro travel_all worktime `demos' `edu' `family' `timex' if any_time == 1, fe cluster(gestfips)
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI7.tex", replace cell(b(fmt(2)) se p ci) ar2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

**Table SI 8
logit any_waiting `income' `timex' [pweight=tufnwgtp] if any_time == 1, vce(cluster gestfips)
margins, dydx(`income') post
est sto m1
logit any_waiting `income' metro travel_all `timex' [pweight=tufnwgtp] if any_time == 1, vce(cluster gestfips)
margins, dydx(`income') post
est sto m2
logit any_waiting `income' metro travel_all worktime `timex' [pweight=tufnwgtp] if any_time == 1, vce(cluster gestfips)
margins, dydx(`income') post
est sto m3
logit any_waiting `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp] if any_time == 1, vce(cluster gestfips)
margins, dydx(`income') post
est sto m4
logit any_waiting `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp] if any_time == 1, vce(cluster gestfips)
margins, dydx(`income') post
est sto m5
logit any_waiting `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp] if any_time == 1, vce(cluster gestfips)
margins, dydx(`income') post
est sto m6

esttab m1 m2 m3 m4 m5 m6 using "output\tableSI8.tex", replace cell(b(fmt(2)) se p ci) pr2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

**Table SI 9

reg any_waiting i.race_cat metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m1
reg any_waiting i.race_cat##i.hiloinc metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
est sto m2
reg waiting_all_nz i.race_cat metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp]
est sto m3
reg waiting_all_nz i.race_cat##i.hiloinc metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto m4
esttab m1 m2 m3 m4 using "output\tableSI9.tex", replace cell(b(fmt(2)) se p ci) pr2(2) nostar compress nogaps obslast tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

**Table SI 13
tobit waiting_all `income' `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(*) predict(ystar(0,.)) post
est sto m1
tobit waiting_all `income' metro travel_all `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(*) predict(ystar(0,.)) post
est sto m2
tobit waiting_all `income' metro travel_all worktime `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(*) predict(ystar(0,.)) post
est sto m3
tobit waiting_all `income' metro travel_all worktime `family' `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(*) predict(ystar(0,.)) post
est sto m4
tobit waiting_all `income' metro travel_all worktime `family' `demos' `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(*) predict(ystar(0,.)) post
est sto m5
tobit waiting_all `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(*) predict(ystar(0,.)) post
est sto m6
esttab m1 m2 m3 m4 m5 m6 using "output\tableSI13.tex", replace cell(b(fmt(2)) se p ci) pr2(2) nostar compress nogaps obslast keep(`income') tex label addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

**Table SI 14
reg waiting_all `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto ols
tobit waiting_all `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(`income') predict(ystar(0,.)) post
est sto tobit1
tobit waiting_all `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ll(0) ul(120) vce(cluster gestfips)
margins, dydx(`income') predict(ystar(0,.)) post
est sto tobit2
poisson waiting_all `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], vce(cluster gestfips)
margins, dydx(`income') post
est sto poisson1
cpoisson waiting_all `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ul vce(cluster gestfips)
margins, dydx(`income') post
est sto rcpoisson1
esttab ols tobit1 tobit2 poisson1 poisson2 using "output\tableSI14.tex",  replace b(2) se(2) ar2(2) star(* 0.10 ** 0.05 *** 0.01) compress nogaps obslast tex label keep(`income') mtitles("OLS" "Tobit" "2-Way Tobit" "Poisson" "RC Poisson") addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

**Table SI15
reg waiting_all_nz `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], cluster(gestfips)
est sto ols
tobit waiting_all_nz `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ll(0) vce(cluster gestfips)
margins, dydx(`income') predict(ystar(0,.)) post
est sto tobit1
tobit waiting_all_nz `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ll(0) ul(120) vce(cluster gestfips)
margins, dydx(`income') predict(ystar(0,.)) post
est sto tobit2
poisson waiting_all_nz `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], vce(cluster gestfips)
margins, dydx(`income') post
est sto poisson1
cpoisson waiting_all_nz `income' metro travel_all worktime `family' `demos' `educ' `timex' [pweight=tufnwgtp], ul vce(cluster gestfips)
margins, dydx(`income') post
est sto rcpoisson1
esttab ols tobit1 tobit2 poisson1 poisson2 using "output\tableSI15.tex",  replace b(2) se(2) ar2(2) star(* 0.10 ** 0.05 *** 0.01) compress nogaps obslast tex label keep(`income') mtitles("OLS" "Tobit" "2-Way Tobit" "Poisson" "RC Poisson") addnote("Robust standard errors clustered at the state-level (in parentheses); *p < .10 **p < .05 ***p < .01.")

clear all