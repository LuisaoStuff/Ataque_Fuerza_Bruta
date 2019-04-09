#!/bin/bash

CambiarFecha() {

day=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 1)
month=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 2)
year=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 3)

Fecha=$(dialog --calendar "Fecha inicio" 0 0 $day $month $year 3>&1 1>&2 2>&3)
clear
if [ $Fecha != null ]; then

	day=$(echo $Fecha | cut -d "/" -f 1)
	month=$(echo $Fecha | cut -d "/" -f 2)
	year=$(echo $Fecha | cut -d "/" -f 3)

	Fecha="$year$month$day"
else 
	Fecha="error"
fi
}

ruta=`dirname $0`;

SCRIPT=$(readlink -f $0)
dir=`dirname $SCRIPT`
dir=`dirname $dir`

CambiarFecha

if [ "$Fecha" != "error" ];then

	FechaMinima=$(date --date="+1 week" +"%Y%m%d")

	while [ $Fecha -lt $FechaMinima ]; do
		F=$(date --date="+1 week" +%x)
		dialog --msgbox "Debes introducir una fecha, que como mínimo falte aún una semana (Como mínimo el $F)" 0 0
		CambiarFecha
	done
	Fecha="$month/$day/$year"
	date --date="$Fecha" +"%m/%d/%y" > $ruta/Fecha1.txt
	crontab -r
	dir="$dir/Fechas/Trigger.sh"
	echo "* * $day $month * bash $dir" >> /var/spool/cron/crontabs/root
	A=$(date --file=$ruta/Fecha1.txt +%x)
	dialog --infobox "Próxima ejecucion: $A" 0 0
	sleep 1
	echo "0"  > $ruta/../salida.txt && clear && exit
else
	echo "255"  > $ruta/../salida.txt && clear && exit
fi


