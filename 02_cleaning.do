**This section codes up time of day for waiting time - replace the path in the cd command to the path where you stored the downloaded data files from the ATUS. This do file assumes all data files are stored in the same path.
cd "C:\\atusdata0319"
clear all
set more off
**Part 1. Set up the core variables: household characteristics (kids, spouse), demographics, SES, employment status, and diary date variables. These variables will come from the roster and CPS data files, primarily.
use "atusrost0319.dta"
sort tucaseid tulineno
save "atusrost0319.dta", replace
egen hhsize1 = count(_n), by(tucaseid)
egen hhsize = max(hhsize1), by(tucaseid)
egen hhchild1 = count(_n) if teage <= 17, by(tucaseid)
egen hhchild = max(hhchild1), by(tucaseid)
egen ygchage = min(teage), by(tucaseid)
replace ygchage = 0 if ygchage < 0
gen yngchild1 = 0
replace yngchild1 = 1 if ygchage <= 2
egen yngchild = max(yngchild1), by(tucaseid)
gen spouse1 = 0
replace spouse1 = 1 if terrp == 20
egen spouse = max(spouse1), by(tucaseid)
gen partner1 = 0
replace partner1 = 1 if terrp == 21
egen partner = max(partner1), by(tucaseid)
by tucaseid: drop if _n > 1
replace hhchild = 0 if hhchild == .
save "hhvars.dta", replace

clear all
set more off
use "atuscps0319.dta"
sort tucaseid tulineno
save "atuscps0319.dta", replace
merge 1:1 tucaseid tulineno using "atusrost0319.dta"
drop _merge
save "rostcps0319.dta", replace
sort tucaseid tulineno
gen resp = 0
replace resp = 1 if tulineno == 1
gen partner1 = 0
replace partner1 = 1 if (terrp == 21 | terrp == 20)
egen partner = max(partner1), by(tucaseid)
gen partage1 = teage if partner1 == 1
egen partage = max(partage1), by(tucaseid)
gen parteduc1 = peeduca if partner1 == 1
egen parteduc = max(parteduc1), by(tucaseid)
gen partemp1 = 1 if prempnot == 1 & partner1 == 1
egen partemp = max(partemp1), by(tucaseid)
sort tucaseid
by tucaseid: drop if _n > 1
save "rostcps0319.dta", replace
merge 1:1 tucaseid using "hhvars.dta"
drop _merge
save "rostcps0319.dta", replace

