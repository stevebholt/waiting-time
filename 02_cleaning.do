**This section codes up time of day for waiting time - replace the path in the cd command to the path where you stored the downloaded data files from the ATUS. This do file assumes all data files are stored in the same path.
use "atusact0319.dta"
/*
Codes for waiting: waiting_hhchedu = 030204; waiting_hhchhth = 030303; waiting_hhadcare = 030405; waiting_hhadults = 030504; waiting_nonhhchedu = 040204; waiting_nonhhchhlth = 040303; waiting_nonhhadult = 040405; waiting_nonhhadhlp = 040508; waiting_class = 060103; waiting_educadmin = 060403; waiting_shopping = 070105; waiting_childcare = 080102; waiting_finance = 080203; waiting_legal = 080302; waiting_medical = 080403; waiting_personalcare = 080502; waiting_hhservice = 090104; waiting_hmaint = 090202; waiting_gov = 100381; waiting_civic = 100383; waiting_gov_undef = 100399
*/
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

clear all

**Add merge code here**

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

clear all

cd "C:\Users\sbhst\OneDrive\Documents\albany\projects\waiting_time\"
/*
**Section for time of day spent waiting and traveling.
**Start time of a given activity
clear all
set more off
use "atusall0319.dta"
*/
set more off

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

gen travel_consumption = (travel_shopping + travel_personalcare)

gen travel_childedu = (travel_childcare + t180381)

gen waiting_all = (waiting_gov + waiting_civic + waiting_gov_undef + waiting_hhservice + waiting_personalcare + waiting_medical + waiting_legal + waiting_finance + waiting_childcare + waiting_shopping + waiting_educadmin + waiting_class + waiting_nonhhadult + waiting_nonhhchhlth + waiting_nonhhchedu + waiting_hhadults + waiting_hhadcare + waiting_hhchhth + waiting_hhchedu + waiting_hmaint + waiting_nonhhadhlp)

gen waiting_hh = (waiting_gov + waiting_civic + waiting_gov_undef + waiting_hhservice + waiting_personalcare + waiting_medical + waiting_legal + waiting_finance + waiting_childcare + waiting_shopping + waiting_educadmin + waiting_class + waiting_hhadults + waiting_hhadcare + waiting_hhchhth + waiting_hhchedu + waiting_hmaint)

gen waiting_meds = (waiting_medical + waiting_hhchhth)

gen waiting_consumption = (waiting_shopping + waiting_personalcare)

gen waiting_childedu = (waiting_childcare + waiting_hhchedu)

gen worktime = (t050101 + t050102 + t050189 + t050289 + t059999)

foreach x of varlist waiting_all waiting_childedu waiting_consumption waiting_meds travel_all worktime{
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
label var waiting_consumption "Time spent waiting while shopping"

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
save "atusall0319.dta", replace
clear all
