***Carga de ubicación
local usuario substr( "`c(username)'",1,5) //Para funcionar con cualquier usuario en servidor
if `usuario'== "Usuar" global root "F:\DARMACRO" 
else if `usuario' != "Usuar" global root "\\Statadgef\darmacro"
	global home "$root\Osvaldo"
	global source "$home\Data_CNBV_updated"
	global mun_char "$root\Data\Municipalities Characteristics"
		global main "$root\Data\Bank Data"
			global dataS "$main\data\Stata"
			global dataR "$main\data\Raw"
			global results "$main\results"
			global graphs "$main\graphs"
			global temp "$main\temp"
			global logs "$main\log"	
	global run_tags do "${home}\Otros_DTA\etiquetas.do"
	
	
global dt_codes "\\Statadgef\darmacro\Data\Bank Data\Codes\Data Construction\" 

		
************************** INSTRUCCIONES *******************************
* 1
* Descargar la base de http://portafoliodeinformacion.cnbv.gob.mx/bm1/Paginas/alertas.aspx
* NOMBRE: Resumen de cómputo
* Abrir el excel con macros: (11-OB) Macros_ICAP
* Correr la macro en el archivo Resumen de Cómputo
/*
	FILE 1 - PYTHON
This file downloads info from AlertasTempranas
and export it as excel file >>AlertasTempranasMod<<
*/
set sslrelax on  
copy "https://portafolioinfdoctos.cnbv.gob.mx/Documentacion/minfo/XLS/40/040_15b_R2.xls" "//Statadgef/darmacro/Data/Bank Data/Data/Raw/040_15b_R2.xls", replace
set sslrelax off



python script "${dt_codes}/[2a] Execute macros.py"


import excel using "\\Statadgef\darmacro\Data\Bank Data\Data\Raw\040_15b_R2_mod.xlsx", firstrow clear

rename *, lower


replace  cve_institucion = cve_institucion[_n-1] if cve_institucion == ""
	drop if cve_periodo == .

rename (cve_institucion capitalneto) (bank_id capital_neto )	
	
destring, replace

gen year = floor(cve_periodo/100)
gen month = cve_periodo - year * 100
gen monthly_date = ym(year, month)
	format monthly_date %tm
replace capital_neto = capital_neto / 1000000000

drop year month cve_periodo

$run_tags

replace bank_id = 0 if bank_id == 5

sort bank_id monthly_date
label variable capital_neto "Capital Neto en mmdp"
label variable icap "Índice de capitalización"
	
quietly{
	preserve
		gen year = year(dofm(monthly_date))
		gen month = month(dofm(monthly_date))
		su monthly_date
		local max_date = `r(max)'
			su month if monthly_date == `max_date'
			local max_month = `r(max)'
			su year if monthly_date == `max_date'
			local max_year = `r(max)'
	restore
}

compress
label data "Capitalización. Actualizado a `max_year'm`max_month'"
di "Capitalización. Actualizado a `max_year'm`max_month'"
save "${dataS}/[2]Capitalización.dta", replace






