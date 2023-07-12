##########################################################################
#  MPPCPRO file example                                                  #
#  to get the outputs of the model into an HTML using leaflet            #
#                                                                        #
#  Cyril Piou    & Lucile Marescot                                       # 
#                  June 2023                                             # 
##########################################################################

library(htmlwidgets)
library(leaflet)
library(raster)
library(lubridate)
library(viridis)
path="D:/Mes Donnees/GitHub/LocustForecastCLCPRO3/"
startdate="2023-06-01"
howmanydecades=5
gregariousmodel=FALSE
fieldData=FALSE

path_forecast=paste0(path,"/OUTPUTmachine_learning/RFfit2onFullData2010_2020")
load(paste0(path,"/LOCUSTdata/CLCPRO.RData"))
load(paste0(path,"/LOCUSTdata/clcproBase.RData"))

### Prepare the names of the files/dates to use in the interface:
strc=strsplit(startdate,"-")
year=strc[[1]][1]
month=strc[[1]][2]
day=strc[[1]][3]

namesall = startdate
if(gregariousmodel){
  namesallgreg=paste(startdate,"Transiens")
}
if(howmanydecades>1){
  for(i in 2:howmanydecades){
    day=as.numeric(day)+10
    if(day>21){
      day="01"
      month=as.numeric(month)+1
      if(month>12){
        month="01"
        year=as.numeric(year)+1
      }
    }
    newdate=as.character(as.Date(paste(year,month,day,sep="-")))
    namesall=c(namesall,newdate)
    if(gregariousmodel){
      namesallgreg=c(namesallgreg,paste(newdate,"Transiens"))
    }
  }
}

### prepare leaflet infos
palPres <- leaflet::colorBin(palette = viridis(11),
                          bins = 11,
                          domain = seq(50,100,by=5),
                          na.color ="transparent")
palGreg<-  colorNumeric(c('#FFAC1C','#C70039','#581845'), seq(50,100,by=5), na.color = "transparent")
#palGreg <- leaflet::colorBin(palette = magma(11),
#                          bins = 11,
#                          domain = seq(50,100,by=5),
#                          na.color ="transparent")

google <- "http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga"

googleSat <- "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G"

mbAttr <- 'Return to <a href="https://pioucyril.github.io/mppcpro/"> MPPCPRO webpage</a>. Map data & Imagery &copy; <a href="https://www.google.com/intl/en_fr/help/legalnotices_maps/">Google</a> & &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Development &copy; <a href="https://locustcirad.wordpress.com/">LocustCirad</a>, Funding <a href="https://afd.fr/">AFD</a> & projects <a href="https://anrpepper.github.io/">ANR PEPPER</a>, <a href="https://accwa.isardsat.space/">RISE H2020 ACCWA</a> Supervision <a href="https://fao.org/clcpro/">CLCPRO</a>'
dfs <- read.csv(textConnection(
"Name,Lat,Long
INPV Alg?rie,36.723056, 3.155556
DPV Burkina Faso, 12.305000, -1.498889
Lybie, 32.887222, 13.191111
CNLAA Maroc,30.335815,-9.478916 
CNLCP Mali,12.638611, -8.000833
CNLAA Mauritanie,18.079323187108166, -15.93986147046241
CNLA Niger, 13.532500, 2.073611
ANLA Tchad, 12.128333, 15.009167
Tunisie, 36.828611, 10.184444
DPV Senegal, 14.747378807885443, -17.355923729602747"))

### Start creating leaflet
m=leaflet() %>% #
addTiles(urlTemplate=google,attribution = mbAttr,group="Google") %>%
addTiles(urlTemplate=googleSat,attribution = mbAttr,group="Satellite") %>%
addTiles(attribution = mbAttr,group = "OSM") %>%
addPolygons(data=clcpro,fillColor = "#ffffff",fillOpacity=0.1,group ="CLCPRO") %>%
setView(5,22,zoom=5) %>%
addLegend(pal = palPres, values = seq(50,100,by=5), title = "Probability (in %) to observe Locusts")
if(gregariousmodel){
  m = addLegend(m, pal = palGreg, values = seq(50,100,by=5), title = "Probability (in %) to observe Transiens")
}

### Add rasters of forecast
i = 1
for(name in namesall){
  short=paste0(strsplit(name,"-")[[1]],collapse="")
  r1 <- raster(paste0(path_forecast,"/PresAbs/meanpred",name,".tif"))
  rtrans=round(r1*100)
  rtrans=rtrans*(r1>0.5)
  values(rtrans)[values(rtrans)==0]<-NA
  if(gregariousmodel){
    r1g <- raster(paste0(path_forecast,"/Greg/meanpredgreg",namesallgreg[i],".tif"))
    rtrg=round(r1g*100)*(r1>0.5)*(r1g>0.5)
    values(rtrg)[values(rtrg)==0]<-NA
    writeRaster(rtrg,paste0("img/",short,"g.tif"),overwrite=T)
    r1g <- raster(paste0("img/",short,"g.tif")) 
  }
  writeRaster(rtrans,paste0("img/",short,".tif"),overwrite=T)
  r1 <- raster(paste0("img/",short,".tif"))
  i = i + 1
  m=addRasterImage(m,r1, colors=palPres, opacity = 0.75,group=name)
  if(gregariousmodel){
    m=addRasterImage(m,r1g, colors=palGreg, opacity = 0.75,group=namesallgreg[i])
  }
  #m=hideGroup(m,name) #should we hide some at beginning?
}


### Add field data
if(fieldData){
  fb<-as.data.frame(clcproBase)
  fb$month<-month( fb$date)
  fb$year<-year(fb$date)
  fb$day<-as.numeric(format(fb$date, "%d"))
  year=strc[[1]][1]
  month=strc[[1]][2]
  day=as.numeric(strc[[1]][3])
  df<- fb[fb$day > day & fb$day < day + 11 & fb$month == as.numeric(month) & fb$year == as.numeric(year),]
  
  m = addCircleMarkers(m, data=df[df$AbsSolTrans==0,], lng = ~Longitude, lat = ~Latitude, radius =5,col="black",group="realData") 
  m = addCircleMarkers(m, data=df[df$AbsSolTrans==1,], lng = ~Longitude, lat = ~Latitude, radius =5,col="blue",group="realData")
  m = addCircleMarkers(m, data=df[df$AbsSolTrans==2,], lng = ~Longitude, lat = ~Latitude, radius =5,col="red",group="realData") 
}

### Add markers and cosmetics
m = addMarkers(m, dfs$Long, dfs$Lat, label = dfs$Name,group="UNLAs")
overlayg = c("CLCPRO",namesall,ifelse(gregariousmodel,c(namesall,namesallgreg),namesall),"UNLAs")
if(fieldData){overlayg=c(overlayg,"realData")}
m=addLayersControl(m,
   baseGroups = c("Google Map","Satellite","OSM"),
   overlayGroups = overlayg,
   options = layersControlOptions(collapsed = FALSE)
)
m=addMiniMap(m,toggleDisplay = TRUE)
m = addEasyButton(m, easyButton(icon="fa-globe", title="Reset Zoom", 
     onClick=JS("function(btn, map){ map.setView([22,5],5);}")))
m = addScaleBar(m, position = "bottomleft", options = scaleBarOptions(imperial=FALSE)) 
   
#save leaflet into html
saveWidget(m, file="forecast.html")  

      