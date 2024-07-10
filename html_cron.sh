#!/bin/bash
#set -x

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

#--------------------------------------------------------
#
#   Script to launch creation of html file in cron
#
#   Will be launched on last day of previous decade
#   ie on a 10, 20 or last day of a month
#   Only valid in that case !
#
#--------------------------------------------------------

# Command line arguments (for easy launch in cron)
yyyymmdd=$1

ana_env=~/software/miniforge3/bin/activate
scriptdir=/home/elfernandez/Production/mppcpro
fcstdir=/data/Production/Forecasts/MODIS_MODIS11
dirflag=/data/Production/Flags
roi=/data/Production/StaticData/CLCPRO.RData

# Activate conda environment
source $ana_env production

which R

# Check if html already done
html_flag_ok=$dirflag/${yyyymmdd:0:4}/${yyyymmdd:4:2}/html_${yyyymmdd}_OK
[[ -e $html_flag_ok ]] && echo "$(date) - Html already created and available for ${yyyymmdd}" && exit 1

# Check that forecast has run correctly
# Not strictly necessary as we could rely on the R code to fail if necessary input data not available
forecast_flag_ok=$dirflag/${yyyymmdd:0:4}/${yyyymmdd:4:2}/forecast_${yyyymmdd}_OK
[[ ! -e $forecast_flag_ok ]] && echo "$(date) - Forecast data not available - Exit" && exit 1

# Launch R code
# need to add for now because of subfunction in R in other file
cd ${scriptdir}
Rscript --vanilla ${scriptdir}/forecasts.R -d "${yyyymmdd:0:4}-${yyyymmdd:4:2}-${yyyymmdd:6:2}" -o ${scriptdir} -f ${fcstdir} -c ${roi}
[[ ! $? -eq 0 ]] && echo "$(date) - Creation of html failed - Exit" && exit 1
cp ${scriptdir}/forecast.html ${scriptdir}/forecasts/forecast_${yyyymmdd}.html

echo "Creation of html successful"
touch $html_flag_ok

