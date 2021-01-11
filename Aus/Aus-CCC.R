#load the R packages
library(tidyverse)
library(sf)
library(tmap)
library(viridis)
library(lubridate)

# Read the CSV file of the confirmed cases
Confirmed<- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"))
# Select the newest data when I write the essay
Confirmed_Newest<- dplyr::select(Confirmed, `Province/State`, `Country/Region`, Lat, Long,`1/7/21`)

Australia <- Confirmed_Newest %>% 
  filter(`Country/Region`=="Australia")

#Select the updated data of Australia
Australia_Newest <- Confirmed_Newest %>% 
  filter(`Country/Region`=="Australia") %>% 
  select(-`Country/Region`) %>% 
  rename(State=`Province/State`, Confirmed=`1/7/21`)

# Load the states data in the package ozmaps, it contains the various geographic information of Australia
data("ozmap_states")
sf_oz <- ozmap_data("states")
cov_AUS <- left_join(sf_oz, Australia_Newest, by = c("NAME" = "State"))
nrow(cov_AUS)

#Set the breaks
breaks <- c(10, 1000, 30000)

#use tmap functions to plot the map
tm_shape(cov_AUS) +
  tm_polygons(border.col="white", 
              lwd=2, 
              col="Confirmed", 
              style = "cont",
              breaks=breaks, 
              title="Confirmed rate", 
              palette=viridis(n=5, direction=-1, option="A")) +
  tm_legend(position=c("left", "bottom"), 
            legend.title.size=1.5, 
            legend.text.size=1) +
  tm_layout(bg.color = "grey90")





