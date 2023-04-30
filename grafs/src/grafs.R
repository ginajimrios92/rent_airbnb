#
# Author: Gina Jiménez
# --------------------------------------------------
# rent_airbnb/grafs/src/grafs.r
rm(list=ls())
if(!require(pacman))install.packages("pacman")
pacman::p_load(tidyverse, extrafont, here, sf, data.table, rgdal)
extrafont::loadfonts(quiet=T)

files <- list(airbnbs = here("import-clean/out/airbnbs.rds"),
              buildings = here("import-clean/out/buildings.rds"),
              shapefile = "/Users/georginajimenez92/Documents/inputs-datos/shape_files/geo_export_01cba034-1333-4783-a94b-630f54772d63.shp")

#### Tema  ####
source(here("grafs/src/theme.R"))
shape <- read_sf(files$shapefile)
st_crs(shape)


## Mapita con todos los edificios que han perdido rent stabilized apartments desde 2019
tempo <- readRDS(files$buildings)
buildings <- st_as_sf(tempo, coords = c("lon", "lat"), crs = 28992, 
                   agr = "constant")
buildings <- st_transform(buildings, crs=st_crs(shape))

ggplot(shape)+
  geom_sf(fill="white")+
  geom_sf(buildings, aes(lon, lat))
  
