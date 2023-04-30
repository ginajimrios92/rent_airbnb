#
# Author: Gina Jiménez
# -----------------------------------------------------------
# rent_airbnb/import-clean.R

#packages and routes
library(pacman)
p_load(jsonlite, tidyverse, httr, here, sf, janitor)

files <- list(directorio = "/Users/georginajimenez92/Documents/inputs-datos/who_owns/",
              airbnbs = "/Users/georginajimenez92/Documents/inputs-datos/airbnbs.csv",
              shape = here("/Users/georginajimenez92/Documents/inputs-datos/shape_files/ZIP_CODE_040114.shp"))

dir <- dir(files$directorio)

#Import data 
data <- data.frame()

for (i in 1:9) {
     tempo <- read.csv(paste0(files$directorio,dir[i]))
     tempo$lastsaleacrisid <- as.character(tempo$lastsaleacrisid)
     data <- bind_rows(data, tempo)
     rm(tempo)
}

data <- unique(data)
saveRDS(data, here("import-clean/out/buildings.rds"))

data <- read.csv(files$airbnbs)
saveRDS(data, here("import-clean/out/airbnbs.rds"))

#Configure map
mapa <- sf::st_read(here("shape_files/ZIP_CODE_040114.shp"))%>%
        clean_names()



        
