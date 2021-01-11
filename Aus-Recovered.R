library(tidyverse)
library(sf)
library(tmap)
library(spData)
library(viridis)
library(lubridate)

Recovered<- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"))
Recovered_Newest<- dplyr::select(Recovered, `Province/State`, `Country/Region`, Lat, Long,`1/7/21`)



AusRec_Newest <- Recovered_Newest %>% 
  filter(`Country/Region`=="Australia") %>% 
  select(-`Country/Region`) %>% 
  rename(State=`Province/State`, Confirmed=`1/7/21`)

data("ozmap_states")
sf_oz <- ozmap_data("states")
cov_AusRec <- left_join(sf_oz, AusRec_Newest, by = c("NAME" = "State"))
nrow(cov_AusRec)

breaks <- c(50, 1000, 20000)
tm_shape(cov_AusRec) +
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

