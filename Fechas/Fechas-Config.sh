#!/bin/bash

CambiarFecha() {

day=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 1)
month=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 2)
year=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 3)

Fecha=$(dialog --calendar "Fecha inicio" 0 0 $day $month $year 3>&1 1>&2 2>&3)
clear

day=$(echo $Fecha | cut -d "/" -f 1)
month=$(echo $Fecha | cut -d "/" -f 2)
year=$(echo $Fecha | cut -d "/" -f 3)

Fecha="$year$month$day"

}

ruta=$0
ruta=$(echo "${ruta/\/Fechas-Config.sh/}")

CambiarFecha

if [ $? -eq 0 ];then

	FechaDeHoy=$(date +"%Y%m%d")

	if [ $Fecha -gt $FechaDeHoy ]; then
		Fecha="$month/$day/$year"
		date --date="$Fecha" +"%m/%d/%y" > $ruta/Fecha1.txt
		find / -name Trigger.sh > $ruta/temporal.txt
		clear
		rutaTrigger=$(cat $ruta/temporal.txt)
		rm $ruta/temporal.txt	
		crontab -r
		echo "* * $day $month * bash $rutaTrigger" >> /var/spool/cron/crontabs/root
		A=$(date --file=$ruta/Fecha1.txt +%x)
		dialog --infobox "Próxima ejecucion: $A" 0 0
		sleep 2
	else
		dialog --msgbox "Debes introducir una fecha válida" 0 0	
	fi
fi