clear all
set more off
use "rostcps0319.dta"
merge 1:1 tucaseid using "atusresp0319.dta"
drop _merge
save "rostcpsresp0319.dta", replace
drop if tulineno != 1
gen married = 0
replace married = 1 if pemaritl ==1 | pemaritl==2
gen metro = 0
replace metro = 1 if gtmetsta ==1 | gemetsta ==1
gen loinc = 0
replace loinc = 1 if hufaminc <= 6 & hryear4 <= 2009 | hefaminc <= 6 & hryear4 >= 2010
gen inc2040 = 0
replace inc2040 = 1 if hufaminc >=7 & hufaminc <=10 & hryear4 <= 2009 | hefaminc >=7 & hefaminc <= 10 & hryear4 >= 2010
gen inc4060 = 0
replace inc4060 = 1 if hufaminc >= 11 & hufaminc <= 12 & hryear4 <=2009 | hefaminc >= 11 &hefaminc <= 12 & hryear >=2010
gen inc6075 = 0
replace inc6075 = 1 if hufaminc == 13 & hryear4 <= 2009 | hefaminc == 13 & hryear4 >= 2010
gen inc75100 = 0
replace inc75100 = 1 if hufaminc == 14 & hryear4 <= 2009 | hefaminc == 14 & hryear4 >= 2010
gen inc100150 = 0
replace inc100150 = 1 if hufaminc == 15 & hryear4 <= 2009 | hefaminc == 15 & hryear4 >= 2010
gen inc150p = 0
replace inc150p = 1 if hufaminc == 16 & hryear4 <= 2009 | hefaminc == 16 & hryear4 >= 2010
gen nopartner = 0
replace nopartner = 1 if partner == 0
gen partnohsdip = 0
replace partnohsdip = 1 if parteduc <= 38
gen parthsdip = 0
replace parthsdip = 1 if parteduc == 39
gen partsomcol = 0
replace partsomcol = 1 if parteduc >= 40 & parteduc <= 42
gen partcoldeg = 0
replace partcoldeg = 1 if parteduc >= 43
gen single_parent = 0
replace single_parent = 1 if (hhchild < 0 & partner == 0)
gen nohsdip = 0
replace nohsdip = 1 if peeduca <= 38
gen hsdip = 0
replace hsdip = 1 if peeduca == 39
gen somcol = 0
replace somcol = 1 if peeduca >= 40 & parteduc <= 42
gen coldeg = 0
replace coldeg = 1 if peeduca >= 43
gen white = 0
replace white = 1 if ptdtrace ==1
gen black = 0
replace black = 1 if ptdtrace ==2
gen native = 0
replace native = 1 if ptdtrace==3
gen asian = 0
replace asian = 1 if ptdtrace ==4
gen pacisl = 0
replace pacisl = 1 if ptdtrace ==5
gen multi = 0
replace multi = 1 if ptdtrace >=6
gen male = 0
replace male = 1 if tesex ==1
gen otherrc = 0
replace otherrc = 1 if pacisl == 1 | multi == 1
gen hisp = 0
replace hisp = 1 if pehspnon ==1
gen wkend = 0
replace wkend = 1 if tudiaryday ==1 | tudiaryday ==7
gen tuthurs = 0
replace tuthurs = 1 if tudiaryday >= 3 & tudiaryday <= 5
gen sun = 0
replace sun = 1 if tudiaryday == 1
gen mon = 0
replace mon = 1 if tudiaryday == 2
gen tue = 0
replace tue = 1 if tudiaryday == 3
gen wed = 0
replace wed = 1 if tudiaryday == 4
gen thr = 0
replace thr = 1 if tudiaryday == 5
gen fri = 0
replace fri = 1 if tudiaryday == 6
gen sat = 0
replace sat = 1 if tudiaryday == 7
gen yr2003 = 0
replace yr2003 = 1 if tuyear == 2003
gen yr2004 = 0
replace yr2004 = 1 if tuyear == 2004
gen yr2005 = 0
replace yr2005 = 1 if tuyear == 2005
gen yr2006 = 0
replace yr2006 = 1 if tuyear == 2006
gen yr2007 = 0
replace yr2007 = 1 if tuyear == 2007
gen yr2008 = 0
replace yr2008 = 1 if tuyear == 2008
gen yr2009 = 0
replace yr2009 = 1 if tuyear == 2009
gen yr2010 = 0
replace yr2010 = 1 if tuyear == 2010
gen yr2011 = 0
replace yr2011 = 1 if tuyear == 2011
gen yr2012 = 0
replace yr2012 = 1 if tuyear == 2012
gen yr2013 = 0
replace yr2013 = 1 if tuyear == 2013
gen yr2014 = 0
replace yr2014 = 1 if tuyear == 2014
gen yr2015 = 0
replace yr2015 = 1 if tuyear == 2015
gen yr2016 = 0
replace yr2016 = 1 if tuyear == 2016
gen yr2017 = 0
replace yr2017 = 1 if tuyear == 2017
gen yr2018 = 0
replace yr2018 = 1 if tuyear == 2018
gen yr2019 = 0
replace yr2019 = 1 if tuyear == 2019
gen jan = 0
replace jan = 1 if tumonth == 1
gen feb = 0
replace feb = 1 if tumonth == 2
gen mar = 0
replace mar = 1 if tumonth == 3
gen apr = 0
replace apr = 1 if tumonth == 4
gen may = 0
replace may = 1 if tumonth == 5
gen jun = 0
replace jun = 1 if tumonth == 6
gen jul = 0
replace jul = 1 if tumonth == 7
gen aug = 0
replace aug = 1 if tumonth == 8
gen sep = 0
replace sep = 1 if tumonth == 9
gen oct = 0
replace oct = 1 if tumonth == 10
gen nov = 0
replace nov = 1 if tumonth == 11
gen dec = 0
replace dec = 1 if tumonth == 12
gen summer = 0
replace summer = 1 if (jun == 1 | jul == 1 | aug == 1)
gen employed = 0
replace employed = 1 if prempnot == 1
gen col_enroll = 0
replace col_enroll = 1 if (teschenr == 1 & teschlvl == 2)
gen unemployed = 0
replace unemployed = 1 if employed == 0
gen public = 0
replace public = 1 if (prdtcow1 == 7 | prdtcow1 == 8 | prdtcow1 == 9)
replace public = . if prdtcow1 < 5
gen private = 0
replace private = 1 if (prdtcow1 == 5 | prdtcow1 == 6)
replace private = . if prdtcow1 < 5
gen selfemployed = 0
replace selfemployed = 1 if prdtcow1 == 10
replace selfemployed = . if prdtcow1 < 5
gen unpaid = 0
replace unpaid = 1 if prdtcow1 == 11
replace unpaid = . if prdtcow1 < 5
gen fed = 0
replace fed = 1 if prdtcow1 == 7
gen state = 0
replace state = 1 if prdtcow1 == 8
gen locgov = 0
replace locgov = 1 if prdtcow1 == 9
save "respondentx0319.dta", replace

