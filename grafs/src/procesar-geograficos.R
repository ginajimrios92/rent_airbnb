#
# Author: Gina Jiménez
# --------------------------------------------------
# rent_airbnb/grafs/src/procesar-geograficos.R.r
rm(list=ls())
if(!require(pacman))install.packages("pacman")
pacman::p_load(tidyverse, extrafont, here, sf)
extrafont::loadfonts(quiet=T)

Sys.setlocale("LC_ALL", "es_ES.UTF-8") 
options(scipen = 9999)

files <- list(airbnbs = here("import-clean/out/airbnbs.rds"),
              buildings = here("import-clean/out/buildings.rds"),
              shapefile = "/Users/georginajimenez92/Documents/inputs-datos/shape_files/ZIP_CODE_040114.shp")

#### Tema  ####
source(here("grafs/src/theme.R"))


#Bajar datos de edificios y creando buffers alrededor de ellos
buildings <- readRDS(files$buildings)%>%
             mutate(dif=rsunitslatest-rsunits2007,
                    perdio=ifelse(dif<0, 1, 0))%>%
             filter(perdio==1)%>%
             filter(!is.na(lng))

buildings <- mutate(buildings, id = 1:nrow(buildings))
buildings <- st_as_sf(buildings, coords = c("lat", "lng"), crs = 28992, agr = "constant")
build_sh <- select(buildings, id, geometry)
build_sh = st_buffer(build_sh, .0005)
plot(build_sh)

### Crear un mapa con los edificios que supuestamente perdieron rent controlled apartments


#Bajar datos de airbns y configurarlos en la misma proyección que edificios
airbnbs <- readRDS(files$airbnbs)
airbnbs <- st_as_sf(airbnbs, coords = c("latitude", "longitude"), crs = 28992, agr = "constant")

st_crs(airbnbs) = st_crs(build_sh)


## Vamos a mezclarlos
buff = lengths(st_intersects(airbnbs, build_sh)) > 0
sum(buff)

#Con ese tamaño, hay como 5115 airbnbs que parecen caer en edificios que son rent controlled
airbnbs <- mutate(airbnbs, build=buff)


#Make buildings that have lost rent controlled apartments buffers
ggplot(data = airbnbs) +
geom_sf(aes(color = build))+
labs(title="Rate of calls about homeless people\n in each Zipcode")+
  tema



plot(aver)



