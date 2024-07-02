*************************************************************************************************
* Authors: Gonzalez, R., Munoz, E., & Fuentes, A.                                               *
* Purpose: Replication file "Nonresponse in Name Generators Across Countries and Survey Modes"  *
* Last update: 20-jun-2024                                                                      *
*************************************************************************************************

* 0. Prelude *
clear all

log using GMF24, replace

cd "`mdFolder'"
use "merge61_con_elecciones_desde_2010.dta"

************************
* 1. Sociodemographics *
************************

* 1.1. Highest formal education *
generat edu = 1 if (l_education != . & l_education <= 2)
replace edu = 1 if (l_education >= 3 & l_education <= 4)
replace edu = 2 if (l_education >= 5 & l_education <= 7)

* 1.2. Age *
generat age = l_age

* 1.3. Gender (female == 1) *
generat fem = 1 if l_gender == 2
replace fem = 0 if l_gender == 1

* 1.4. Income *
generat inc = l_income if l_income != .

* 1.5. Marital status *
generat mar = (l_married == 2)
replace mar = . if l_married == .

* 1.6. Religiosity: frequency of attendance (no muslim countries) *
drop if a_a_countryyear == 46 | a_a_countryyear == 60
generat rel = l_religfreq if l_religfreq < 5
replace rel = 0 if (l_religfreq == 995 | l_religfreq == 999)

* 1.7. Worker
generat wrk = (l_workstat == 2)
replace wrk = . if l_workstat == .

**************************
* 2. Political variables *
**************************

* 2.1. Close to a political party *
generat cpp = f_asoparty if f_asoparty != .

* 2.2. Left-right position *
generat lrp = .
replace lrp = 0 if (c_lrself >= 1 & c_lrself <= 4)
replace lrp = 1 if (c_lrself >= 5 & c_lrself <= 6)
replace lrp = 2 if (c_lrself >= 7 & c_lrself <= 10)

* 2.3. Political interest *
generat poi = h_interest if h_interest < 4

* 2.4. Always votes *
generat awv = 0
replace awv = 1 if (h_turnout == 1 & h_votewhichprevious < 41) 

* 2.5. Political campaign: use of media frequency *
generat net = d_caminternet_f if d_caminternet_f < 5
generat pap = d_campaper_f if d_campaper_f < 5
generat rad = d_camradio_f if d_camradio_f < 5
generat utv = d_camtv_f if d_camtv_f < 5

************************
* 3. Network variables *
************************

* 3.1. Member of asociations *
generat ide = 0 /*Missing observations identifier*/
replace ide = 1 if (f_aso1 == . ///
			        & f_aso1_2 == . ///
					& f_aso1cont == . ///
					& f_aso1conthow == . ///
					& f_aso1freq == . ///
					& f_aso1know2_f == . ///
					& f_aso1media_f == . ///
					& f_aso1part == . ///
					& f_asocharity == . ///
					& f_asocomm == . ///
					& f_asofrat == . ///
					& f_asomove == . ///
					& f_asoother == . ///
					& f_asoparty == . ///
					& f_asoprof == . ///
					& f_asorelig == . ///
					& f_asosocial == . ///
					& f_asotu == .)
generat mem = 0 /*Membership variable*/
replace mem = 1 if (f_aso1 < 11  ///
					| f_asocharity == 1 ///
					| f_asocomm == 1 ///
					| f_asofrat == 1 ///
					| f_asomove == 1 ///
					| f_asoother == 1 ///
					| f_asoparty == 1 ///
					| f_asoprof == 1 ///
					| f_asorelig == 1 ///
					| f_asosocial == 1 ///
					| f_asotu == 1) 

* 3.2. Discussants: political matters *
generat idn = 0 /*Missing observations identifier*/
replace idn = 1 if (e_discnumber == . )

generat ndi = 0 /*discussants: number*/
replace ndi = 1 if (e_discnumber < 995 & e_discnumber > 0)
generat iso = 0 if ndi == 1 /*isolates: main variable for the analysis*/
replace iso = 1 if e_discnumber == 0 | e_discnumber == 995 | e_discnumber == 999

generat dmi = 0 /*presence or absence for cross-checking*/
replace dmi = 1 if (e_disc1 < 9 | e_disc2 < 9)
generat iso2 = 0 if dmi == 1 /*isolates: main variable for the analysis*/
replace iso2 = 1 if (e_disc1==995 | e_disc1==999) & (e_disc2==995 | e_disc2==999 | e_disc2==.)

*******************************************************					
* 4. Interview variable (1 = interviewer, 0 = online) *
*******************************************************

