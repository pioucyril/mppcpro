#------------------------------------------------------------------------
#
#  This file is part of      MPPCPRO
#
#  Model de Prevision de Presence du Criquet Pelerin en Region Occidentale
#  
#     Copyright (C) CIRAD - FAO (CLCPRO) 2021 - 2024
#  
#  Developped by Lucile Marescot, Elodie Fernandez and Cyril Piou
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------

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