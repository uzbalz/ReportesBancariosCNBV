***Carga de ubicación v2.0
macro drop _all
set varabbrev off, permanently
local host_machine = "`c(hostname)'"
if "`host_machine'" == "STATADGEF" global root "F:\DARMACRO\" 
else global root "\\Statadgef\darmacro\"
	global home "${root}/Osvaldo"
	global main "${root}/Data/Bank Data" // Nombre del análisis
		global codes "${main}/codes/"
			global dodtfiles "${codes}/Data Construction/"
			global dofiles "${codes}/Analysis/"
		global dataS "${main}/data/Stata"
		global dataR "${main}/data/Raw"
		global rs "${main}/results"
		global graphs "${main}/graphs"
		global temp "${main}/temp"
		global logs "${main}/log"
	
	*Instructions and others
		global mun_char "${root}\Data\Municipalities Characteristics"
		global run_tags do "${home}\Otros_DTA\etiquetas.do"	
		global run_cons do "${root}\CNR\codes\Consolidar Banca Múltiple.do"
		

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Descripción breve
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

set sslrelax on 
	copy "https://portafolioinfdoctos.cnbv.gob.mx/Documentacion/minfo/CSV/series_historicas/BM/sh_datos_csv_40.zip" "C:\Users\K17765\Downloads\sh_datos_csv_40.zip", replace
set sslrelax off


cd "C:\Users\K17765\Downloads\"
unzipfile "C:\Users\K17765\Downloads\sh_datos_csv_40.zip", replace


tempfile conceptos
import delimited "C:\Users\K17765\Downloads\cat_conceptos_40.csv", clear
keeporder idconcepto descripcion nivel
compress
save `conceptos'


import delimited "C:\Users\K17765\Downloads\sh_datos_40.csv", clear
	replace valor = valor / 1e6 // cifras en mdp
	replace entidad = 0 if entidad == 5

merge m:1 idconcepto using `conceptos', nogenerate

sort entidad periodo nivel idconcepto

keep if saldo == 133

gen activos = valor if idconcepto == 40100001
gen pasivos = valor if idconcepto == 40100096
gen roa = valor*1e8 if idconcepto == 40200001
gen roe = valor*1e8 if idconcepto == 40200002

/*
Indicadores de morosidad
*/
gen imor_cct = valor*1e8 if idconcepto == 40200017
	gen imor_comerciales = valor*1e8 if idconcepto == 40200018
	gen imor_cce = valor*1e8 if idconcepto == 40200038
	gen imor_ccfin = valor*1e8 if idconcepto == 40200039
	gen imor_ccg = valor*1e8 if idconcepto == 40200040
	gen imor_ccct = valor*1e8 if idconcepto == 40200019
	gen imor_ccctc = valor*1e8 if idconcepto == 40200041
	
	gen imor_cccnr = valor*1e8 if idconcepto == 40200042
	gen imor_cccnrp = valor*1e8 if idconcepto == 40200043
	gen imor_cccn = valor*1e8 if idconcepto == 40200044
	gen imor_cccabcd= valor*1e8 if idconcepto == 40200045
	gen imor_cccaut = valor*1e8 if idconcepto == 40200046
	gen imor_cccadqbimu = valor*1e8 if idconcepto == 40200047
	gen imor_cccarf = valor*1e8 if idconcepto == 40200048
	gen imor_cccmicro = valor*1e8 if idconcepto == 40200049
	gen imor_cccotros = valor*1e8 if idconcepto == 40200050
	gen imor_cccviv= valor*1e8 if idconcepto == 40200020
		gen imor_cccviv_media = valor*1e8 if idconcepto == 40200051
		gen imor_cccviv_intsoc = valor*1e8 if idconcepto == 40200052
		gen imor_cccviv_infon = valor*1e8 if idconcepto == 40200053
		
		

	
gen imora_cct = valor*1e8 if idconcepto == 40200033


/*
Indicadores de saldos
*/


