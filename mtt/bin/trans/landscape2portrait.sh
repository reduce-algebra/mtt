#!/bin/sh

     ###################################### 
     ##### Model Transformation Tools #####
     ######################################

# Bourne shell script: landscape2portrait.sh
# Converts one or more figure files from landscape mode to portrait mode

# ###############################################################
# ## Version control history
# ###############################################################
# ## $Id$
# ## $Log$
# ###############################################################

# Copyright (C) 2001 by Peter J. Gawthrop

figfiles=$*

for figfile in $figfiles; do
    count=`grep -c Landscape $figfile`
    if [ "$count" = "1" ]; then
       echo Converting $figfile
       mv $figfile ${figfile}.bak
       sed 's/Landscape/Portrait/'< ${figfile}.bak > $figfile
    fi
done