#AUTOMATIC CODE

#This code downloads the information about fundraising (captación)
#the main link is here: 
#    https://portafolioinfo.cnbv.gob.mx/Paginas/Contenidos.aspx?ID=40&Contenido=Captaci%C3%B3n&Titulo=Banca%20M%C3%BAltiple

rm(list = ls())

pacman::p_load(readxl,
               dplyr)


options(timeout=1000)  #Adding time to download large files


setwd("//Statadgef/darmacro/Data/Bank Data/data/Raw/Boletines Estadísticos/Captación/")

cnbv_url <- "https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BM_Captaci%C3%B3n_"



for (y in 2025:2025) {
     for (m in 3:12) {
          mm <- sprintf("%02d", m)
          
          dir.create(paste0("./", y), showWarnings = F)
          
          #Run over different extensions
          extensions <- c(".xlsx", ".xls")  #Trying multiple extensions...
          
          for (ext in extensions) {
               file_cnbv <- paste0(cnbv_url,y,mm, ext)
               
               #Loop to detect any kinda error
               tryCatch({
                    download.file(file_cnbv, destfile = paste0("./",y, "/BM_Cap_",y,mm, ext), mode = "wb",  method = "libcurl")
                    
                    ask_info <- file.info(paste0("./",y, "/BM_Cap_",y,mm, ext))
                    # If the download is not successful, and something else was downloaded
                    #, then remove whatever it was downloaded and try the next extension
                    if (ask_info$size < 15000 | is.na(ask_info$size)){ 
                         file.remove(paste0("./",y, "/BM_Cap_",y,mm, ext))
                    } else {
                         break
                    }}, error = function(e) {
                         # If an error occurs (e.g., file not found), try the next extension
                         cat(paste("Error:", e$message, "\n"))
                    })
               
          }
     }
}


list.files("//Statadgef/darmacro/Data/Bank Data/Data/Raw/Boletines Estadísticos/Captación/2025", full.names = TRUE)



-FA

#Downloading others...
cnbv_url_e <- "https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BM_Captacion_"

periods <- extensions <- c("201601", "201602", "201604", "201605")
for (p in periods) {
     download.file(paste0(cnbv_url_e, p, ".xls"),
                    destfile = paste0("./",2016, "/BM_Cap_",p, ".xls"),  mode = "wb",  method = "libcurl")
}


download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BM_Captaci%C3%B3n_202502.xlsx",
              destfile = "./2025/BM_Cap_202402.xlsx", mode = "wb")


