
library(RColorBrewer)#paleta de cores
library(lattice)#Plot
library(RNetCDF)#Abrir netcdf
library(lubridate)#Lida com datas
#Referencias
#https://thiagodossantos.com/pt/post/2-raster_basic_operations/
#http://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/tmp/
#http://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/

#Dado de temperatura do CRU de 2011 a 2020
fname <- "C:/Data/CRU/cru_ts4.06.2011.2020.tmp.dat.nc"
#A abrir um ficheiro netcdf
fid<-open.nc(fname)

#Imprimindo um sumario do ficheiro
#Informações de como está organizado o ficheiro como número de latitudes, longetude e unidades de medida. 
print.nc(fid)

#A ler os dados
dat<-read.nc(fid)


#latitude
ylat<-dat$lat
#Longitude
xlon<-dat$lon
#time é o número de dias de 1900-1-1
dat$time
data_ini <- as.POSIXct(paste0( as.character( 1900),"-01-01"),tz = "GMT" )
#Para cada mês há um valor
data_mes <- data_ini + ddays(as.numeric( dat$time)) 


#Dimensoes da longitude e latitude
print(c(dim(dat$lon),dim(dat$lat)))

#Plotando uma imagem simples
image(xlon, ylat, dat$tmp[,,1], col = rev(brewer.pal(10, "RdBu")))
#Plotando uma imagem mais elaborada com escala de cores
grid <- expand.grid(xlon = xlon, ylat = ylat)
cutpts <- c( -40, -30, -20, -10, 0, 10, 20, 30, 40)
levelplot(dat$tmp[,,1] ~ xlon * ylat, data = grid, at = cutpts, cuts = 9, pretty = T, 
          col.regions = (rev(brewer.pal(8, "RdBu"))))
title(data_mes[1])

#A fechar o ficheiro
close.nc(fid)
dev.off()
#####
