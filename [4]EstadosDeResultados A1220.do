			
************************** INSTRUCCIONES *******************************
*Ir a la sección de <<Nuevas ediciones||Zona de juegos>> y añadir los nuevos indicadores
	*Añadir esos indicadores al último collapse
	*Añadir una etiqueta, estos indicadores deberían terminar con <<_own>>
	*Correr todo el do-file
	
*Para más información: https://www.cnbv.gob.mx/Anexos/Anexo%2034%20CUB.pdf

*Nota el código está listo para que todo quede en miles de millon es de pesos
*Todo está en términos nominales, pero se integra el INPC para futuras estimaciones

*Previamente debiste correr las versiones 11. y 12.

***Carga de ubicación
macro drop all
clear all
local usuario substr( "`c(username)'",1,5) //Para funcionar con cualquier usuario en servidor
if `usuario'== "Usuar" global root "F:\DARMACRO" 
else if `usuario' != "Usuar" global root "\\Statadgef\darmacro"
	global mun_char "$root\Data\Municipalities Characteristics"
		global main "$root\Data\Bank Data"
			global dataS "$main\data\Stata"
			global dataR "$main\data\Raw"
			global results "$main\results"
			global graphs "$main\graphs"
			global temp "$main\temp"
			global logs "$main\log"	
global run_tags do "$root\Osvaldo\Otros_DTA\etiquetas.do"

*https://app.powerbi.com/view?r=eyJrIjoiMzM3MmM1ZjgtZjczMC00NDYxLTljZjUtNWJjZWUzMDNhOWNhIiwidCI6IjVlMmM0OTc3LTEwN2QtNDBhMy04YWY3LTcwMDc0ODFhNjBkNCIsImMiOjR9

quietly{			
* =========================== PARTE 1 =================================
*************** IMPORTANDO BASES DE DATOS DE CNBV **********************
		*Y SE CONVIERTE A UN ARCHIVO DTA PARA MEJOR INTERPRETACIÓN
noisily di "P1. Descargando y guardando base de datos"

*Descargando directamente de CNBV
local cnbv_web "https://portafolioinfdoctos.cnbv.gob.mx/Documentacion/minfo/CSV/BM/040_R12A_1220_133.zip"

set sslrelax on  
copy `cnbv_web' "${dataR}/040_R12A_1220_133.zip", replace
set sslrelax off

cd "${dataR}/"
unzipfile "${dataR}/040_R12A_1220_133.zip", replace
 
//Because there is no security in CNBV ssl
import delimited using "${dataR}/040_R12A_1220_133.csv", clear

	noisily di "   Convirtiendo a millones de pesos"
	replace importe_pesos = importe_pesos / 1e6
	label data "Información de la CNBV. De la situación financiera."
	save "${dataS}\[13a]040_R12A_1220_133.dta", replace

	su periodo //Detectando el valor a la fecha de hoy
	compress
save "${dataS}\Backups\VARSITFIN_`r(max)'", replace



*Mixing <<CONCEPTOS>>
use "${dataS}/[13a]040_R12A_1220_133.dta", clear
	
*Creando variable de mes (monthly_date)
	gen year = floor(periodo/100)
	gen month = periodo - year*100
	gen time_monthly = ym(year, month)
		format time_monthly %tm
		gen monthly_date = time_monthly
	
*Creating system ID	
	rename institucion bank_id
	replace bank_id = 0 if bank_id == 5

*Determinanndo el mes máximo
	su monthly_date
		global yy = year(dofm(`r(max)'))
		global mm = month(dofm(`r(max)'))
		
	
	
* =========================== PARTE 2 =================================
***************    CONSTRUYENDO LOS INDICADORES  **********************

* Cargando los saldos
noisily: di "P2. Trabajando en la construcción de indicadores"


* ========================
* ZONA DE JUEGOS
* Aquí se pueden <<diseñar>> nuevos indicadores
*
**** Nuevas ediciones
* egen NEW_VAR = total(importe_pesos) if concepto == {CONCEPTO DEL CATÁLOGO}, by(bank_id time_monthly)

egen g_admon_prom = total(importe_pesos) if inlist(concepto, 602000301010), by(bank_id time_monthly)

egen g_otr_admon_prom = total(importe_pesos) if inlist(concepto, 602001002136), by(bank_id time_monthly)

egen g_public = total(importe_pesos) if inlist(concepto, 602001002125), by(bank_id time_monthly)


/*
PARTE FINAL
Colapsar al nivel Banco-Tiempo
*/
collapse (mean) g*, by(bank_id time_monthly)


compress
label data "Indicadores de Estados de Resultados (a partir de 2022)"
*save "${dataS}\[13]aux_indicators_R12A_1219_BM.dta", replace
	gen monthly_date = time_monthly
xtset bank_id monthly_date

*gen year = year(dofm(monthly_date))

foreach varl of varlist g*{
	bys bank_id (monthly_date): gen diff_`varl' = `varl' - l1.`varl'
	replace diff_`varl'  = `varl' if month(dofm(monthly_date)) == 1
	drop `varl'
	rename diff_`varl' `varl'
}


*Generando variables adicionales y etiquetando

	label variable g_admon_prom "Gastos en Administración y Promoción"
	label variable g_otr_admon_prom "Otros Gastos en Administración y Promoción"
	label variable g_public "Gastos en Publicidad"
	
merge m:1 monthly_date using "${root}\Data\INPC\Data\Stata\[1-DC] INPC.dta", keepusing(inpc) nogenerate

*Guardando
$run_tags
drop if bank_id == .
preserve
	gen year = year(dofm(monthly_date))
		su year
		global ymax = `r(max)'
	gen month = month(dofm(monthly_date))
		su month if year == ${ymax}
		global mmax = `r(max)'	
restore
noisily: di as result "Correctamente actualizada al ${ymax}m${mmax}"
label data "Inf. de Estados de Resultados-A1220- ${ymax}m${mmax}. Saldos en mdp. Last update: `c(current_date)' by `c(username)'"
compress
save "${dataS}/[4]A1220_VariablesEstadoSituaciónFinanciera.dta", replace

}
