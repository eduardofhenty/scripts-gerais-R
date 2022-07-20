############################################################
#Um exemplo simples de como plotar dados de série temporais  
#Autor: Eduardo Fernandes Henriques
#############################################################
library(openair)
library(ggplot2)
#Leitura do ficheiro com dados de temperatura do ERA5-land
name_f <-  "C:/data3/era5 land/output_era5/SP2/pira/era5land_SP2_pira_t2m.csv"
df_era <- read.table(file = name_f,header = T,sep = ";",dec = ".")
df_era$date <- as.POSIXct(df_era$date,tz = "GMT")

#Calculando alguns calculos estatísticos 
df_temp <- timeAverage(df_era,statistic = "mean",avg.time = "month")
df_temp_min <- timeAverage(df_era,statistic = "min",avg.time = "month")
df_temp_max <- timeAverage(df_era,statistic = "max",avg.time = "month")
#Juntando tudo num só df
mydata <- cbind.data.frame(date=df_temp$date,media=df_temp$t2m,min=df_temp_min$t2m,max=df_temp_max$t2m ) 

head(mydata)

mydata <- as.data.frame( df_temp)

ggplot()+
  geom_line (data=mydata,aes(x=as.Date( mydata[,1]),y=media))+
  scale_y_continuous( breaks = seq(15,30,5),limits = c(15,30))+
  scale_x_date("",date_minor_breaks = "24 months",breaks = "48 months ",date_labels = "%Y")+
  theme_bw(base_size=12, base_family="Helvetica")  +
  theme(text = element_text(size=28),plot.title = element_text(size = 35,hjust = 0.5, face="bold"),
        axis.text.x=element_text(size=24 ),
        axis.text.y=element_text(size=24),legend.position="bottom" )+
  labs(x = "Data", y = "Temperatura (ºC)",
       title = "Pirassunuga",
       subtitle = "Média mensal de temperatura",
       caption = "Fonte: ERA5-land",
       tag = "Fig. 1")

ggplot()+
  geom_line (data=mydata,aes(x=as.Date( mydata[,1]),y=media,colour="black"))+
  geom_line (data=mydata,aes(x=as.Date( mydata[,1]),y=max,colour="red"))+
  geom_line (data=mydata,aes(x=as.Date( mydata[,1]),y=min,colour="blue"))+
  scale_y_continuous(breaks = seq(0,40,5))+
  scale_x_date("",date_minor_breaks = "24 months",breaks = "48 months ",date_labels = "%Y")+
  theme_bw(base_size=12, base_family="Helvetica")  +
  theme(text = element_text(size=28),plot.title = element_text(size = 35,hjust = 0.5, face="bold"),
        axis.text.x=element_text(size=24 ),
        axis.text.y=element_text(size=24),legend.position="bottom" )+
  labs(x = "Data", y = "Temperatura (ºC)",
       title = "Pirassunuga",
       subtitle = "Cálculos estatísticos mensais de temperatura",
       caption = "Fonte: ERA5-land",
       tag = "Fig. 2")+
  scale_colour_manual("Legenda",labels=c("Média","Max","Min"),breaks=c("black","red","blue"),
                      values=c("black","red","blue"))

#Mesma saida em termos de plot mas com o dado entrada organizado diferentemente
#Mudando a estrutura do df. 

mydata2 <- melt(mydata,id.vars="date" )


ggplot()+
  geom_line (data=mydata2,aes(x=as.Date( mydata2[,1]),y=value,colour=variable))+
  scale_y_continuous(breaks = seq(0,40,5))+
  scale_x_date("",date_minor_breaks = "24 months",breaks = "48 months ",date_labels = "%Y")+
  theme_bw(base_size=12, base_family="Helvetica")  +
  theme(text = element_text(size=28),plot.title = element_text(size = 35,hjust = 0.5, face="bold"),
        axis.text.x=element_text(size=24 ),
        axis.text.y=element_text(size=24),legend.position="bottom" )+
  labs(x = "Data", y = "Temperatura (ºC)",
       title = "Pirassunuga",
       subtitle = "Cálculos estatísticos mensais de temperatura",
       caption = "Fonte: ERA5-land",
       tag = "Fig. 3")+
  scale_colour_manual("Legenda",labels=c("Média","Max","Min"),breaks=c("media","max","min"),
                      values=c("black","red","blue"))

  
  