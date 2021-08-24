#!/usr/local/bin/bash

####################################
### Update the variable below ###
####################################
HOST=darna
DATABASE=speedtest
USER=speedtest

####################################
### STOP editing below this line ###
####################################
#while read -r line
#do
#  if [[ $line != "Retrieving"* ]]; then
#    tmp="${line%%)*}"
#    SERVER_ID=${tmp%)*}
#    break
#    fi
#done < <(speedtest-cli --list)

while read -r line
do
  if [[ $line == "Testing from"* ]]; then
    tmp=${line#*from }
    ISP=${tmp%(*}
    tmp=${line#*(}
    IP_ADDRESS=${tmp%)*}
  elif [[ $line == "Hosted by"* ]]; then
    tmp=${line#*by }
    SERVER=${tmp%(*}
    tmp=${line#*(}
    SERVER_LOCATION=${tmp%)*}
    tmp=${line#*[}
    SERVER_DISTANCE_KM=${tmp% km*}
    tmp=${line#*: }
    SERVER_PING=${tmp% ms*}
  elif [[ $line == "Download:"* ]]; then
    tmp=${line#*: }
    DOWNLOAD_MBPS=${tmp% Mb*}
  elif [[ $line == "Upload:"* ]]; then
    tmp=${line#*: }
    UPLOAD_MBPS=${tmp% Mb*}
  fi
done < <(speedtest-cli)

echo "ISP=$ISP"
echo "IP_ADDRESS=$IP_ADDRESS"
echo "SERVER=$SERVER"
echo "SERVER_LOCATION=$SERVER_LOCATION"
echo "SERVER_DISTANCE_KM=$SERVER_DISTANCE_KM"
echo "SERVER_PING=$SERVER_PING"
echo "DOWNLOAD_MBPS=$DOWNLOAD_MBPS"
echo "UPLOAD_MBPS=$UPLOAD_MBPS"

psql \
  -h $HOST \
  -U $USER \
  -w \
  -c \
  "select speedtest('$ISP', '$IP_ADDRESS', '$SERVER', '$SERVER_LOCATION', $SERVER_DISTANCE_KM, $SERVER_PING, $DOWNLOAD_MBPS, $UPLOAD_MBPS)" \
  $DATABASE