gen cre_cct = valor if idconcepto == 40100185
	gen cre_comercial = valor if idconcepto == 40100186
		gen cre_cce = valor if idconcepto == 40100187
			gen cre_oper_quirografarias = valor if idconcepto == 40100188
			gen cre_oper_prendarias = valor if idconcepto == 40100189
			gen cre_cred_puente = valor if idconcepto == 40100190
			gen cre_oper_factoraje = valor if idconcepto == 40100191
			gen cre_ccoac = valor if idconcepto == 40100192
			gen cre_oper_garantia_hipotecaria = valor if idconcepto == 40100193
			gen cre_cred_proy_inversion = valor if idconcepto == 40100194
			gen cre_otros = valor if idconcepto == 40100195
		gen cre_entidades_financieras = valor if idconcepto == 40100196
			gen cre_cred_interbancarios = valor if idconcepto == 40100197
			gen cre_cred_entidades_no_bancarias = valor if idconcepto == 40100198
			gen cre_otros_financieras = valor if idconcepto == 40100199
		gen cre_ent_gub = valor if idconcepto == 40100200
			gen cre_cred_gobierno_federal = valor if idconcepto == 40100201
			gen cre_cred_estados_municipios = valor if idconcepto == 40100202
			gen cre_cred_empresas_productivas = valor if idconcepto == 40100203
			gen cre_cred_org_descentralizados = valor if idconcepto == 40100204
			gen cre_otros_gubernamentales = valor if idconcepto == 40100205
	gen cre_ccct = valor if idconcepto == 40100206
		gen cre_ccctc = valor if idconcepto == 40100207
		gen cre_consumo_no_revolvente = valor if idconcepto == 40100208
			gen cre_cccnrp = valor if idconcepto == 40100209
			gen cre_cccn = valor if idconcepto == 40100210
			gen cre_cccabcd = valor if idconcepto == 40100211
			gen cre_cccaut = valor if idconcepto == 40100212
			gen cre_cccadqbimu = valor if idconcepto == 40100213
		gen cre_cccarf = valor if idconcepto == 40100214
		gen cre_micro = valor if idconcepto == 40100215
		gen cre_cccnro = valor if idconcepto == 40100216
	gen cre_ccv = valor if idconcepto == 40100217
		gen cre_cccviv_media = valor if idconcepto == 40100218
		gen cre_cccviv_intsoc = valor if idconcepto == 40100219
		gen cre_cccviv_infon = valor if idconcepto == 40100220
		gen cre_remodelacion_fideicomisos = valor if idconcepto == 40100221
		gen cre_remodelacion_subcuenta = valor if idconcepto == 40100222
		gen cre_otros_ccv = valor if idconcepto == 40100223


gen a_instr_fin = valor if idconcepto == 40100051

/*
Activo Circulante = Efectivo y Equivalentes de Efectivo + 
					Instrumentos Financieros Negociables sin restricción + 
					Instrumentos Financieros para cobrar o vender sin restricción. 
					*/
gen a_efectivo = valor if idconcepto == 40100045
gen a_instr_fin_srestric = valor if idconcepto == 40100052
gen a_instr_fin_srestric_pcobven = valor if idconcepto == 40100053
gen a_ctas_margen = valor if idconcepto == 40100184


/*
Pasivo Circulante = Depósitos de exigibilidad inmediata +
					Préstamos interbancarios y de otros organismos de exigibilidad inmediata + 
					Préstamos interbancarios y de otros organismos de corto plazo. 
					*/
					
gen p_cap_trad = valor if idconcepto == 40100085
gen p_dep_exig_inm = valor if idconcepto == 40100079
gen p_dep_pzo = valor if idconcepto == 40100080
gen p_pres_interbanc_exiginm = valor if idconcepto == 40100087
gen p_pres_interbanc_cplazo = valor if idconcepto == 40100088


/*
Gastos por depósitos de exigibilidad inmediata
*/
gen c_gast_x_int = valor if idconcepto == 40100007     // Gastos por intereses
gen c_gast_x_int_dexin = valor if idconcepto ==  40100118 // Intereses por depósitos de exigibilidad inmediata
gen c_gast_x_int_dpzo = valor if idconcepto ==  40100119 // Intereses por depósitos a plazo 

	
/*
CAPITAL
*/
gen c_capital = valor if idconcepto == 40100002 // Capital Contable
gen c_contri = valor if idconcepto ==  40100098 // Capital constribuido
gen c_ganado = valor if idconcepto ==  40100099 // Capital ganado
gen c_nocontroladora = valor if idconcepto ==  40100100 // Capital. Participación no controladora




					
gen bank_id = entidad

gen monthly_date = ym(floor(periodo/100), periodo - (floor(periodo/100) * 100))
	format monthly_date %tm
	
rename periodo fakep 













collapse (mean) cre* a* p* roa roe imor* c_* , by(bank_id monthly_date)

egen act_circulante = rowtotal(a_efectivo a_instr_fin_srestric a_instr_fin_srestric_pcobven)
egen act_circulante2 = rowtotal(a_efectivo a_instr_fin_srestric a_instr_fin_srestric_pcobven a_ctas_margen)

egen pas_circulante = rowtotal(p_dep_exig_inm p_pres_interbanc_exiginm p_pres_interbanc_cplazo)

gen liq = act_circulante / pas_circulante * 100
gen liq2 = act_circulante2 / pas_circulante * 100

label variable a_instr_fin "Inversiones en instrumentos financieros"


