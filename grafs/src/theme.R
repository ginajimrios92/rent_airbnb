#
# Author: Gina Jiménez
# --------------------------------------------------
#  rent_airbnb/grafs/src/theme.r
#

if(!require(pacman))install.packages("pacman")
pacman::p_load(tidyverse, extrafont)
extrafont::loadfonts(quiet=T)

Sys.setlocale("LC_ALL", "es_ES.UTF-8") 
options(scipen = 9999)

tema <- theme_bw() + 
        theme(text = element_text(family = "Trebuchet MS", color = "black"),
              plot.title = element_text(face = "bold", size = 20),
              legend.background = element_rect(fill = "white", size = 4, colour = "white"),
              legend.position = "top",
              axis.ticks = element_line(colour = "grey70", size = 0.2),
              panel.grid.major = element_line(colour = "grey70", size = 0.2),
              panel.grid.minor = element_blank()
  )

save <- function(name){
  ggsave(paste0(here("grafs/out"), name, ".png"), width = 6, height = 8)
}

palette <- c("#3a405a", "#ec058e", "#62BBC1", "#faa916")

caption1 <- "Source: Dataset Rent Stabilized Buildings https://github.com/nycdb/nycdb/wiki/Dataset:-Rent-Stabilized-Buildings"
caption2 <- "Source: Inside Airbnb data http://insideairbnb.com/get-the-data/"

# done.
