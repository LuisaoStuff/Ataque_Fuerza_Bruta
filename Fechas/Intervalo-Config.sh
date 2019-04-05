#!/bin/bash

if [ "$USER" != "root" ]; then
	dialog --infobox "Debes tener permisos de superusuario" 0 0
	sleep 1.5
	clear
	exit
fi

ruta=$0
ruta=$(echo "${ruta/\/Intervalo-Config.sh/}")

Intervalo=$(cat $ruta/Intervalo)

Intervalo=$(dialog --rangebox "Selecciona un nuevo intervalo (días)" \
	0 0 2 15 $Intervalo 3>&1 1>&2 2>&3)

if [ $? -eq 0 ];then
	echo "$Intervalo" > $ruta/Intervalo
	dialog --infobox "Se ejecutará cada $Intervalo días" 0 0
	cat /var/spool/cron/crontabs/root | tail -1 | cut -d " " -f 3 | grep -o "/"
	if [ $? -eq 0 ]; then
		find / -name Check-Pass.sh > $ruta/tempor.txt
		rutaCheckPass=$(cat $ruta/tempor.txt)
		rm $ruta/tempor.txt

		echo "* * */$Intervalo* * bash $rutaCheckPass" >> /var/spool/cron/crontabs/root
	fi
	sleep 1.5
fi