label variable imor_cct "Cartera de crédito con riesgo de crédito"
label variable imor_comerciales "Créditos comerciales"
label variable imor_cce "Actividad empresarial o comercial"
label variable imor_ccfin "Créditos financieros"
label variable imor_ccg "Créditos gubernamentales"
label variable imor_ccct "Créditos de consumo"
label variable imor_ccctc "Tarjeta de crédito"
label variable imor_cccnr "Consumo no revolvente"
label variable imor_cccnrp "Personales"
label variable imor_cccn "Nómina"
label variable imor_cccabcd "ABCD (Incluye auto y ABCD)"
label variable imor_cccaut "Automotriz"
label variable imor_cccadqbimu "ABCD Adquisición de bienes muebles"
label variable imor_cccarf "Operaciones de arrendamiento financiero"
label variable imor_cccmicro "Microcréditos"
label variable imor_cccotros "Otros créditos de consumo"
label variable imor_cccviv "Créditos a la vivienda"
label variable imor_cccviv_media "Media y residencia"
label variable imor_cccviv_intsoc "De interés social"
label variable imor_cccviv_infon "Créditos adquiridos al infonavit o el fovissste"


label variable cre_cct "Cartera de crédito con riesgo de crédito"
label variable cre_comercial "Créditos comerciales"
	label variable cre_cce "Actividad empresarial o comercial"
		label variable cre_oper_quirografarias "Operaciones quirografarias"
		label variable cre_oper_prendarias "Operaciones prendarias"
		label variable cre_cred_puente "Créditos puente"
		label variable cre_oper_factoraje "Operaciones de factoraje financiero, descuento o cesión de derechos de crédito"
		label variable cre_ccoac "Operaciones de arrendamiento financiero"
		label variable cre_oper_garantia_hipotecaria "Operaciones con garantía hipotecaria"
		label variable cre_cred_proy_inversion "Créditos para proyectos de inversión con fuente de pago propia"
		label variable cre_otros "Otros"
	label variable cre_entidades_financieras "Entidades financieras"
		label variable cre_cred_interbancarios "Créditos interbancarios"
		label variable cre_cred_entidades_no_bancarias "Créditos a entidades financieras no bancarias"
		label variable cre_otros_financieras "Otros"
	label variable cre_ent_gub "Entidades gubernamentales"
		label variable cre_cred_gobierno_federal "Créditos al gobierno federal"
		label variable cre_cred_estados_municipios "Créditos a estados y municipios"
		label variable cre_cred_empresas_productivas "Créditos a empresas productivas del estado"
		label variable cre_cred_org_descentralizados "Créditos a organismos descentralizados o desconcentrados"
		label variable cre_otros_gubernamentales "Otros"
label variable cre_ccct "Créditos de consumo"
	label variable cre_ccctc "Tarjeta de crédito"
	label variable cre_consumo_no_revolvente "Consumo no revolvente"
		label variable cre_cccnrp "Personales"
		label variable cre_cccn "Nómina"
		label variable cre_cccabcd "ABCD (contiene automotriz)"
		label variable cre_cccaut "Automotriz"
		label variable cre_cccadqbimu "ABCD Adquisición de bienes muebles"
label variable cre_cccarf "Operaciones de arrendamiento financiero"
label variable cre_micro "Microcréditos"
label variable cre_cccnro "Otros créditos de consumo"
label variable cre_ccv "Créditos a la vivienda"
	label variable cre_cccviv_media "Media y residencia"
	label variable cre_cccviv_intsoc "De interés social"
	label variable cre_cccviv_infon "Créditos adquiridos al infonavit o el fovissste"
	label variable cre_remodelacion_fideicomisos "Remodelación o mejoramiento con garantía otorgada por la banca de desarrollo o fideicomisos públicos"
	label variable cre_remodelacion_subcuenta "Remodelación o mejoramiento con garantía de la subcuenta de vivienda"
	label variable cre_otros_ccv "Otros"
	
	
* ETIQUETAS DE PASIVOS
label variable p_cap_trad "Captación Tradicional (agregado)"
label variable p_dep_exig_inm "Depósitos exigibilidad inmediata"
label variable p_dep_pzo "Depósitos a plazo"
label variable p_pres_interbanc_exiginm "Depósitos interbancarios de exigibilidad inmediata"
label variable p_pres_interbanc_cplazo "Depósitos interbancarios a plazo"


*ETIQUETAS xd


   
* ETIQUETAS DE RESULTADOS FINANCIEROS
label variable c_gast_x_int "Gastos por intereses"
label variable c_gast_x_int_dexin "Intereses por depósitos de exigibilidad inmediata"
label variable c_gast_x_int_dpzo "Intereses por depósitos a plazo"

* Eliminando el acumulado de resultados financieros
xtset bank_id monthly_date

