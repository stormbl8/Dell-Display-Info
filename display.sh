#!/bin/bash

# IMPI SETTINGS
IPMIUSER=root
IPMIPW=admin
IPMIHOST01=10.26.5.31 #Ip address or DNS name is sufficient
IPMIHOST02=10.26.5.32 #Ip address or DNS name is sufficient


usage()
{
    cat <<EOF
 Usage:
    sudo ./display.sh [status/start...]
 commands:
    status : will show status
    start  : will install IPMITool to the machnine
    enable : will enable manual speed control
    set50  : will set the speed to 50 percent
    set75  : will set the speed to 75 percent
    set100 : will set the speed to 100 percent


EOF
exit 1
}

status()
{
echo -e $(clear)
echo "----------------------------IDRAC Environment 01-----------------------------"
echo $(ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW sdr list full | grep "Ambient")
echo $(ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW sdr list full | grep "FAN 1")
echo $(ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW sdr list full | grep "FAN 2")
echo $(ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW sdr list full | grep "FAN 3")
echo "----------------------------IDRAC Environment 02-----------------------------"
echo $(ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW sdr list full | grep "Ambient")
echo $(ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW sdr list full | grep "FAN 1")
echo $(ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW sdr list full | grep "FAN 2")
echo $(ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW sdr list full | grep "FAN 3")

}

start()
{
    apt-get install ipmitool pv -y
    apt update -y && apt upgrade -y
}
enable()
{
    echo -e $(clear)
    ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    echo   "enabled for 01-"
    echo   "enabled for 02"
}

set50()
{
  echo -e $(clear)
  ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x32
  ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x32
}


set75()
{
  echo -e $(clear)
  ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x52
  ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x52
}



set100()
{
  echo -e $(clear)
  ipmitool -I lanplus -H $IPMIHOST01 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x64
  ipmitool -I lanplus -H $IPMIHOST02 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x64

}

[ $# -lt 1 ] && usage

CMD=$1
shift

case "${CMD}" in
status)
    status
    ;;
start)
    start
    ;;
enable)
    enable
    ;;
set50)
    set50
    ;;
set75)
    set75
    ;;
help)
    usage
    ;;
set100)
    set100
    ;;
*)
    printf "Unknown command '%s'\\n" "${CMD}"
    ;;
esac
