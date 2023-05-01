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
tempo <- readRDS(files$buildings)%>%
         mutate(perdio=factor(perdio, levels=c(0,1),
                       labels=c("Didn't loose", "Lost")))%>%
         filter(!is.na(perdio))
         
buildings <- st_as_sf(tempo, coords = c("lon", "lat"), crs =st_crs(shape), 
                   agr = "constant")

#Mapa de edificios
ggplot() +
  geom_sf(data = shape,
          fill = "white",
          color = "black") +
  geom_sf(data = buildings, size=1,
          aes(fill=perdio, color=perdio))+
  tema+
  scale_fill_manual(values=palette)+
  scale_color_manual(values=palette)+
  labs(title="Buildings in NYC that lost rent \n stabilized apartments",
       subtitle="From 2019 to 2021", caption=caption1, color="", fill="")
save("mapa-buildings")

#Airbnb Maps
airbnbs <- readRDS(files$airbnbs)%>%
           mutate(rs_unit=factor(rs_unit, labels=c("No rent-stabilized building",
                                                  "Rent-stabilized building")))%>%
           filter(!is.na(rs_unit))
airbnbs <- st_as_sf(airbnbs, coords = c("longitude", "latitude"), crs =st_crs(shape), 
                      agr = "constant")


#Mapa de Airbnbs
ggplot() +
  geom_sf(data = shape,
          fill = "white",
          color = "black") +
  geom_sf(data = airbnbs, size=1,
          aes(fill=rs_unit, color=rs_unit))+
  tema+
  scale_fill_manual(values=palette)+
  scale_color_manual(values=palette)+
  labs(title="Airbnbs in NYC that are in buildings \n that lost rent-stabilized apartments ",
       subtitle="", caption=caption1, color="", fill="")
save("mapa-airbnbs")