**Part 2. Time use variables. For simplicity in coding waiting times, I use the summary file. However, I turn to the activity file for the time of day analysis.
clear all
set more off
use "atussum0319.dta"
sort tucaseid tuyear
save "atussum0319.dta", replace
clear all
use "respondentx0319.dta"
merge 1:1 tucaseid tuyear using "atussum0319.dta"
drop _merge
save "atusall0319.dta", replace

**clear all
set more off
use "atusact0319.dta"
sort tucaseid
gen double starttime = clock(tustarttim, "hms")
format starttime %tc
gen double endtime = clock(tustoptime, "hms")
format endtime %tc

gen starttime_num = hh(starttime)
gen endtime_num = hh(endtime)

gen am = 0
replace am = 1 if (starttime_num >= 5 & starttime_num < 11)
gen lunch = 0
replace lunch = 1 if (starttime_num >= 11 & starttime_num < 14)
gen afternoon = 0
replace afternoon = 1 if (starttime_num >= 14 & starttime_num < 18)
gen evening = 0
replace evening = 1 if (starttime_num >= 18 & starttime_num <= 24)

egen waiting_am1 = sum(tuactdur24) if ((trcodep == 030204 | trcodep == 030303 | trcodep == 030405 | trcodep == 040204 | trcodep == 040303 | trcodep == 040405 | trcodep == 040508 | trcodep == 060103 | trcodep == 060403 | trcodep == 070105 | trcodep == 080102 | trcodep == 080203 | trcodep == 080302 | trcodep == 080403 | trcodep == 080502 | trcodep == 090104 | trcodep == 090202 | trcodep == 100381 | trcodep == 100383 | trcodep == 100399) & (am == 1)), by(tucaseid)
egen waiting_am = max(waiting_am1), by(tucaseid)
egen waiting_lu1 = sum(tuactdur24) if ((trcodep == 030204 | trcodep == 030303 | trcodep == 030405 | trcodep == 040204 | trcodep == 040303 | trcodep == 040405 | trcodep == 040508 | trcodep == 060103 | trcodep == 060403 | trcodep == 070105 | trcodep == 080102 | trcodep == 080203 | trcodep == 080302 | trcodep == 080403 | trcodep == 080502 | trcodep == 090104 | trcodep == 090202 | trcodep == 100381 | trcodep == 100383 | trcodep == 100399) & (lunch == 1)), by(tucaseid)
egen waiting_lu = max(waiting_lu1), by(tucaseid)
egen waiting_af1 = sum(tuactdur24) if ((trcodep == 030204 | trcodep == 030303 | trcodep == 030405 | trcodep == 040204 | trcodep == 040303 | trcodep == 040405 | trcodep == 040508 | trcodep == 060103 | trcodep == 060403 | trcodep == 070105 | trcodep == 080102 | trcodep == 080203 | trcodep == 080302 | trcodep == 080403 | trcodep == 080502 | trcodep == 090104 | trcodep == 090202 | trcodep == 100381 | trcodep == 100383 | trcodep == 100399) & (afternoon == 1)), by(tucaseid)
egen waiting_af = max(waiting_af1), by(tucaseid)
egen waiting_ev1 = sum(tuactdur24) if ((trcodep == 030204 | trcodep == 030303 | trcodep == 030405 | trcodep == 040204 | trcodep == 040303 | trcodep == 040405 | trcodep == 040508 | trcodep == 060103 | trcodep == 060403 | trcodep == 070105 | trcodep == 080102 | trcodep == 080203 | trcodep == 080302 | trcodep == 080403 | trcodep == 080502 | trcodep == 090104 | trcodep == 090202 | trcodep == 100381 | trcodep == 100383 | trcodep == 100399) & (evening == 1)), by(tucaseid)
egen waiting_ev = max(waiting_ev1), by(tucaseid)

