##########################################################################
#  MPPCPRO file example                                                  #
#  to get the outputs of the model into an HTML using leaflet            #
#                                                                        #
#  Cyril Piou, Lucile Marescot, Elodie Fernandez                         # 
#                  November 2023                                         # 
##########################################################################

library(htmlwidgets)
library(leafem)
library(leaflet)
library(leaflet.extras)
library(htmltools)
library(raster)
library(terra) #to be able to save with color table
library(lubridate)
library(viridis)
source("function.R") # decade.toCome()
library(optparse)
source("keys.R") # from leafem package - no change
source("mousecoords.R") # from leafem package - local modifications

gregariousmodel=FALSE
fieldData=FALSE

option_list = list(
    make_option(c("-d", "--forecast_date"), type="character", default="0000-00-00",
              help="Forecast date (format YYYY-MM-DD) [default= %default]", metavar="character"),
    make_option(c("-f", "--forecast_dir"), type="character", default="/data/Production/Forecasts",
              help="forecasts directory [default= %default]", metavar="character"),
    make_option(c("-c", "--clcpro_file"), type="character", default="/data/Production/StaticData/CLCPRO.RData",
              help="R object containing clcpro area description [default= %default]", metavar="character"),
    make_option(c("-o", "--output_dir"), type="character", default=".",
              help="output directory [default= %default]", metavar="character"),
    make_option(c("-b", "--before"), type="integer", default=3,
              help="How many decades before [default= %default]", metavar="character"),
    make_option(c("-a", "--after"), type="integer", default=2,
              help="How many decades after [default= %default]", metavar="character")
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

howmanydecadesBef=opt$before
howmanydecadesAft=opt$after
path_clcpro=opt$clcpro_file
path_forecast=opt$forecast_dir
startdate=opt$forecast_date
dir.create(file.path(opt$output_dir, 'img'))
# If no date specified, use the first date of the next decade
if (startdate == '0000-00-00'){
    today=Sys.Date()
    startdate = decade.toCome(today)
}

load(path_clcpro)

### Prepare the names of the files/dates to use in the interface:
strc=strsplit(as.character(startdate),"-")
year=strc[[1]][1]
month=strc[[1]][2]
day=strc[[1]][3]

namesall = as.character(startdate)
if(gregariousmodel){
  namesallgreg=paste(startdate,"Transiens")
}
if(howmanydecadesAft>=1){
  for(i in 1:howmanydecadesAft){
    day=as.numeric(day)+10
    if(day>21){
      day="01"
      month=as.numeric(month)+1
      if(month>12){
        month="01"
        year=as.numeric(year)+1
      }
    }
    newdate=as.character(as.Date(paste(year,month,day,sep="-"), "%Y-%m-%d"))
    namesall=c(namesall,newdate)
    if(gregariousmodel){
      namesallgreg=c(namesallgreg,paste(newdate,"Transiens"))
    }
  }
}
# past decades
year=strc[[1]][1]
month=strc[[1]][2]
day=strc[[1]][3]
if(howmanydecadesBef>=1){
  for(i in 1:howmanydecadesBef){
    day=as.numeric(day)-10
    if(day<0){
      day="21"
      month=as.numeric(month)-1
      if(month<=0){
        month="12"
        year=as.numeric(year)-1
      }
    }
    newdate=as.character(as.Date(paste(year,month,day,sep="-"), "%Y-%m-%d"))
    namesall=c(newdate,namesall)
    if(gregariousmodel){
      namesallgreg=c(paste(newdate,"Transiens"),namesallgreg)
    }
  }
}

print(namesall)

### prepare leaflet infos
palPres <- leaflet::colorBin(palette = viridis(5),
                          bins = 5,
                          domain = seq(50,100,by=10),
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
# Define HTML for the infobox
info.box <- HTML(paste0(
  HTML(
    '<div class="modal fade" id="infobox" role="dialog"><div class="modal-dialog"><!-- Modal content--><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button>'
  ),
  # Body
  HTML('<h4>Html pages for previous dates are available <a href="https://github.com/pioucyril/mppcpro/tree/main/forecasts">here</a></h4>
        <h4>Geotiff images are available <a href="https://github.com/pioucyril/mppcpro/tree/main/img">here</a></h4>'),
  # Closing divs
  HTML('</div><div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div></div>')
))

m=leaflet() %>% #
addTiles(urlTemplate=google,attribution = mbAttr,group="Google") %>%
addTiles(urlTemplate=googleSat,attribution = mbAttr,group="Satellite") %>%
addTiles(attribution = mbAttr,group = "OSM") %>%
addPolygons(data=clcpro,fillColor = "#ffffff",fillOpacity=0.1,group ="CLCPRO") %>%
# To show mouse coordinates on top of screen
addMouseCoordinates() %>%
# To show mouse coordinates on a pop-up when one clicks on map
addMouseCoordinatesPopUp() %>%
setView(5,22,zoom=5) %>%
addLegend(pal = palPres, values = seq(50,100,by=10), title = "Probability (in %) to observe Locusts") %>%
# To add button with links to archived html and tif images
addBootstrapDependency() %>%
addEasyButton(easyButton(icon="fa-info-circle", title="Archived data", onClick = JS("function(btn, map){ $('#infobox').modal('show'); }"))) %>%
htmlwidgets::appendContent(info.box)
if(gregariousmodel){
  m = addLegend(m, pal = palGreg, values = seq(50,100,by=10), title = "Probability (in %) to observe Transiens")
}

### Add rasters of forecast
i = 1
modV = 1
for(name in namesall){
  short=paste0(strsplit(name,"-")[[1]],collapse="")
  modV=ifelse(i<=howmanydecadesBef+1,modV,modV + 1)
  r1 <- rast(paste0(path_forecast,"/PresAbs/",short,"_F",modV,"/Ensemble/meanpred_",short,"_F",modV,".tif"))
  rtrans=round(r1*100)
  rtrans=rtrans*(r1>=0.5)
  values(rtrans)[values(rtrans)==0]<-NA
  
  if(gregariousmodel){
    r1g <- rast(paste0(path_forecast,"/Greg/",short,"_F",modV,"/Ensemble/meanpred_",short,"_F",modV,".tif"))
    rtrg=round(r1g*100)*(r1>=0.5)*(r1g>=0.5)
    values(rtrg)[values(rtrg)==0]<-NA
    writeRaster(rtrg,paste0(opt$output_dir,"/img/",short,"g.tif"),overwrite=T)
    r2g <- raster(paste0(opt$output_dir,"/img/",short,"g.tif"))
    m=addRasterImage(m,r2g, colors=palGreg, opacity = 0.75,group=namesallgreg[i],method='ngb')
  }
  # Add RGB colors to geotiff
  coltab(rtrans) <- c(rep(NA,50),rep(viridis(5),each=10),viridis(5)[5],rep(NA,155))
  writeRaster(rtrans,paste0(opt$output_dir,"/img/",short,".tif"),overwrite=T)
  r2 <- raster(paste0(opt$output_dir,"/img/",short,".tif"))
  m=addRasterImage(m,r2, colors=palPres, opacity = 0.75,group=name,method='ngb')
  i = i + 1
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

# Add markers and cosmetics
m = addMarkers(m, dfs$Long, dfs$Lat, label = dfs$Name,group="UNLAs")
overlayg = c("CLCPRO",namesall,ifelse(gregariousmodel,c(namesall,namesallgreg),namesall),"UNLAs")
if(fieldData){overlayg=c(overlayg,"realData")}
m=addLayersControl(m,
   baseGroups = c("Google Map","Satellite","OSM"),
   overlayGroups = overlayg,
   options = layersControlOptions(collapsed = FALSE)
)

# Show only forecast map for current decade
for (name in namesall){
  m <- hideGroup(m, name)
}
m <- showGroup(m, startdate)
if(gregariousmodel){
  for (name in namesallgreg){
    m <- hideGroup(m, name)
  }
  m <- showGroup(m, startdate)
}

m=addMiniMap(m,toggleDisplay = TRUE)
m = addEasyButton(m, easyButton(icon="fa-globe", title="Reset Zoom",
     onClick=JS("function(btn, map){ map.setView([22,5],5);}"), id='toto'))
m = addScaleBar(m, position = "bottomleft", options = scaleBarOptions(imperial=FALSE))

#save leaflet into html
saveWidget(m, file=paste0(opt$output_dir,"/forecast.html"))

quit(status = 0)
