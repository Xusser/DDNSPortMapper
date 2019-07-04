#!/bin/bash

# DDNSPortMapper.sh localport remoteaddr remoteport
LANG=zh_CN.UTF-8

if [ ! -n "$1" ] ;
then
    echo "未填写本地端口!"
    exit 1
fi

if [ ! -n "$2" ] ;
then
    echo "未填写远端域名!"
    exit 1
fi

if [ ! -n "$3" ] ;
then
    echo "未填写远端端口!"
    exit 1
fi

echo '======================'
echo '本地端口: '$1
echo '远端域名: '$2
echo '远端端口: '$3
echo '======================'

ORIREMOTEIP=""
KILLCMD=""

RED='\033[0;31m' # Red Color
BLUE='\033[0;34m' # Blue Color
NC='\033[0m' # No Color

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

exitSignal() {
    echo '$RED 检测到CTRL C $NC'
    echo $KILLCMD
    echo $KILLCMD | sh
    exit 1
}

trap 'exitSignal' INT

while :
do
    NEWREMOTEIP="$(dig +short $2 @1.1.1.1)"
    echo '原IP: '$ORIREMOTEIP
    if valid_ip $NEWREMOTEIP; then
            echo '新IP: '$NEWREMOTEIP
        else
            echo '新IP: '$NEWREMOTEIP
            echo '格式不正确，跳过以等待下一次循环'
			continue
    fi
	echo '======================'
    if [ "$ORIREMOTEIP" != "$NEWREMOTEIP" ];then
        echo 'IP已变更,尝试重定向'
        NEWCMD="nohup tinyportmapper -l0.0.0.0:$1 -r$NEWREMOTEIP:$3 -t -u > /dev/null 2>&1 &"
        KILLCMD="ps -ef | grep tinyportmapper | grep '$1' | grep '$3' | awk '{print \$2}' | xargs kill -9"
        echo $KILLCMD
        echo $NEWCMD
        echo $KILLCMD | sh
        echo $NEWCMD | sh
        ORIREMOTEIP=$NEWREMOTEIP
    fi
    echo 'sleep 5mins'
    sleep 300
    echo '======================'
done
