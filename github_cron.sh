#!/bin/bash
set -x

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
#   Script to add files to github:
#      - forecast.html
#      - forecast maps as tif
#
#   Will be launched on last day of previous yyyymmdd
#   ie on a 10, 20 or last day of a month
#   Only valid in that case !
#
#--------------------------------------------------------

# Command line arguments (for easy launch in cron)
yyyymmdd=$1

ana_env=~/miniforge3/bin/activate
scriptdir=/home/elfernandez/Production/mppcpro
dirflag=/data/Production/Flags

# Check if push already done
git_flag_ok=$dirflag/${yyyymmdd:0:4}/${yyyymmdd:4:2}/git_${yyyymmdd}_OK
[[ -e $git_flag_ok ]] && echo "$(date) - Git push already done for yyyymmdd ${yyyymmdd}" && exit 1

# Check that html creation has run properly
html_flag_ok=$dirflag/${yyyymmdd:0:4}/${yyyymmdd:4:2}/html_${yyyymmdd}_OK
[[ ! -e $html_flag_ok ]] && echo "$(date) - Html file not available yet - Exit" && exit 1

# Git workflow
cd $scriptdir

# Repo must be up-to-date to be able to push later on
git pull || exit 1

# Add html page for current decade
git add forecast.html || exit 1
# Add current html page to archive
git add forecasts/*.html || exit 1
# Add images that have been created in the last 24 hours
list_images=$(find img -type f -mtime -1 -name '*.tif')
for image in $list_images; do
  git add $image || exit 1
done

# Commit and push
git commit -m "Update forecast and images for ${yyyymmdd}" || exit 1
git push || exit 1

touch $git_flag_ok
echo "Git push successful"

