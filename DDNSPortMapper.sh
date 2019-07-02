#!/bin/sh
# DDNSPortMapper.sh localport remoteaddr remoteport
if [ ! -n "$1" ] ;
then
    echo "local port is a MUST!"
    exit 1
fi

if [ ! -n "$2" ] ;
then
    echo "remote domain is a MUST!"
    exit 1
fi

if [ ! -n "$3" ] ;
then
    echo "remote port is a MUST!"
    exit 1
fi

echo '======================'
echo 'local port: '$1
echo 'remote domain: '$2
echo 'remote port: '$3
echo '======================'

ORIREMOTEIP=""
KILLCMD=""

exitSignal() {
	echo 'CATCH SIGNINT'
	echo $KILLCMD
	echo $KILLCMD | sh
	exit 1
}

trap 'exitSignal' INT

while :
do
	NEWREMOTEIP="$(dig +short $2 @1.1.1.1)"
	echo 'origin remote ip: '$ORIREMOTEIP
	echo 'new remote ip: '$NEWREMOTEIP
	echo '======================'
	if [ "$ORIREMOTEIP" != "$NEWREMOTEIP" ];then
		echo 'ip changed!'
		NEWCMD="nohup tinyportmapper -l0.0.0.0:$1 -r$NEWREMOTEIP:$3 -t -u > /dev/null 2>&1 &"
		KILLCMD="ps -ef | grep tinyportmapper | grep '$1' | grep '$3' | awk '{print \$2}' | xargs kill -9"
		echo $KILLCMD
		echo $NEWCMD
		echo $KILLCMD | sh
		echo $NEWCMD | sh
		ORIREMOTEIP=$NEWREMOTEIP
	fi
	echo 'sleep'
	sleep 300
	echo '======================'
done
