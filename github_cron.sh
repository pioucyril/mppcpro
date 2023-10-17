#!/bin/bash
set -x

#--------------------------------------------------------
#
#   Script to add files to github:
#      - forecast.html
#      - forecast maps as tif
#
#   Will be launched on last day of previous decade
#   ie on a 10, 20 or last day of a month
#   Only valid in that case !
#
#--------------------------------------------------------

flagdir=/data/Production/Flags
logdir=/data/Production/Logs
scriptdir=/home/elfernandez/Production/mppcpro

# Guess which decade the push is for,
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

# Check if push already done
git_flag_ok=$flagdir/${decade:0:4}/${decade:4:2}/git_${decade}_OK
[[ -e $git_flag_ok ]] && echo "$(date) - Git push already done for decade ${decade}" && exit 1

# Check that html creation has run properly
html_flag_ok=$flagdir/${decade:0:4}/${decade:4:2}/html_${decade}_OK
[[ ! -e $html_flag_ok ]] && echo "$(date) - Html file not available yet - Exit" && exit 1

# Git workflow
cd $scriptdir

# Repo must be up-to-date to be able to push later on
git pull || exit 1

# Add html and images that have been created in the last 24 hours
git add forecast.html || exit 1
list_images=$(find img -type f -mtime -1 -name '*.tif')
for image in $list_images; do
  git add $image || exit 1
done

# Commit and push
git commit -m "Update forecast and images for decade ${decade}" || exit 1
git push || exit 1

touch $git_flag_ok
echo "Git push successful"

