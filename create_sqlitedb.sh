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
#   Create sqlitedb file from geotiff
#   (to be able to visualize in osmand)
#
#--------------------------------------------------------


# Full path to input geotiff image to convert
img=$1
# Absolute directory for output sqlitedb file
dirout=$2
# Absolute directory for temporary files
dirtmp=/data/elfernandez/tmp
# Full path to mbtiles2osmand script
# (download and install from https://github.com/tarwirdur/mbtiles2osmand)
mb2osmand_exe=/home/elfernandez/ConvertionTiffs/mbtiles2osmand/mbtiles2osmand.py

# Temporary files
imagename=`basename $img`
img_3857=$dirtmp/${imagename/.tif/_3857.tif}
img_mbtile=${img_3857/.tif/.mbtiles}
img_sqlite=${img_3857/.tif/.sqlite}
img_sqlite_for_phone=$dirout/${imagename/.tif/.sqlitedb}

# Convert from EPSG:4326 to EPSG:3857 (projection used in osmand)
gdalwarp -s_srs epsg:4326 -t_srs epsg:3857 $img $img_3857

# Convert from geotiff to mtiles
gdal_translate -co "RESAMPLING=NEAREST" -co "ZOOM_LEVEL_STRATEGY=LOWER" -tr 100 100 $img_3857 $img_mbtile

# Add zoom levels
gdaladdo -r nearest $img_mbtile 2 4 8 16

# Convert from mbtiles to sqlite
python $mb2osmand_exe -f $img_mbtile $img_sqlite

# Somehow, file extension must be sqlitedb for OSMAND
mv $img_sqlite $img_sqlite_for_phone