foreach varl of varlist c_gast*{
	gen v`varl'= `varl' - `varl'[_n-1] if mod(monthly_date,12) != 0
	replace v`varl' = `varl' if mod(monthly_date,12) == 0 | l1.`varl' == .	
	replace `varl' = v`varl'
	drop v`varl'
}


gen cc_dexin = c_gast_x_int_dexin / p_dep_exig_inm * 1200
gen cc_dexpzo = c_gast_x_int_dpzo / p_dep_pzo * 1200
label variable cc_dexin "Costo de captación. Depósitos Exigibilidad Inmediata"
label variable cc_dexpzo "Costo de captación. Depósitos a plazo"


$run_tags

		
		
		
		
*ETIQUETA CAPITAL
label variable c_capital "Capital Contable"
label variable c_contri "Capital constribuido"
label variable c_ganado "Capital ganado"
label variable c_nocontroladora "Capital. Participación no controladora"

gen c_controladora = c_contri + c_ganado  -c_nocontroladora 
label variable c_controladora "Capital. Participación controladora"





*Modifiyng labels on browser
ds, has(type numeric)
foreach varl of varlist `r(varlist)' {
 summarize `varl' if bank_id == 0, meanonly
 if `r(mean)' > 1000 {
 format `varl' %12.1fc
 }
	else {
		format `varl' %9.4f
	}
}	

format monthly_date %tm	
format bank_id %24.1fc		

compress



merge 1:1 bank_id monthly_date using "\\Statadgef\darmacro\Data\Bank Data\Data\Stata\[3]Indicadores_Bancarios_BE.dta" , nogenerate

merge m:1 monthly_date using "//Statadgef/darmacro/Data/INPC/Data/Stata/[1-DC] INPC.dta", keepusing(inpc) nogenerate

foreach varl of varlist cre_cce cre_ccctc cre_cccnrp cre_cccn cre_cccaut cre_ccv cre_entidades_financieras cre_ent_gub cre_cccabcd cre_micro cre_cccnro cre_ccoac{
	gen sys_`varl' = `varl' if bank_id == 0
	ereplace sys_`varl' = min(sys_`varl'), by(monthly_date)
	gen sh_`varl' = `varl' / sys_`varl' * 100 
} 


foreach varl of varlist cre_cce cre_ccctc cre_cccnrp cre_cccn cre_cccaut cre_ccv cre_entidades_financieras cre_ent_gub cre_cccadqbimu cre_micro cre_cccnro cre_ccoac {
	gen shb_`varl' = `varl' / cre_cct * 100
}

rename (shb_cre_*) (shb_*)
gen time_monthly = monthly_date

// Droping false observations
su monthly_date if bank_id == 0

drop if monthly_date > `r(max)'

drop if bank_id > 0 & bank_id < 100

merge 1:1 bank_id monthly_date using "\\Statadgef\darmacro\Data\Bank Data\Data\Stata\[2]Capitalización.dta" , nogenerate

gen cap_trad = p_dep_exig_inm

xtset bank_id monthly_date
gen icap_lag = l1.icap
gen capital_neto_lag = l1.capital_neto
	label variable cap_trad "Captación tradicional ~ Depósitos de exigibilidad inmediata"
	
keep if bank_id == 0 | floor(bank_id/10000) == 4

foreach varl in imora_nom imora_per imora_abcd imora_aut imora_viv imora_tdc {
	gen `varl' = .
}


preserve
	gen year = year(dofm(monthly_date))
		su year
		global ymax = `r(max)'
	gen month = month(dofm(monthly_date))
		su month if year == ${ymax}
		global mmax = `r(max)'	
restore

replace roa = roa_flujo if roa == .
replace roa_flujo = roa if roa_flujo == .


label data "Series históricas - ${ymax}m${mmax}. Saldos en mdp. Last update: `c(current_date)' by `c(username)'"
compress
save "//Statadgef/darmacro/Data/Bank Data/Data/Stata/[13]Indicadores_Bancarios_Agr.dta", replace

*list bank_id monthly_date  liq* if bank_id == 40127 & monthly_date > tm(2022m1)




use "//Statadgef/darmacro/Data/Bank Data/Data/Stata/[13]Indicadores_Bancarios_Agr.dta", clear

merge 1:1 bank_id monthly_date using "${dataS}/[4]A1220_VariablesEstadoSituaciónFinanciera.dta", nogenerate
merge 1:1 bank_id monthly_date using "${dataS}/[5]A1219_VariablesEstadoSituaciónFinanciera.dta", nogenerate

label data "Series históricas vitaminadas - ${ymax}m${mmax}. Saldos en mdp. Last update: `c(current_date)' by `c(username)'"
notes drop _all
notes: "11 - Capitalización"
notes: "12 - Info de boletines estadísticos"
notes: "13 - Información Histórica"
notes: "14 - Variables de Estados de Resultados"
notes: "15 - Variables de situación financiera"
compress
save "//Statadgef/darmacro/Data/Bank Data/Data/Stata/[13-X]Indicadores_Bancarios_Agr.dta", replace
