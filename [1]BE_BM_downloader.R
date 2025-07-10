pacman::p_load(readxl,
               dplyr)

rm(list=ls())

options(timeout=9999)  #Adding time to download large files

setwd("//Statadgef/darmacro/Data/Bank Data/data/Raw/Boletines Estadísticos/B/")

cnbv_url <- "https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion"

for (y in 2025:2025) {
     for (m in 3:3) {
          mm <- sprintf("%02d", m)
          
          dir.create(paste0("./", y), showWarnings = F)
          
          #Run over different extensions
          extensions <- c(".xlsx", ".xlsm", ".xls")  #Trying multiple extensions...
          
          for (ext in extensions) {
               file_cnbv <- paste0(cnbv_url,"/BE_BM_",y,mm, ext)
               
               #Loop to detect any kinda error
               tryCatch({
               download.file(file_cnbv, destfile = paste0("./",y, "/BE_BM_",y,mm, ext), mode = "wb")
               
               ask_info <- file.info(paste0("./",y, "/BE_BM_",y,mm, ext))
               # If the download is not successful, and something else was downloaded
                    #, then remove whatever it was downloaded and try the next extension
               if (ask_info$size < 15000 | is.na(ask_info$size)){ 
                    file.remove(paste0("./",y, "/BE_BM_",y,mm, ext))
               } else {
                    break
               }}, error = function(e) {
                    # If an error occurs (e.g., file not found), try the next extension
                    cat(paste("Error:", e$message, "\n"))
               })
               
          }
     }
}

end
#Downloading others...

download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE_BM_%20202308.xlsx",
              destfile = "./2023/BE_BM_202308.xlsx", mode = "wb")
#download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE_BM_%20202309.xlsx",
#              destfile = "./2023/BE_BM_202309.xlsx", mode = "wb")
download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE_BM_202402.xlsx",
              destfile = "./2024/BE_BM_202402.xlsx", mode = "wb")

download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE_BM%20_202406.xlsx",
              destfile = "./2024/BE_BM_202406.xlsx", mode = "wb")

download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE%20BM%20202411.xlsx",
              destfile = "./2024/BE_BM_202411.xlsx", mode = "wb")
          
download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE%20BM%20202412.xlsx",
              destfile = "./2024/BE_BM_202412.xlsx", mode = "wb")

download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE%20BM%20202502.xlsx",
              destfile = "./2025/BE_BM_202502.xlsx", mode = "wb")

download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE%20BM%20202503.xlsx",
              destfile = "./2025/BE_BM_202503.xlsx", mode = "wb")

download.file("https://portafolioinfo.cnbv.gob.mx/_layouts/15/download.aspx?SourceUrl=https://portafolioinfo.cnbv.gob.mx/PortafolioInformacion/BE%20BM%20202504.xlsx",
              destfile = "./2025/BE_BM_202504.xlsx", mode = "wb")