keep tucaseid waiting_am waiting_lu waiting_af waiting_ev
by tucaseid: drop if _n > 1

save "waiting_tod.dta", replace

merge 1:1 tucaseid using "atusall0319.dta"
drop _merge
save "atusall0319.dta", replace

foreach x of varlist waiting_am waiting_lu waiting_af waiting_ev{
	replace `x' = 0 if `x' == .
	gen `x'_nz = `x' if `x' > 0 
}

label var waiting_am "Morning"
label var waiting_lu "Lunchtime"
label var waiting_af "Afternoon"
labe var waiting_ev "Evening"

label var waiting_am_nz "Morning"
label var waiting_lu_nz "Lunchtime"
label var waiting_af_nz "Afternoon"
labe var waiting_ev_nz "Evening"

save "atusall0319.dta", replace

**Part 3. Codes waiting time variables and additional variables needed for the analysis. Adds variable labels to make clean figures easy to create.
/*
Codes for waiting: waiting_hhchedu = 030204; waiting_hhchhth = 030303; waiting_hhadcare = 030405; waiting_hhadults = 030504; waiting_nonhhchedu = 040204; waiting_nonhhchhlth = 040303; waiting_nonhhadult = 040405; waiting_nonhhadhlp = 040508; waiting_class = 060103; waiting_educadmin = 060403; waiting_shopping = 070105; waiting_childcare = 080102; waiting_finance = 080203; waiting_legal = 080302; waiting_medical = 080403; waiting_personalcare = 080502; waiting_hhservice = 090104; waiting_hmaint = 090202; waiting_gov = 100381; waiting_civic = 100383; waiting_gov_undef = 100399
*/
rename t030204 waiting_hhchedu
rename t030303 waiting_hhchhth
rename t030405 waiting_hhadcare
rename t030504 waiting_hhadults 
rename t040204 waiting_nonhhchedu
rename t040303 waiting_nonhhchhlth 
rename t040405 waiting_nonhhadult 
rename t040508 waiting_nonhhadhlp 
rename t060103 waiting_class
rename t060403 waiting_educadmin
rename t070105 waiting_shopping 
rename t080102 waiting_childcare 
rename t080203 waiting_finance
rename t080302 waiting_legal
rename t080403 waiting_medical
rename t080502 waiting_personalcare
rename t090104 waiting_hhservice
rename t090202 waiting_hmaint
rename t100381 waiting_gov
rename t100383 waiting_civic
rename t100399 waiting_gov_undef

gen waiting_all = (waiting_gov + waiting_civic + waiting_gov_undef + waiting_hhservice + waiting_personalcare + waiting_medical + waiting_legal + waiting_finance + waiting_childcare + waiting_shopping + waiting_educadmin + waiting_class + waiting_nonhhadult + waiting_nonhhchhlth + waiting_nonhhchedu + waiting_hhadults + waiting_hhadcare + waiting_hhchhth + waiting_hhchedu + waiting_hmaint + waiting_nonhhadhlp)

