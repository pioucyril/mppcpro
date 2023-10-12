########################################
# Functions for decad computation      #
#                                      #
#  Cyril Piou                          # 
#                 October 2023         # 
########################################

decade.toCome=function(adate){
  res=adate + 1
  mo=as.numeric(format(adate,"%m"))
  day=as.numeric(format(adate,"%d"))
  yr=as.numeric(format(adate,"%Y"))
  tmpT=as.Date(paste(yr,mo,c(1,11,21),sep="-"))
  if(mo<12){
    tmpT=c(tmpT,as.Date(paste(yr,mo+1,c(1,11,21),sep="-")))
  }else{
    tmpT=c(tmpT,as.Date(paste(yr+1,1,c(1,11,21),sep="-")))
  }
  if(res %in% tmpT){
    return(res)
  }else{
    lim.inf=max(which(tmpT<=(adate +1)))
    return(tmpT[lim.inf])
  }
}