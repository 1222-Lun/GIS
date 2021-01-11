library(tidyverse)
library(sf)
library(tmap)
library(spData)
library(viridis)
library(lubridate)

Confirmed<- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"))
Confirmed_Newest<- dplyr::select(Confirmed, `Province/State`, `Country/Region`, Lat, Long,`1/7/21`)

Australia <- Confirmed_Newest %>% 
  filter(`Country/Region`=="Australia")

Australia_Newest <- Confirmed_Newest %>% 
  filter(`Country/Region`=="Australia") %>% 
  select(-`Country/Region`) %>% 
  rename(State=`Province/State`, Confirmed=`1/7/21`)

data("ozmap_states")
sf_oz <- ozmap_data("states")
cov_AUS <- left_join(sf_oz, Australia_Newest, by = c("NAME" = "State"))
nrow(cov_AUS)

breaks <- c(10, 1000, 30000)
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



# Date <- colnames(AUS_2)[2:15]
# AUS_ByDate <- AUS_2 %>% 
#   pivot_longer(Date, names_to = "Date", values_to = "Cases")
# 
# AUS_ByDate <- mutate(AUS_ByDate, Date_N=mdy(Date))
# cov_AUS <- full_join(sf_oz, AUS_ByDate,by = c("NAME" = "State"))
# 
# breaks <- c(0, 1, 10, 100, 1000, 10000, 100000)
# tm_shape(cov_AUS) +
#   tm_polygons(col="Cases",
#               breaks=breaks, 
#               title="Confirmed cases",
#               palette=viridis(n=5, direction=-1, option="A")) +
#   tm_facets(by = "Date_N", nrow = 5, free.coords = FALSE) +
#   tm_layout(legend.position=c(-0.6, -0.01))

