##########################################################################
#  MPPCPRO file example                                                  #
#  to get the outputs of the model into an HTML using leaflet            #
#                                                                        #
#  Cyril Piou    & Lucile Marescot                                       # 
#                  June 2022                                             # 
##########################################################################

library(htmlwidgets)
library(leaflet)
library(raster)
library(lubridate)

load("D:/Mes Donnees/GitHub/LocustForecastCLCPRO/LOCUSTdata/CLCPRO.RData")
load("D:/Mes Donnees/GitHub/LocustForecastCLCPRO/LOCUSTdata/clcproBase.RData")
fb<-as.data.frame(clcproBase)
fb$month<-month( fb$date)
fb$year<-year(fb$date)
fb$day<-as.numeric(format(fb$date, "%d"))

df<- fb[fb$day < 11 & fb$month == 10 & fb$year == 2017,]

#r2 <- raster("D:/Mes Donnees/GitHub/LocustForecastCLCPRO/OUTPUTmachine_learning/mFinalAfterRastAgregObsdecade_20220425_164425/RandomForest/prob.modmap2017-10-01.tif")
#r3=round(r2*100)
#r3=r3*(r2>0.5)
#values(r3)[values(r3)==0]<-NA
#writeRaster(r3,"img/20171001.tif",overwrite=T)
r2 <- raster("img/20171001.tif")

#r2b <- raster("D:/Mes Donnees/GitHub/LocustForecastCLCPRO/OUTPUTmachine_learning/mFinalAfterRastAgregObsdecade_20220425_164425/RandomForest/prob.modmap2016-10-01.tif")
#r3=round(r2b*100)
#r3=r3*(r2b>0.5)
#values(r3)[values(r3)==0]<-NA
#writeRaster(r3,"img/20161001.tif",overwrite=T)
r2b <- raster("img/20161001.tif")

pal2 <- colorNumeric(c('#91cf60','#ffffbf','#fc8d59'), seq(50,100,by=5), na.color = "transparent")   

#mapboxL <- "https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw" 
#
#mapboxS <- "https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw" 
#
#mapboxO <- "https://api.mapbox.com/styles/v1/mapbox/outdoors-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw" 
#
#mapboxD <- "https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw" 

google <- "http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga"

googleSat <- "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G"

mbAttr <- 'Return to <a href="https://pioucyril.github.io/mppcpro/"> MPPCPRO webpage</a>. Map data & Imagery &copy; <a href="https://www.google.com/intl/en_fr/help/legalnotices_maps/">Google</a> & &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Development &copy; <a href="https://locustcirad.wordpress.com/">LocustCirad</a>, Funding <a href="https://afd.fr/">AFD</a> & projects <a href="https://anrpepper.github.io/">ANR PEPPER</a>, <a href="https://accwa.isardsat.space/">RISE H2020 ACCWA</a> Supervision <a href="https://fao.org/clcpro/">CLCPRO</a>'
dfs <- read.csv(textConnection(
"Name,Lat,Long
INPV Algérie,36.723056, 3.155556
DPV Burkina Faso, 12.305000, -1.498889
Lybie, 32.887222, 13.191111
CNLAA Maroc,30.335815,-9.478916 
CNLCP Mali,12.638611, -8.000833
CNLAA Mauritanie,18.079323187108166, -15.93986147046241
CNLA Niger, 13.532500, 2.073611
ANLA Tchad, 12.128333, 15.009167
Tunisie, 36.828611, 10.184444
DPV Senegal, 14.747378807885443, -17.355923729602747"))

m=leaflet() %>% #
addTiles(urlTemplate=google,attribution = mbAttr,group="Google") %>%
addTiles(urlTemplate=googleSat,attribution = mbAttr,group="Satellite") %>%
addTiles(attribution = mbAttr,group = "OSM") %>%
addPolygons(data=clcpro,fillColor = "#ffffff",fillOpacity=0.1,group ="CLCPRO") %>%
setView(5,22,zoom=5) %>%
addCircleMarkers(data=df[df$AbsSolTrans>0,], lng = ~Longitude, lat = ~Latitude, radius =5) %>%
addLegend(pal = pal2, values = seq(50,100,by=5), title = "Probability (in %) to observe Locusts")
m=addRasterImage(m,r2, colors=pal2, opacity = 0.75,group="2017-10-01")
m=addRasterImage(m,r2b, colors=pal2, opacity = 0.75,group="2016-10-01")
m=hideGroup(m,"2017-10-01")
m = addMarkers(m, dfs$Long, dfs$Lat, label = dfs$Name,group="UNLAs")
m=addLayersControl(m,
   baseGroups = c("Google Map","Satellite","OSM"),
   overlayGroups = c("CLCPRO","2017-10-01","2016-10-01", "UNLAs"),
   options = layersControlOptions(collapsed = FALSE)
)
m=addMiniMap(m,toggleDisplay = TRUE)
m = addEasyButton(m, easyButton(icon="fa-globe", title="Reset Zoom", 
     onClick=JS("function(btn, map){ map.setView([22,5],5);}")))
m = addScaleBar(m, position = "bottomleft", options = scaleBarOptions(imperial=FALSE)) 
   
saveWidget(m, file="forecast.html")  
      