generat ent = .
replace ent = 1 if a_a_countryyear == 1  /* Argentina 2007 */
replace ent = 1 if a_a_countryyear == 2  /* Bulgaria 1996 */
replace ent = 1 if a_a_countryyear == 3  /* Chile 1993 */
replace ent = 1 if a_a_countryyear == 53 /* Chile 2017 */
replace ent = 1 if a_a_countryyear == 64 /* Chile 2021 */
replace ent = 1 if a_a_countryyear == 37 /* Colombia 2014 */
replace ent = 1 if a_a_countryyear == 54 /* Colombia 2018 */
replace ent = 0 if a_a_countryyear == 50 /* France 2017 */
replace ent = 0 if a_a_countryyear == 52 /* Germany 2017 */
replace ent = 1 if a_a_countryyear == 27 /* Great Britain 1992 */
replace ent = 0 if a_a_countryyear == 51 /* Great Britain 2017 */
replace ent = 1 if a_a_countryyear == 7  /* Greece 1996 */
replace ent = 1 if a_a_countryyear == 8  /* Greece 2004 */
replace ent = 1 if a_a_countryyear == 9  /* Hong Kong 1998 */
replace ent = 0 if a_a_countryyear == 10 /* Hong Kong 2015 */
replace ent = 0 if a_a_countryyear == 11 /* Hungary 1998 */
replace ent = 1 if a_a_countryyear == 12 /* Hungary 2006 */
replace ent = 1 if a_a_countryyear == 16 /* Italy 1996 */
replace ent = 1 if a_a_countryyear == 35 /* Italy 2013 */
replace ent = 1 if a_a_countryyear == 36 /* Kenya 2013 */
replace ent = 1 if a_a_countryyear == 19 /* Mexico 2006 */
replace ent = 1 if a_a_countryyear == 33 /* Mexico 2012 */
replace ent = 1 if a_a_countryyear == 56 /* Mexico 2018 */
replace ent = 1 if a_a_countryyear == 20 /* Mozambique 2004 */
replace ent = 1 if a_a_countryyear == 21 /* Portugal 2005 */
replace ent = 1 if a_a_countryyear == 47 /* Russia 2016 */
replace ent = 1 if a_a_countryyear == 22 /* South Africa 2004 */
replace ent = 1 if a_a_countryyear == 23 /* South Africa 2009 */
replace ent = 1 if a_a_countryyear == 39 /* South Africa 2014 */
replace ent = 1 if a_a_countryyear == 58 /* South Africa 2019 */
replace ent = 1 if a_a_countryyear == 24 /* Spain 1993 */
replace ent = 1 if a_a_countryyear == 25 /* Spain 2004 */
replace ent = 0 if a_a_countryyear == 44 /* Spain 2015 */
replace ent = 1 if a_a_countryyear == 26 /* Taiwan 2004 */
replace ent = 0 if a_a_countryyear == 45 /* Taiwan 2016 */
replace ent = 0 if a_a_countryyear == 61 /* Taiwan 2020 */
replace ent = 1 if a_a_countryyear == 40 /* Turkey 2014 */
replace ent = 1 if a_a_countryyear == 57 /* Ukraine 2019 */
replace ent = 1 if a_a_countryyear == 28 /* United States 1992 */
replace ent = 0 if a_a_countryyear == 29 /* United States 2004 */
replace ent = 0 if a_a_countryyear == 34 /* United States 2012 */
replace ent = 0 if a_a_countryyear == 49 /* United States 2016 */
replace ent = 0 if a_a_countryyear == 59 /* United States 2020 */
replace ent = 1 if a_a_countryyear == 30 /* Uruguay 1994 */
replace ent = 1 if a_a_countryyear == 31 /* Uruguay 2004 */

*********************
* 5. Interview mode *
*********************

* 1 = Face-to-face
* 2 = Internet, Online panel
* 3 = CATI, Telephone