gen waiting_meds = (waiting_medical + waiting_hhchhth)

gen waiting_consumption = (waiting_shopping + waiting_personalcare)

gen worktime = (t050101 + t050102 + t050189 + t050289 + t059999)

gen travel_perscare = (t180101 + t180199)
gen travel_hhact = t180280
gen travel_hhcare = (t180381 + t180382 + t180399)
gen travel_nonhhcare = (t180481 + t180482 + t180499)
gen travel_educ = (t180601 + t180682 + t180699)
gen travel_shopping = (t180701 + t180782)
gen travel_childcare = (t180801)
gen travel_financial = t180802
gen travel_legal = t180803
gen travel_medical = t180804
gen travel_personalcare = t180805
gen travel_vet = t180807
gen travel_household = (t180901 + t180902 + t180903 + t180904 + t180905 + t180999)
gen travel_gov = (t181002 + t181081 + t181099)

gen travel_all = (travel_hhcare + travel_nonhhcare + travel_educ + travel_shopping + travel_childcare + travel_financial + travel_legal + travel_medical + travel_personalcare + travel_household + travel_gov)

gen travel_med = (travel_hhcare + travel_medical)

foreach x of varlist waiting_all waiting_shopping waiting_meds travel_all worktime{
	gen `x'_nz = `x' if (`x' > 0 & `x' != .)
}

gen care_hhchildedu = (t030201 + t030202 + t030203 + t030299)
gen care_hhchildhlth = (t030301 + t030302 + t030399)
gen care_hhadultshlth = (t030401 + t030402 + t030403 + t030404 + t030499)
gen care_hhadultsaid = (t030501 + t030502 + t030503 + t030599)
gen care_nonhhchiedu = (t040201 + t040202 + t040203 + t040299)
gen care_nonhhchihlth = (t040301 + t040302 + t040399)
gen care_nonhhadults = (t040401 + t040402 + t040403 + t040404 + t040499)
gen class_time = (t060101 + t060102 + t060199)
gen educ_admin = (t060401 + t060402 + t060499)
gen shopping = (t070101 + t070102 + t070103 + t070104 + t070199)
gen childcare = (t080101 + t080199)
gen financial = (t080201 + t080202 + t080299)
gen legal = (t080301 + t080399)
gen medical = (t080401 + t080402 + t080499)
gen personal_care = (t080501 + t080599)
gen hhservice = (t090101 + t090102 + t090103 + t090199)
gen hhmaintence = (t090201 + t090299)
gen gov_time = (t100101 + t100102 + t100103 + t100199 + t100201 + t100299 + t109999)

gen any_time = 0
replace any_time = 1 if (care_hhchildedu > 0 | care_hhchildhlth > 0 | care_hhadultshlth > 0 | care_hhadultsaid > 0 | care_nonhhchiedu > 0 | care_nonhhchihlth > 0 | care_nonhhadults > 0 | class_time > 0 | educ_admin > 0 | shopping > 0 | childcare > 0 | financial > 0 | legal > 0 | medical > 0 | personal_care > 0 | hhservice > 0 | hhmaintence > 0 | gov_time > 0)

gen age = teage

gen disability = 0 if prdisflg == 2
replace disability = 1 if prdisflg == 1

gen female = 1 if male == 0
replace female = 0 if male == 1

gen year = tuyear
label def year 2003 "2003" 2004 "2004" 2005 "2005" 2006 "2006" 2007 "2007" 2008 "2008" 2009 "2009" 2010 "2010" 2011 "2011" 2012 "2012" 2013 "2013" 2014 "2014" 2015 "2015" 2016 "2016" 2017 "2017" 2018 "2018" 2019 "2019"
label val year year

gen income_cat = .
replace income_cat = 1 if loinc == 1
replace income_cat = 2 if inc2040 == 1
replace income_cat = 3 if inc4060 == 1
replace income_cat = 4 if inc6075 == 1
replace income_cat = 5 if inc75100 == 1
replace income_cat = 6 if inc100150 == 1
replace income_cat = 7 if inc150p == 1

label define inccat 1 "< $20K" 2 "$20K to $40K" 3 "$40K to 60K" 4 "$60K to 75K" 5 "$75K to $100K" 6 "$100K to $150K" 7 "> $150K"
label val income_cat inccat
label define weekend 0 "Weekday" 1 "Weekend" , replace
label values wkend weekend
label var married "R is married"
label var metro "Urban area"
label var loinc "HH income $20K or less"
label var inc2040 "HH income $20K to $40K"
label var inc4060 "HH income $40K to $60K"
label var inc6075 "HH income $60K to $75K"
label var inc75100 "HH income $75K to $100K"
label var inc100150 "HH income $100K to $150K"
label var inc150p "HH income $150K or more"
label var white "White"
label var black "Black"
label var native "Native American"
label var asian "Asian"
label var pacisl "Pacific Islander/Hawaiian"
label var multi "Multiple races"
label var male "Male"
label var otherrc "Other race"
label var hisp "Latino(a)"
label var wkend "Weekend"
label var tuthur "Tuesday through Thursday"
label var sun "Sunday"
label var mon "Monday"
label var tue "Tuesday"
label var wed "Wednesday"
label var thr "Thursday"
label var fri "Friday"
label var sat "Saturday"
label var jan "January"
label var feb "February"
label var mar "March"
label var apr "April"
label var may "May"
label var jun "June"
label var jul "July"
label var aug "August"
label var sep "September"
label var oct "October"
label var nov "November"
label var dec "December"
label var summer "Summer"
label var hhsize "HH size"
label var yngchild "Child younger than 2 present"
label var worktime "Time spent working"
label var worktime_nz "Time spent working; T | T > 0"
label var waiting_all "Time spent waiting; T in minutes"
label var waiting_all_nz "Time spent waiting; T | T > 0"
label var travel_all "Time spent traveling"
label var travel_all_nz "Time spent traveling; T | T > 0"
label var waiting_meds "Time spent waiting on medical service"
label var waiting_meds_nz "Time spent waiting on medical service; T | T > 0"
label var waiting_shopping "Time spent waiting while shopping"
label var waiting_shopping_nz "Time spent waiting while shopping; T | T > 0"

gen no_waiting = 0
replace no_waiting = 1 if waiting_all == 0
gen any_waiting = 0
replace any_waiting = 1 if waiting_all > 0
gen any_wait_am = 0
replace any_wait_am = 1 if waiting_am > 0
gen any_wait_lu = 0
replace any_wait_lu = 1 if waiting_lu > 0
gen any_wait_af = 0
replace any_wait_af = 1 if waiting_af > 0
gen any_wait_ev = 0
replace any_wait_ev = 1 if waiting_ev > 0

gen hiloinc = .
replace hiloinc = 1 if loinc == 1
replace hiloinc = 2 if inc150p == 1

gen hilowfemale = .
replace hilowfemale = 1 if hiloinc == 1 & female == 0
replace hilowfemale = 2 if hiloinc == 1 & female == 1
replace hilowfemale = 3 if hiloinc == 2 & female == 0
replace hilowfemale = 4 if hiloinc == 2 & female == 1
label define hlf 1 "Low-income Men" 2 "Low-income Women" 3 "High-income Men" 4 "High-income Women"
label val hilowfemale hlf

gen hilobw = .
replace hilobw = 1 if hiloinc == 1 & white == 1
replace hilobw = 2 if hiloinc == 1 & black == 1
replace hilobw = 3 if hiloinc == 2 & white == 1
replace hilobw = 4 if hiloinc == 2 & black == 1
label define hlbw 1 "Low-income White" 2 "Low-income Black" 3 "High-income White" 4 "High-income Black"
label val hilobw hlbw

gen race_cat = .
replace race_cat = 1 if white == 1 & hisp == 0
replace race_cat = 2 if black == 1 & hisp == 0
replace race_cat = 3 if hisp == 1
replace race_cat = 4 if (asian == 1 | pacisl == 1)
label define racecat4 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian"
label val race_cat racecat4
save "atusall0319.dta", replace
