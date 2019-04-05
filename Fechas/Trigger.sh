#!/bin/bash

if [ "$USER" != "root" ]; then
	dialog --infobox "Debes tener permisos de superusuario" 0 0
	sleep 1.5
	clear
	exit
fi

ruta=$0
ruta=$(echo "${ruta/\/Trigger.sh/}")

bash $ruta/../Check-Pass.sh

Intervalo=$(cat $ruta/Intervalo)

crontab -r

find / -name Check-Pass.sh > $ruta/tempor.txt
rutaCheckPass=$(cat $ruta/tempor.txt)
rm $ruta/tempor.txt

echo "* * */$Intervalo* * bash $rutaCheckPass" >> /var/spool/cron/crontabs/root

echo "Ejecutado el día $(date)" >> ~/Historial.txt
