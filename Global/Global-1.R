#load packages
library(tidyverse)
library(ggplot2)
library(maps)
library(viridis)
library(readr)

#Read the CSV file
Confirmed <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"))

#Check the updated information
select(Confirmed,tail(names(Confirmed),1))

#load the worldmap
world <-map_data("world")
ggplot() +geom_polygon(data=world, aes(x=long, y=lat, group=group), fill="grey")

#Plot the map with COVID data
ggplot()+
  geom_polygon(data=world,aes(x=long,y=lat,group=group),fill="grey",alpha=0.3) +
  geom_point(data=Confirmed,aes(x=Long,y=Lat,size=`2/7/20`,color=`2/7/20`),alpha=0.5)

# Use ggplot Func to plot the map
mybreaks<- c(1, 20, 100, 1000, 50000)
mylabels<- c("1-19", "20-99", "100-999","1,000-49,999", "50000+")
ggplot() +
  geom_polygon(data=world, aes(x=long, y=lat,group=group), fill="grey", alpha=0.3) +
  geom_point(data=Confirmed, aes(x=Long, y=Lat,size=`1/7/21`, color=`1/7/21`), alpha=0.5) +
  scale_size_continuous(name="Confirmedcases", trans="log", range=c(1,7), breaks=mybreaks,labels=mylabels) +
  scale_colour_viridis_c(option="inferno", direction=-1,name="Confirmed cases", trans="log", breaks=mybreaks,labels=mylabels) +
  guides(colour=guide_legend()) +
  theme_void() +
  theme(legend.position="bottom")+
  geom_line() + labs(title = "Global Cumulative cases on 7th January 2021")+
  theme(plot.title = element_text(hjust = 0.5))
  

