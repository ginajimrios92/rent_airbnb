#
# Author: Gina Jiménez
# -----------------------------------------------------------
# rent_airbnb/import-clean.R

#packages and routes
library(pacman)
p_load(jsonlite, tidyverse, httr, here, sf, janitor)

files <- list(rs_units = "/Users/georginajimenez92/Documents/inputs-datos/rent_airbnb/rent_stabilized2021.csv",
              coordenadas = "/Users/georginajimenez92/Documents/inputs-datos/rent_airbnb/coordenadas.csv",
              airbnbs = "/Users/georginajimenez92/Documents/inputs-datos/rent_airbnb/airbnbs.csv")


#1. Pegar datos de units con coordenadas y hacer el dato espacial
buildings <- read.csv(files$rs_units)%>%
             select(ucbbl, uc2019, uc2021)%>%
             mutate(dif= uc2021-uc2019,
                    perdio=ifelse(dif<0, 1, 0))
coordenadas <- read.csv(files$coordenadas)%>%
               select(borough, ucbbl, lon, lat)
buildings <- left_join(buildings, coordenadas)%>%
             filter(!is.na(lon))
data_buildings <- buildings
rs_los <- filter(buildings, perdio==1)%>%
          select(ucbbl, lon, lat)
rs_los <- st_as_sf(rs_los, coords = c("lat", "lon"), crs = 28992, 
                      agr = "constant")
rs_los <- st_buffer(rs_los, .0005)
plot(rs_los)

#2. Hacer datos de airbnbs espaciales
airbnbs <- read.csv(files$airbnbs)
data_airbnbs <- airbnbs
airbnbs <- st_as_sf(airbnbs, coords = c("latitude", "longitude"), crs = 28992, 
                    agr = "constant")
st_crs(airbnbs) = st_crs(rs_los)

#3. Pegar ambos y ver cuáles se intersectan
buff = lengths(st_intersects(airbnbs, rs_los)) > 0
sum(buff) #Al parecer hay 5840 Airbnbs en edificios donde se han perdido rent stabilized apartments

airbnbs <- mutate(airbnbs, rs_unit=buff)
data_airbnbs <- mutate(data_airbnbs, rs_unit=buff)
aver <- filter(airbnbs, rs_unit==T)


saveRDS(data_buildings, here("import-clean/out/buildings.rds"))
saveRDS(data_airbnbs, here("import-clean/out/airbnbs.rds"))
write.csv(aver, here("import-clean/out/base_airbnbs.csv"))

        
