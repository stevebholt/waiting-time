use "atusall0319.dta"

local summaryx any_waiting waiting_all waiting_all_nz travel_all loinc inc2040 inc4060 inc6075 inc75100 inc100150 inc150p white black native asian pacisl multi otherrc hisp age female male nohsdip hsdip somcol coldeg married hhchild yngchild metro
local timex yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 yr2012 yr2013 yr2014 yr2015 yr2016 yr2017 yr2018 yr2019 feb mar apr may jun jul aug sep oct nov dec mon tue wed thr fri sat
local income loinc inc2040 inc4060 inc6075 inc75100 inc100150 
local demos  black native asian pacisl multi otherrc hisp age female
local edu hsdip somcol coldeg unemployed
local family married hhchild yngchild


** Figure 1
reg waiting_meds_nz i.hiloinc metro travel_all worktime unemployed `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hiloinc, post
est sto medc

reg waiting_meds_nz i.hiloinc `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hiloinc, post
est sto mednc

coefplot (mednc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No controls")||(medc, fcolor(gs5) finten(80) lcolor(black)), bylabel("Controls")||, recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") ytitle("Minutes Spent Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(5)55) nooffset

graph export "figures\fig1.pdf", as(pdf)   replace

**Figure 2
reg waiting_shopping_nz i.hiloinc metro travel_all worktime unemployed `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hiloinc, post
est sto shopc

reg waiting_shopping_nz i.hiloinc `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hiloinc, post
est sto shopnc

coefplot (shopnc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No controls")||(shopc, fcolor(gs5) finten(80) lcolor(black)), bylabel("Controls")||, recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") ytitle("Minutes Spent Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(5)55) nooffset

graph export "figures\fig2.pdf", as(pdf)   replace

**Figure 3
reg any_waiting i.race_cat metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if hiloinc == 1 & any_time == 1, cluster(gestfips)
margins i.race_cat, post
est sto lowrace

reg any_waiting i.race_cat metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if hiloinc == 2 & any_time == 1, cluster(gestfips)
margins i.race_cat, post
est sto hirace

coefplot (lowrace, fcolor(gs5) finten(80) lcolor(black)), bylabel("Low-income") || (hirace, fcolor(gs5) finten(80) lcolor(black)), bylabel("High-income") ||, recast(bar) barw(.40) xlabel(, angle(45)) xtitle("") title("") ytitle("Probability of Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(.05).2) nooffset

graph export "figures\fig3.pdf", as(pdf)   replace

** Figure 4
reg waiting_all_nz i.race_cat metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if hiloinc == 1, cluster(gestfips)
margins i.race_cat, post
est sto lowrace

reg waiting_all_nz i.race_cat metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if hiloinc == 2, cluster(gestfips)
margins i.race_cat, post
est sto hirace

coefplot (lowrace, fcolor(gs5) finten(80) lcolor(black)), bylabel("Low-income") || (hirace, fcolor(gs5) finten(80) lcolor(black)), bylabel("High-income") ||, recast(bar) barw(.40) xlabel(, angle(45)) xtitle("") title("") ytitle("Minutes Spent Waiting; T| T>0") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(5)70) nooffset

graph export "figures\fig4.pdf", as(pdf)   replace

**Figure 5
reg waiting_am_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 0, cluster(gestfips)
margins, post
est sto amlo
reg waiting_lu_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 0, cluster(gestfips)
margins, post
est sto lulo
reg waiting_af_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 0, cluster(gestfips)
margins, post
est sto aflo
reg waiting_ev_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 0, cluster(gestfips)
margins, post
est sto evlo

reg waiting_am_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 0, cluster(gestfips)
margins, post
est sto amhi
reg waiting_lu_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 0, cluster(gestfips)
margins, post
est sto luhi
reg waiting_af_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 0, cluster(gestfips)
margins, post
est sto afhi
reg waiting_ev_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 0, cluster(gestfips)
margins, post
est sto evhi

coefplot (amlo, fcolor(gs5) finten(20) lcolor(black) keep(_cons) offset(-0.5) label("Morning (5 am to 10:59 am)")) (lulo, fcolor(gs5) finten(40) lcolor(black) keep(_cons) offset(-0.2) label("Lunch (11 am to 1:59 pm)")) (aflo, fcolor(gs5) finten(60) lcolor(black) keep(_cons) offset(0.1) label("Afternoon (2 pm to 5:59 pm)")) (evlo, fcolor(gs5) finten(80) lcolor(black) keep(_cons) offset(0.4) label("Evening (6 pm to 12 am)")), bylabel("Low-income")||(amhi, fcolor(gs5) finten(20) lcolor(black) keep(_cons) offset(-0.5) label("Morning (5 am to 10:59 am)")) (luhi, fcolor(gs5) finten(40) lcolor(black) keep(_cons) offset(-0.2) label("Lunch (11 am to 1:59 pm)")) (afhi, fcolor(gs5) finten(60) lcolor(black) keep(_cons) offset(0.1) label("Afternoon (2 pm to 5:59 pm)")) (evhi, fcolor(gs5) finten(80) lcolor(black) keep(_cons) offset(0.4) label("Evening (6 pm to 12 am)")), bylabel("High-income")||, recast(bar) barw(.20) xlabel("") xtitle("") title("") ytitle("Minutes Spent Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) ylabel(0(5)65) 

graph export "figures\fig5.pdf", as(pdf)   replace


**Figure SI 1
reg any_time i.hilowfemale metro travel_all worktime unemployed `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hilowfemale, post
est sto intfem

reg any_time i.hilowfemale metro travel_all worktime unemployed `timex' [pweight=tufnwgtp] if hhchild > 0, cluster(gestfips)
margins i.hilowfemale, post
est sto intfem3

coefplot (intfem, fcolor(gs5) finten(60) lcolor(black)), bylabel("All")||(intfem3, fcolor(gs5) finten(80) lcolor(black)), bylabel("Parents")||, recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") ytitle("Probability of Using Services") vertical citop ciopt(recast(rcap) lcolor(black)) ylabel(0(0.1)1) nooffset

graph export "figures\figSI1.pdf", as(pdf)   replace

**Figure SI 2
reg any_waiting i.hilowfemale metro travel_all worktime unemployed `timex' [pweight=tufnwgtp] if any_time == 1, cluster(gestfips)
margins i.hilowfemale, post
est sto intfem

reg any_waiting i.hilowfemale metro travel_all worktime unemployed `timex' [pweight=tufnwgtp] if hhchild > 0 & any_time == 1, cluster(gestfips)
margins i.hilowfemale, post
est sto intfem3

coefplot (intfem, fcolor(gs5) finten(60) lcolor(black)), bylabel("All")||(intfem3, fcolor(gs5) finten(80) lcolor(black)), bylabel("Parents")||, recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") ytitle("Probability of Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) ylabel(0(0.05).2) nooffset

graph export "figures\figSI2.pdf", as(pdf)   replace

**Figure SI 3
reg waiting_all_nz i.hilowfemale metro travel_all worktime unemployed `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.hilowfemale, post
est sto intfem2

reg waiting_all_nz i.hilowfemale metro travel_all worktime unemployed `timex' [pweight=tufnwgtp] if hhchild > 0, cluster(gestfips)
margins i.hilowfemale, post
est sto intfem4

coefplot (intfem2, fcolor(gs5) finten(60) lcolor(black)), bylabel("All")||(intfem4, fcolor(gs5) finten(80) lcolor(black)), bylabel("Parents")||, recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") ytitle("Minutes Spent Waiting; T| T>0") vertical citop ciopt(recast(rcap) lcolor(black)) ylabel(0(5)70) nooffset

graph export "figures\figSI3.pdf", as(pdf)   replace


**Figure SI 4
reg any_waiting i.income_cat `timex', cluster(gestfips)
margins i.income_cat, post
est sto m1nc

xtreg any_waiting i.income_cat metro travel_all worktime `demos' `edu' `family' `timex', fe i(gestfips) cluster(gestfips)
margins i.income_cat, post
est sto m1c
coefplot (m1nc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No controls")||(m1c, fcolor(gs5) finten(80) lcolor(black)), bylabel("All controls")||, ytitle("Likelihood of Any Wait") ylabel(0(0.01).1) recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) nooffset

graph export "figures\figSI4.pdf", as(pdf)   replace

**Figure SI 5
reg any_waiting i.income_cat `timex' if any_time == 1, cluster(gestfips)
margins i.income_cat, post
est sto m2nc

xtreg any_waiting i.income_cat metro unemployed travel_all worktime `demos' `edu' `family' `timex' if any_time == 1, fe i(gestfips) cluster(gestfips)
margins i.income_cat, post
est sto m2c
coefplot (m2nc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No controls")||(m2c, fcolor(gs5) finten(80) lcolor(black)), bylabel("All controls")||, ytitle("Likelihood of Any Wait") ylabel(0(0.01).1) recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) nooffset

graph export "figures\figSI5.pdf", as(pdf)   replace

**Figure SI 6
reg waiting_all i.income_cat `timex', cluster(gestfips)
margins i.income_cat, post
est sto m3nc

xtreg waiting_all i.income_cat metro unemployed travel_all worktime `demos' `edu' `family' `timex', fe i(gestfips) cluster(gestfips)
margins i.income_cat, post
est sto m3c

coefplot (m3nc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No controls")||(m3c, fcolor(gs5) finten(80) lcolor(black)), bylabel("All controls")||, ytitle("Minutes Waiting") ylabel(0(0.10)2.25) recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) nooffset

graph export "figures\figSI6.pdf", as(pdf)   replace


**Figure SI 7
reg waiting_all_nz i.income_cat `timex', cluster(gestfips)
margins i.income_cat, post
est sto m4nc

xtreg waiting_all_nz i.income_cat metro unemployed travel_all worktime `demos' `edu' `family' `timex', fe i(gestfips) cluster(gestfips)
margins i.income_cat, post
est sto m4c

coefplot (m4nc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No controls")||(m4c, fcolor(gs5) finten(80) lcolor(black)), bylabel("All controls")||, ytitle("Minutes Waiting") ylabel(0(5)55) recast(bar) barw(.60) xlabel(, angle(45)) xtitle("") title("") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) nooffset

graph export "figures\figSI7.pdf", as(pdf)   replace


**Figure SI 8
reg waiting_all_nz i.race_cat `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.race_cat, post
est sto racenc

reg waiting_all_nz i.race_cat `income' metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.race_cat, post
est sto racewc

coefplot (racenc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No Controls") || (racewc, fcolor(gs5) finten(80) lcolor(black)), bylabel("Controls") ||, recast(bar) barw(.40) xlabel(, angle(45)) xtitle("") title("") ytitle("Minutes Spent Waiting; T| T>0") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(5)70) nooffset

graph export "figures\figSI8.pdf", as(pdf)   replace

**Figure SI 9
reg any_waiting i.race_cat `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.race_cat, post
est sto racenc

reg any_waiting i.race_cat `income' metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp], cluster(gestfips)
margins i.race_cat, post
est sto racewc

coefplot (racenc, fcolor(gs5) finten(80) lcolor(black)), bylabel("No Controls") || (racewc, fcolor(gs5) finten(80) lcolor(black)), bylabel("Controls") ||, recast(bar) barw(.40) xlabel(, angle(45)) xtitle("") title("") ytitle("Probability of Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(0.01)0.1) nooffset

graph export "figures\figSI9.pdf", as(pdf)   replace

**Figure SI 10
reg any_waiting i.race_cat `income' metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if hiloinc == 1, cluster(gestfips)
margins i.race_cat, post
est sto racelow

reg any_waiting i.race_cat `income' metro unemployed travel_all worktime `family' `timex' [pweight=tufnwgtp] if hiloinc == 2, cluster(gestfips)
margins i.race_cat, post
est sto racehi

coefplot (racelow, fcolor(gs5) finten(80) lcolor(black)), bylabel("No Controls") || (racehi, fcolor(gs5) finten(80) lcolor(black)), bylabel("Controls") ||, recast(bar) barw(.40) xlabel(, angle(45)) xtitle("") title("") ytitle("Probability of Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) byopts(legend(off)) ylabel(0(0.01)0.1) nooffset

graph export "figures\figSI10.pdf", as(pdf)   replace


**Figure SI 11
reg waiting_am_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1, cluster(gestfips)
margins, post
est sto amlo
reg waiting_lu_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1, cluster(gestfips)
margins, post
est sto lulo
reg waiting_af_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1, cluster(gestfips)
margins, post
est sto aflo
reg waiting_ev_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1, cluster(gestfips)
margins, post
est sto evlo

reg waiting_am_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1, cluster(gestfips)
margins, post
est sto amhi
reg waiting_lu_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1, cluster(gestfips)
margins, post
est sto luhi
reg waiting_af_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1, cluster(gestfips)
margins, post
est sto afhi
reg waiting_ev_nz i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1, cluster(gestfips)
margins, post
est sto evhi

coefplot (amlo, fcolor(gs5) finten(20) lcolor(black) keep(_cons) offset(-0.5) label("Morning (5 am to 10:59 am)")) (lulo, fcolor(gs5) finten(40) lcolor(black) keep(_cons) offset(-0.2) label("Lunch (11 am to 1:59 pm)")) (aflo, fcolor(gs5) finten(60) lcolor(black) keep(_cons) offset(0.1) label("Afternoon (2 pm to 5:59 pm)")) (evlo, fcolor(gs5) finten(80) lcolor(black) keep(_cons) offset(0.4) label("Evening (6 pm to 12 am)")), bylabel("Low-income")||(amhi, fcolor(gs5) finten(20) lcolor(black) keep(_cons) offset(-0.5) label("Morning (5 am to 10:59 am)")) (luhi, fcolor(gs5) finten(40) lcolor(black) keep(_cons) offset(-0.2) label("Lunch (11 am to 1:59 pm)")) (afhi, fcolor(gs5) finten(60) lcolor(black) keep(_cons) offset(0.1) label("Afternoon (2 pm to 5:59 pm)")) (evhi, fcolor(gs5) finten(80) lcolor(black) keep(_cons) offset(0.4) label("Evening (6 pm to 12 am)")), bylabel("High-income")||, recast(bar) barw(.20) xlabel("") xtitle("") title("") ytitle("Minutes Spent Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) ylabel(0(5)65) 

graph export "figures\figSI11.pdf", as(pdf)   replace


**Figure SI 12
reg any_wait_am i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto amlo
reg any_wait_lu i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto lulo
reg any_wait_af i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto aflo
reg any_wait_ev i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 1 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto evlo

reg any_wait_am i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto amhi
reg any_wait_lu i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto luhi
reg any_wait_af i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto afhi
reg any_wait_ev i.tuyear i.tumonth [pweight=tufnwgtp] if hiloinc == 2 & wkend == 1 & any_time == 1, cluster(gestfips)
margins, post
est sto evhi

coefplot (amlo, fcolor(gs5) finten(20) lcolor(black) keep(_cons) offset(-0.5) label("Morning (5 am to 10:59 am)")) (lulo, fcolor(gs5) finten(40) lcolor(black) keep(_cons) offset(-0.2) label("Lunch (11 am to 1:59 pm)")) (aflo, fcolor(gs5) finten(60) lcolor(black) keep(_cons) offset(0.1) label("Afternoon (2 pm to 5:59 pm)")) (evlo, fcolor(gs5) finten(80) lcolor(black) keep(_cons) offset(0.4) label("Evening (6 pm to 12 am)")), bylabel("Low-income")||(amhi, fcolor(gs5) finten(20) lcolor(black) keep(_cons) offset(-0.5) label("Morning (5 am to 10:59 am)")) (luhi, fcolor(gs5) finten(40) lcolor(black) keep(_cons) offset(-0.2) label("Lunch (11 am to 1:59 pm)")) (afhi, fcolor(gs5) finten(60) lcolor(black) keep(_cons) offset(0.1) label("Afternoon (2 pm to 5:59 pm)")) (evhi, fcolor(gs5) finten(80) lcolor(black) keep(_cons) offset(0.4) label("Evening (6 pm to 12 am)")), bylabel("High-income")||, recast(bar) barw(.20) xlabel("") xtitle("") title("") ytitle("Probability of Waiting") vertical citop ciopt(recast(rcap) lcolor(black)) ylabel(0(0.01)0.05) 

graph export "figures\figSI12.pdf", as(pdf)   replace


clear all