generat int_mode = .
replace int_mode = 1 if a_a_countryyear == 1  /* Argentina 2007 */
replace int_mode = 1 if a_a_countryyear == 2  /* Bulgaria 1996 */
replace int_mode = 1 if a_a_countryyear == 3  /* Chile 1993 */
replace int_mode = 1 if a_a_countryyear == 53 /* Chile 2017 */
replace int_mode = 1 if a_a_countryyear == 64 /* Chile 2021 */
replace int_mode = 1 if a_a_countryyear == 37 /* Colombia 2014 */
replace int_mode = 1 if a_a_countryyear == 54 /* Colombia 2018 */
replace int_mode = 2 if a_a_countryyear == 50 /* France 2017 */
replace int_mode = 2 if a_a_countryyear == 52 /* Germany 2017 */
replace int_mode = 1 if a_a_countryyear == 27 /* Great Britain 1992 */
replace int_mode = 2 if a_a_countryyear == 51 /* Great Britain 2017 */
replace int_mode = 1 if a_a_countryyear == 7  /* Greece 1996 */
replace int_mode = 1 if a_a_countryyear == 8  /* Greece 2004 */
replace int_mode = 1 if a_a_countryyear == 9  /* Hong Kong 1998 */
replace int_mode = 2 if a_a_countryyear == 10 /* Hong Kong 2015 */
replace int_mode = 1 if a_a_countryyear == 11 /* Hungary 1998 */
replace int_mode = 1 if a_a_countryyear == 12 /* Hungary 2006 */
replace int_mode = 3 if a_a_countryyear == 16 /* Italy 1996 */
replace int_mode = 1 if a_a_countryyear == 35 /* Italy 2013 */
replace int_mode = 1 if a_a_countryyear == 36 /* Kenya 2013 */
replace int_mode = 1 if a_a_countryyear == 19 /* Mexico 2006 */
replace int_mode = 1 if a_a_countryyear == 33 /* Mexico 2012 */
replace int_mode = 1 if a_a_countryyear == 56 /* Mexico 2018 */
replace int_mode = 1 if a_a_countryyear == 20 /* Mozambique 2004 */
replace int_mode = 1 if a_a_countryyear == 21 /* Portugal 2005 */
replace int_mode = 1 if a_a_countryyear == 47 /* Russia 2016 */
replace int_mode = 1 if a_a_countryyear == 22 /* South Africa 2004 */
replace int_mode = 1 if a_a_countryyear == 23 /* South Africa 2009 */
replace int_mode = 1 if a_a_countryyear == 39 /* South Africa 2014 */
replace int_mode = 1 if a_a_countryyear == 58 /* South Africa 2019 */
replace int_mode = 1 if a_a_countryyear == 24 /* Spain 1993 */
replace int_mode = 1 if a_a_countryyear == 25 /* Spain 2004 */
replace int_mode = 2 if a_a_countryyear == 44 /* Spain 2015 */
replace int_mode = 1 if a_a_countryyear == 26 /* Taiwan 2004 */
replace int_mode = 2 if a_a_countryyear == 45 /* Taiwan 2016 */
replace int_mode = 2 if a_a_countryyear == 61 /* Taiwan 2020 */
replace int_mode = 1 if a_a_countryyear == 40 /* Turkey 2014 */
replace int_mode = 1 if a_a_countryyear == 57 /* Ukraine 2019 */
replace int_mode = 3 if a_a_countryyear == 28 /* United States 1992 */
replace int_mode = 2 if a_a_countryyear == 29 /* United States 2004 */
replace int_mode = 2 if a_a_countryyear == 34 /* United States 2012 */
replace int_mode = 2 if a_a_countryyear == 49 /* United States 2016 */
replace int_mode = 2 if a_a_countryyear == 59 /* United States 2020 */
replace int_mode = 1 if a_a_countryyear == 30 /* Uruguay 1994 */
replace int_mode = 1 if a_a_countryyear == 31 /* Uruguay 2004 */

******************************
* 6. Logit Important Matters *
******************************

drop if a_a_countryyear== 52 /* Issues associated with education variable */
drop if a_a_countryyear== 45 /* Everyone declares discussants */

* 6.1 Logit exploratory regression and icc estimation
logit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent
keep if e(sample)
xtmixed iso2 || a_a_country:
estat icc 

/* Descriptive Statistics for Table */ 
*collapse (mean) iso2 fem age edu mar mem wrk poi int_mode, by(a_a_countryyear)

*****************************************
* 7. Bayesian Melogit Important Matters *
*****************************************

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk i.poi i.ent i.ent#i.fem i.ent#c.age i.ent#i.edu i.ent#i.mar i.ent#i.mem i.ent#i.wrk i.ent#i.poi || a_a_country: a_a_countryyear
bayes, or

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#i.fem || a_a_country: a_a_countryyear
bayes, or	

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#c.age || a_a_country: a_a_countryyear
bayes, or	

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#i.edu || a_a_country: a_a_countryyear
bayes, or	

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#i.mar || a_a_country: a_a_countryyear
bayes, or	

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#i.mem || a_a_country: a_a_countryyear
bayes, or	

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#i.wrk || a_a_country: a_a_countryyear
bayes, or	

bayes : melogit iso2 i.fem c.age i.edu i.mar i.mem i.wrk c.poi i.ent i.ent#c.poi || a_a_country: a_a_countryyear
bayes, or	

log close
