#!/bin/bash

ProximaFecha() {

	day1=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 1)
	month1=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 2)
	year1=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 3)

	fechacomp1="$year1$month1$day1"

	day2=$(date --file=$ruta/Fecha2.txt +%x | cut -d "/" -f 1)
	month2=$(date --file=$ruta/Fecha2.txt +%x | cut -d "/" -f 2)
	year2=$(date --file=$ruta/Fecha2.txt +%x | cut -d "/" -f 3)

	fechacomp2="$year2$month2$day2"
	
	fechacutal=$(date +"%y%m%d")

	if [[ "$fechactual" < "$fechacomp1" ]]; then
		if [[ "$fechacomp1" < "$fechacomp2" ]]; then
			day=$day1
			month=$month1
			year=$year1
		fi
	else
		day=$day2
		month=$month2
		year=$year2
	fi
}

CambiarFecha() {

Fecha=$(dialog --calendar "Fecha inicio" 0 0 $day $month $year 3>&1 1>&2 2>&3)
clear


day=$(echo $Fecha | cut -d "/" -f 1)
month=$(echo $Fecha | cut -d "/" -f 2)
year=$(echo $Fecha | cut -d "/" -f 3)

Fecha="$year$month$day"

}


ruta=$0
ruta=$(echo "${ruta/Fechas-Config.sh/}")

ProximaFecha

CambiarFecha

echo $Fecha
fechacutal=$(date +"%Y%m%d")
echo $fechacutal
read X

while [[ "$Fecha" < "$fechactual" ]]; do
	CambiarFecha
done


Fecha="$month/$day/$year"

date --date="$Fecha" +"%m/%d/%y" > Fecha1.txt

date --date="$Fecha+1 week" +"%m/%d/%y" > Fecha2.txt
