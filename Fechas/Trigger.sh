#!/bin/bash

if [ "$USER" != "root" ]; then
	dialog --infobox "Debes tener permisos de superusuario" 0 0
	sleep 1.5
	clear
	exit
fi

ruta=`dirname $0`

SCRIPT=$(readlink -f $0)
dir=`dirname $SCRIPT`
dir=`dirname $dir`

bash $ruta/../Check-Pass.sh

Intervalo=$(cat $ruta/Intervalo)

crontab -r
dir="$dir/Check-Pass.sh"
echo "* * */$Intervalo* * bash $dir" >> /var/spool/cron/crontabs/root

