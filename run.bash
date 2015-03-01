#!/bin/bash

# # Absolute path to this script. /home/user/bin/foo.sh
# SCRIPT=$(readlink -f $0)
# # Absolute path this script is in. /home/user/bin
# SCRIPTPATH=`dirname $SCRIPT`

docker start smaccmpilot

if [ "$?" -ne "0" ]
then
  docker run --name="smaccmpilot" -t -i oleg/smaccmpilot $1
fi
