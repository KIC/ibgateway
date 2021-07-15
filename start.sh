#!/bin/bash

JTS_INI="Jts/jts.ini"
TODAY=`date +"%Y%m%d"`
DEFAULT_SSL="ndc1.ibllc.com:4000,true,$TODAY,false;zdc1.ibllc.com:4000,true,$TODAY,false"

# set trading mode
sed -i "s/tradingMode=./tradingMode=${TRADING_MODE:-p}/" $JTS_INI
# set ssl mode
sed -i "s/UseSSL=.*\$/UseSSL=${USE_SSL:-true}/" $JTS_INI
sed -i "s/SupportsSSL=.*\$/SupportsSSL=${SSL:-$DEFAULT_SSL}/" $JTS_INI

./ibgateway/ibgateway $ARGS &
if grep -q 'tradingMode=p' $JTS_INI
then
	sleep 15
	xte 'key Return'
fi
wait

