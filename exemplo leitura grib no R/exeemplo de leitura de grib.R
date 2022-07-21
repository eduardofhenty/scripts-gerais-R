###########################################################################
#Eduardo Fernandes Henriques                                              #
#Exemplo de leitura de grib2 no R com  dados de reanálise do ERA-Iterim   #    
#                                                                         #                
###########################################################################
library(raster)
library(ggplot2)
library(rgdal)
#Função para converter de matriz para dataframe
mat_to_df <- function (xlon,ylat,mat){
  dado_ac <- mat
  grd <- expand.grid(x = xlon , y =ylat )  
  names(grd) <- c("lon","lat")
  dado <- matrix(data=0,nrow=length(ylat)*length(xlon))
  k <- 1
  
  for (j in 1:length(ylat)){
    for (i in 1:length(xlon)) {
      dado[k] <- dado_ac[j,i]
      k <- k+1
    }
  }
  
  dado_res <- cbind.data.frame(lon= grd$lon,lat=grd$lat,value=dado )
  return(dado_res)
  
}#Fim da função


####
##Ficheiro shape
arquivo_shape  <-  "C:/shape_file/Estados_do_Brasil/Estados_do_Brasil/Brasil.shp"
shape_brasil <- rgdal::readOGR(arquivo_shape)

#Arquivo grib

#ERA Interim atmospheric model analysis for surface
file_grib <- "C:/dadospc/era/ei.oper.an.sfc.regn128sc.2t_167.201901"

#Dados com multiplas camadas. Deve se usar a função brick do pacote raster
grib <- brick(file_grib)

#Definindo a sequencia de lat e lon 
seq_lat <- seq(89.463,-89.463,length=256) 
seq_lon <- seq(0,360,length=512)

#Transformando os dados para array. Usando o array do pacote raster
df_grib <- as.array(grib)

#Resulta numa matriz
df_grib2 <- df_grib[,,1]-273

#Converte de matriz para uma tabela com lat, lon e prec
df_grib2 <- mat_to_df(xlon=seq_lon-360,ylat=seq_lat,mat = df_grib2)

ggplot() + geom_tile(data = df_grib2, aes(x = lon, y = lat, fill = value)   ) +                           
  scale_x_continuous(limits = c(280-360, 330-360)) +
  geom_path(aes(x = long, y = lat, group = group), data = shape_brasil)+
  scale_fill_gradientn(colours=c("#0000CD","#C90303","#FFFFCC"), name="            Temperatura (ºC)")+
  theme(plot.title = element_text(size = 20, face="bold"),legend.title=element_text(size = 15, angle=90,face="bold",hjust=1))+
  guides(fill = guide_colorbar(barwidth = 0.5, barheight = 10,title.position = 
                                 "right"))




