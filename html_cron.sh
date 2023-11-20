#!/bin/bash
set -x

#--------------------------------------------------------
#
#   Script to launch creation of html file in cron
#
#   Will be launched on last day of previous decade
#   ie on a 10, 20 or last day of a month
#   Only valid in that case !
#
#--------------------------------------------------------

flagdir=/data/Production/Flags
logdir=/data/Production/Logs
scriptdir=/home/elfernandez/Production/mppcpro

# Guess which decade the html file creation if for,
# depending on current day
yyyymm=$(date +%Y%m)
day=$(date +%d)
if [ $day -eq 10 ]; then
  decade="${yyyymm}11"
elif [ $day -eq 20 ]; then
  decade="${yyyymm}21"
else
  decade=$(date -d "${yyyymm}${day} + 1 day" +%Y%m%d)
fi

which R

# Check if html already done
html_flag_ok=$flagdir/${decade:0:4}/${decade:4:2}/html_${decade}_OK
[[ -e $html_flag_ok ]] && echo "$(date) - Html already created and available for ${decade}" && exit 1

# Check that forecast has run correctly
# Not strictly necessary as we could rely on the R code to fail if necessary input data not available
forecast_flag_ok=$flagdir/${decade:0:4}/${decade:4:2}/forecast_${decade}_OK
[[ ! -e $forecast_flag_ok ]] && echo "$(date) - Forecast data not available - Exit" && exit 1

# Necessary for R because of relative paths allover ...
cd $scriptdir

# Launch R code
R CMD BATCH --vanilla forecasts.R
[[ ! $? -eq 0 ]] && echo "$(date) - Creation of html failed - Exit" && exit 1

echo "Creation of html successful"
# Add Rout file to logs
mv "$scriptdir/forecasts.Rout" "$logdir/html_Rout_${decade}.txt"
touch $html_flag_ok

