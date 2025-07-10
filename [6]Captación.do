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
clear

*2016 could have problems

forvalues y = 2025 / 2025{
	forvalues m = 3/3{
		local 0m : di %02.0f `m'
		
		if "`y'`0m'" == "201601" | "`y'`0m'" == "201602" | "`y'`0m'" == "201604" | "`y'`0m'" == "201605"{ 
			import excel using "${dataR}/Boletines Estadísticos\Captación/`y'/BM_Cap_`y'`0m'.xls", describe
			local nrows = substr("`r(range_2)'", -6,.)
			
			import excel using "${dataR}/Boletines Estadísticos\Captación/`y'/BM_Cap_`y'`0m'.xls", ///
				sheet("`r(worksheet_2)'") cellrange(A2:`nrows') firstrow clear
				
			rename B localidad
			destring localidad, force replace
			
			gen state_mun = floor(localidad/10000) - 48400000
						
			drop CuentasTransaccionalesTotal InformacióndeSaldosenpesos localidad

			tempfile daux
			preserve
				gen bank_labels = ""
				gen funds = .
				keep bank_labels funds
				keep in 1
				save `daux'
			restore

			ds state_mun, not

			quietly{
			foreach bank in `r(varlist)'{
				preserve
					keep state_mun `bank'
					gen bank_labels = "`bank'"
					rename `bank' funds
					append using `daux'
					save `daux', replace
				restore
			}
			}
			
			use `daux', clear
			
			keeporder bank_labels state_mun funds

			*Renaming banks
			replace bank_labels = "Banca Múltiple" if strpos(bank_labels, "Sistema") > 0
			replace bank_labels = "Banca Múltiple" if strpos(bank_labels, "Total") > 0

			replace bank_labels = subinstr(bank_labels, " *", "", .)
			replace bank_labels = subinstr(bank_labels, "*", "", .)

			replace bank_labels = "ABC Capital" if strpos(bank_labels, "ABC") > 0
			replace bank_labels = "Banco S3" if strpos(bank_labels, "S3") > 0
			replace bank_labels = "Accendo Banco" if strpos(bank_labels, "Accendo") > 0
			replace bank_labels = "Banco Azteca" if strpos(bank_labels, "Azteca") > 0
			replace bank_labels = "American Express" if strpos(bank_labels, "Express") > 0
			replace bank_labels = "Bancrea" if strpos(bank_labels, "Bancrea") > 0
			replace bank_labels = "Banco Base" if strpos(bank_labels, "Base") > 0
			replace bank_labels = "Banco Covalto" if strpos(bank_labels, "Finterra") > 0 | ///
								strpos(bank_labels, "ovalto") > 0
			replace bank_labels = "BanCoppel" if strpos(bank_labels, "oppel") > 0
			replace bank_labels = "Banorte" if strpos(bank_labels, "BanorteIxe") > 0
			replace bank_labels = "Bank of America" if strpos(bank_labels, "America") > 0
			replace bank_labels = "Bank of China" if strpos(bank_labels, "China") > 0
			replace bank_labels = "BBVA México" if strpos(bank_labels, "BBVA") > 0
			replace bank_labels = "BNP Paribas México" if strpos(bank_labels, "BNP") > 0
			replace bank_labels = "Dondé Banco" if strpos(bank_labels, "Dondé") > 0
			replace bank_labels = "Banca Mifel" if strpos(bank_labels, "Mifel") > 0
			replace bank_labels = "Inmobiliario Mexicano" if strpos(bank_labels, "Inmobil") > 0
			replace bank_labels = "Banco del Bajío" if strpos(bank_labels, "Bajío") > 0
			replace bank_labels = "Walmart" if strpos(bank_labels, "Walmart") > 0
			replace bank_labels = "J.P. Morgan" if strpos(bank_labels, "Morgan") > 0
			replace bank_labels = "KEB Hana México" if strpos(bank_labels, "Hana") > 0
			replace bank_labels = "Famsa" if strpos(bank_labels, "Famsa") > 0
			replace bank_labels = "Intercam Banco" if strpos(bank_labels, "Inter Banco") > 0 | ///
								strpos(bank_labels, "Intercam") > 0 
			replace bank_labels = "Credit Suisse" if strpos(bank_labels, "Suisse") > 0 
			replace bank_labels = "UBS" if strpos(bank_labels, "UBS") > 0  
			replace bank_labels = "Ve por Más" if strpos(bank_labels, "Más") > 0 
			replace bank_labels = "MUFG Bank" if strpos(bank_labels, "Tokyo") > 0 | ///
								strpos(bank_labels, "BTMU") > 0 | ///
								strpos(bank_labels, "MUFG") > 0 
			replace bank_labels = "Mizuho" if strpos(bank_labels, "Mizuho") > 0 
								

			*Adding bank codes
			merge m:1 bank_labels using "$root\Osvaldo\Otros_DTA\Covars\Banks_ID.dta", keepusing(bank_id)

				replace bank_id = 40131 if strpos(bank_labels, "Famsa") > 0
				replace bank_id = 40134 if strpos(bank_labels, "WalMart") > 0
				replace bank_id = 40037 if strpos(bank_labels, "Interacc") > 0
				replace bank_id = 40102 if strpos(bank_labels, "Investa") > 0
				replace bank_id = 0 if strpos(bank_labels, "Múltiple") > 0
				replace bank_id = 40146 if strpos(bank_labels, "Bicentenario") > 0 
				replace bank_id = 40137 if strpos(bank_labels, "Bancoppel") > 0 
				replace bank_id = 40154 if strpos(bank_labels, "ovalto") > 0  
				replace bank_id = 40156 if strpos(bank_labels, "abadell") > 0 
				replace bank_id = 40148 if strpos(bank_labels, "agatodo") > 0  
				replace bank_id = 40158 if strpos(bank_labels, "Mizuho") > 0 
				replace bank_id = 40160 if strpos(bank_labels, "S3") > 0
				replace bank_id = 40124 if strpos(bank_labels, "Deutsche") > 0
				
				drop if funds == . | state_mun == .
				
				drop _merge
				
				
			$run_tags

			gen monthly_date = ym(`y', `0m')
			order bank_id state_mun monthly_date
			sort bank_id state_mun
			
			format %tm monthly_date
			
			compress
			compress
			save "${dataS}\CAPTACION/C_`y'`0m'.dta", replace

			
		}
		else {
			import excel using "${dataR}/Boletines Estadísticos\Captación/`y'/BM_Cap_`y'`0m'.xlsx", describe
			local nrows = substr("`r(range_1)'", -6,.)
			
			import excel using "${dataR}/Boletines Estadísticos\Captación/`y'/BM_Cap_`y'`0m'.xlsx", ///
				sheet("Saldos") cellrange(A7:`nrows') firstrow clear

			capture: drop Etiquetasdefila dl_municipio
			
			capture noisily {
				rename (Estado Municipio)(ent mun)
				merge m:1 ent mun using "${dataR}/(A6)MunNames.dta", keep(3)
				gen ClaveINEGI = localidad
			}
			
			capture rename ClaveINEGI cve_inegi
			quietly destring cve_inegi, force replace
			capture: gen state_mun = floor(cve_inegi/10000) - 48400000
			
			drop if cve_inegi == . | cve_inegi == 0
			
			drop cve_inegi

			tempfile daux
			preserve
				gen bank_labels = ""
				gen funds = .
				keep bank_labels funds
				keep in 1
				save `daux'
			restore

			ds state_mun, not

			foreach bank in `r(varlist)'{
				preserve
					keep state_mun `bank'
					gen bank_labels = "`bank'"
					rename `bank' funds
					destring funds, replace force
					quietly append using `daux'
					save `daux', replace
				restore
			}

			use `daux', clear

			keeporder bank_labels state_mun funds

			*Renaming banks
			replace bank_labels = "Banca Múltiple" if strpos(bank_labels, "Sistema") > 0
			replace bank_labels = "Banca Múltiple" if strpos(bank_labels, "Total") > 0

			replace bank_labels = subinstr(bank_labels, " *", "", .)
			replace bank_labels = subinstr(bank_labels, "*", "", .)

			replace bank_labels = "ABC Capital" if strpos(bank_labels, "ABC") > 0
			replace bank_labels = "Banco S3" if strpos(bank_labels, "S3") > 0
			replace bank_labels = "Accendo Banco" if strpos(bank_labels, "Accendo") > 0
			replace bank_labels = "Azteca" if strpos(bank_labels, "Azteca") > 0
			replace bank_labels = "American Express" if strpos(bank_labels, "Express") > 0
			replace bank_labels = "Bancrea" if strpos(bank_labels, "Bancrea") > 0
			replace bank_labels = "Base" if strpos(bank_labels, "Base") > 0
			replace bank_labels = "Covalto" if strpos(bank_labels, "Finterra") > 0 | ///
								strpos(bank_labels, "ovalto") > 0
			replace bank_labels = "Bancoppel" if strpos(bank_labels, "oppel") > 0
			replace bank_labels = "Banorte" if strpos(bank_labels, "BanorteIxe") > 0
			replace bank_labels = "Bank of America" if strpos(bank_labels, "America") > 0
			replace bank_labels = "Bank Of China" if strpos(bank_labels, "China") > 0
			replace bank_labels = "BBVA" if strpos(bank_labels, "BBVA") > 0
			replace bank_labels = "BNP Paribas México" if strpos(bank_labels, "BNP") > 0
			replace bank_labels = "Fundación Dondé" if strpos(bank_labels, "Dondé") > 0
			replace bank_labels = "Mifel" if strpos(bank_labels, "Mifel") > 0
			replace bank_labels = "Inmobiliario Mexicano" if strpos(bank_labels, "Inmobil") > 0
			replace bank_labels = "Bajío" if strpos(bank_labels, "Bajío") > 0
			replace bank_labels = "Walmart" if strpos(bank_labels, "Walmart") > 0
			replace bank_labels = "JP Morgan" if strpos(bank_labels, "Morgan") > 0
			replace bank_labels = "Banco Keb Hana" if strpos(bank_labels, "Hana") > 0
			replace bank_labels = "Famsa" if strpos(bank_labels, "Famsa") > 0
			replace bank_labels = "Intercam" if strpos(bank_labels, "Inter Banco") > 0 | ///
								strpos(bank_labels, "Intercam") > 0 
			replace bank_labels = "Credit Suisse" if strpos(bank_labels, "Suisse") > 0 
			replace bank_labels = "UBS" if strpos(bank_labels, "UBS") > 0  
			replace bank_labels = "Ve por Más" if strpos(bank_labels, "Más") > 0 
			replace bank_labels = "MUFG" if strpos(bank_labels, "Tokyo") > 0 | ///
								strpos(bank_labels, "BTMU") > 0 | ///
								strpos(bank_labels, "MUFG") > 0 
			replace bank_labels = "Mizuho" if strpos(bank_labels, "Mizuho") > 0 
			replace bank_labels = "Hey Banco" if strpos(bank_labels, "HEY") > 0 | strpos(bank_labels, "Hey") > 0 
			replace bank_labels = "Bineo" if strpos(bank_labels, "BINEO") > 0 
			replace bank_labels = "Revolt" if strpos(bank_labels, "Revolt") > 0 
			replace bank_labels = "Plata" if strpos(bank_labels, "Plata") > 0
			replace bank_labels = "Openbank" if strpos(bank_labels, "OPEN") > 0
			replace bank_labels = "Citi de México" if strpos(bank_labels, "CitiM") > 0
			
		
			
			*Adding bank codes
			gen label = bank_labels
			
			capture drop if label == "AY"
			capture drop if label == "BA"
			capture drop if label == "BB"
			capture drop if label == "Estado"
			capture drop if label == "Municipio"
			
			merge m:1 label using "\\Statadgef\darmacro\Osvaldo\Otros_DTA\Nombres de bancos.dta", keepusing(bank_id)

				replace bank_id = 40131 if strpos(bank_labels, "Famsa") > 0
				replace bank_id = 40134 if strpos(bank_labels, "WalMart") > 0
				replace bank_id = 40037 if strpos(bank_labels, "Interacc") > 0
				replace bank_id = 40102 if strpos(bank_labels, "Investa") > 0
				replace bank_id = 0 if strpos(bank_labels, "Múltiple") > 0
				replace bank_id = 40146 if strpos(bank_labels, "Bicentenario") > 0 
				replace bank_id = 40137 if strpos(bank_labels, "Bancoppel") > 0 
				replace bank_id = 40154 if strpos(bank_labels, "ovalto") > 0 
				replace bank_id = 40156 if strpos(bank_labels, "abadell") > 0 
				replace bank_id = 40148 if strpos(bank_labels, "agatodo") > 0  
				replace bank_id = 40158 if strpos(bank_labels, "Mizuho") > 0 
				replace bank_id = 40160 if strpos(bank_labels, "S3") > 0
				replace bank_id = 40124 if strpos(bank_labels, "Deutsche") > 0
				
				
				drop if funds == . | state_mun == .
				drop _merge
				
			$run_tags

			gen monthly_date = ym(`y', `0m')
			order bank_id state_mun monthly_date
			sort bank_id state_mun
			
			format %tm monthly_date
			
			compress
			save "${dataS}\CAPTACION/C_`y'`0m'.dta", replace
		}
	}
}

clear
*
*** Appending all datasets
quietly{
forvalues y = 2014 / 2025{
	forvalues m = 1 / 12{
		local 0m : di %02.0f `m'
	capture noisily: append using "${dataS}\CAPTACION/C_`y'`0m'.dta"
	}
}
}
replace funds = funds / 1e6

drop bank_labels
label variable funds "Captación total (mdp)"

collapse (sum) funds, by(bank_id state_mun monthly_date)



compress

preserve
collapse (sum) funds if bank_id == 0, by(monthly_date)

list if year(dofm(monthly_date)) == 2025 | year(dofm(monthly_date)) == 2024
restore

$run_tags

label data "Captación Total (nominal): mdp. ID: Banco-Mun-Mes"
save "${dataS}/[6]Captación Total.dta", replace