#!/bin/bash
#set -x

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

ana_env=~/miniforge3/bin/activate
scriptdir=/home/elfernandez/Production/mppcpro
dirflag=/data/Production/Flags

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
Rscript --vanilla ${scriptdir}/forecasts.R -d "${yyyymmdd:0:4}-${yyyymmdd:4:2}-${yyyymmdd:6:2}" -o ${scriptdir}
[[ ! $? -eq 0 ]] && echo "$(date) - Creation of html failed - Exit" && exit 1

echo "Creation of html successful"
touch $html_flag_ok

