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

Intervalo=$(cat $ruta/Intervalo)

Intervalo=$(dialog $1 --rangebox "Selecciona un nuevo intervalo (días)" \
	0 0 2 15 $Intervalo 3>&1 1>&2 2>&3)

if [[ -n "$Intervalo" ]];then
	echo "$Intervalo" > $ruta/Intervalo
	dialog --infobox "Se ejecutará cada $Intervalo días" 0 0
	sleep 1
	clear
	cat /var/spool/cron/crontabs/root | tail -1 | cut -d " " -f 3 | grep -o "/"
	if [ $? -eq 0 ]; then
		crontab -r
		dir="$dir/Check-Pass.sh"
		echo "* * */$Intervalo* * bash $dir" >> /var/spool/cron/crontabs/root
	fi
	echo "0"  > $ruta/../salida.txt && clear && exit
else
	echo "255"  > $ruta/../salida.txt && clear && exit
fi

