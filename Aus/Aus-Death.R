#load the R packages
library(tidyverse)
library(sf)
library(tmap)
library(spData)
library(viridis)
library(lubridate)
library(ozmaps)

# Read the CSV file of the death cases
Death<- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"))
## Select the newest data when I write the essay
Death_Newest<- dplyr::select(Death, `Province/State`, `Country/Region`, Lat, Long,`1/7/21`)


#Select the updated data of Australia
AusDeath_Newest <- Death_Newest %>% 
  filter(`Country/Region`=="Australia") %>% 
  select(-`Country/Region`) %>% 
  rename(State=`Province/State`, Confirmed=`1/7/21`)

# Load the states data in the package ozmaps, it contains the various geographic information of Australia
data("ozmap_states")
sf_oz <- ozmap_data("states")
cov_AusDeath <- left_join(sf_oz, AusDeath_Newest, by = c("NAME" = "State"))
nrow(cov_AusDeath)

#Set the breaks
breaks <- c(0, 50, 1000)
#use tmap functions to plot the map
tm_shape(cov_AusDeath) +
  tm_polygons(border.col="white", 
              lwd=2, 
              col="Confirmed", 
              style = "cont",
              breaks=breaks, 
              title="Death Cases", 
              palette=viridis(n=5, direction=-1, option="A")) +
  tm_legend(position=c("left", "bottom"), 
            legend.title.size=1.5, 
            legend.text.size=1) +
  tm_layout(bg.color = "grey90")

