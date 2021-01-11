library(tidyverse)
library(sf)
library(tmap)
library(spData)
library(viridis)
library(lubridate)

Death<- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
Death_Newest<- dplyr::select(Death, `Province_State`, `Country_Region`, Lat, Long_,`1/7/21`)

US_DeathNewest <- Death_Newest %>% 
  filter(`Country_Region`=="US") %>% 
  select(-`Country_Region`) %>% 
  rename(State=`Province_State`, Death=`1/7/21`)

data(us_states)
cov_USDeath <- left_join(us_states, US_DeathNewest, by = c("NAME" = "State"))
nrow(cov_USDeath)

breaks <- c(0, 100, 16000)
tm_shape(cov_USDeath) +
  tm_polygons(border.col="white", 
              lwd=2, 
              col="Death", 
              style = "cont",
              breaks=breaks, 
              title="Death Cases", 
              palette=viridis(n=5, direction=-1, option="A")) +
  tm_legend(position=c("left", "bottom"), 
            legend.title.size=1.5, 
            legend.text.size=1) +
  tm_layout(bg.color = "grey90")


