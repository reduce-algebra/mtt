#!/bin/sh

## MTT units script - wrapper for the units program.

# Copyright (C) 2000 by Peter J. Gawthrop

# Arguments
sys=$1
port=$2
domain=$3
effort=$4
flow=$5

case ${domain} in
    electrical)
	base_effort=volt
	base_flow=amp
	;;
    translational)
	base_effort='newton'
	base_flow='m/s'
	;;
    rotational)
	base_effort='newton*m'
	base_flow='radian/s'
	;;
    fluid)
	base_effort='Pa'
	base_flow='m^3/s'
	;;
    thermal)
	base_effort='degK'
	base_flow='watt/degK'

	;;
    *)
	echo ${sys} ${port} DOMAIN_ERROR invalid domain ${domain}
	exit 1
esac

get_unit()
{
  if [ "$2" == "none" ]; then
      echo 1
  else
      factor=`units $2 $3 | head -1 | sed 's/\*//'`
      if [ `echo $factor | wc -w` = "1" ]; then
	  echo $factor
      else
	  echo $1_UNIT_ERROR unit $2 not compatible with domain ${domain}
      fi
  fi
}
## Check effort and flow for comptability + find factor
effort_factor=`get_unit EFFORT $effort $base_effort`
flow_factor=`get_unit FLOW $flow $base_flow`

echo ${sys} ${port} ${effort_factor} ${flow_factor}