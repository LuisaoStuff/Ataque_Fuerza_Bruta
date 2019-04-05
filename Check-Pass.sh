#!/bin/bash

if [ "$USER" != "root" ]; then
	dialog --infobox "Debes tener permisos de superusuario" 0 0
	sleep 1.5
	clear
	exit
fi

dialog --yesno "¿Deseas comprobar la fortaleza de las contraseñas?" 0 0

if [ $? -eq 1 ];then
	clear
	exit
fi

ruta=$0
ruta=$(echo "${ruta/\/Check-Pass.sh/}")

Comando=$(cat $ruta/Parametros/Comando)
Diccionario=$(cat $ruta/Parametros/Diccionario)

echo "Se usará el paquete $Comando, y el diccionario $Diccionario"

echo "Ejecutado el día $(date)" >> ~/Historial.txt
echo "Nueva configuracion" >> ~/Historial.txt
echo "$(cat /var/spool/cron/crontabs/root | tail -1)" >> ~/Historial.txt
echo "#######################################################" >> ~/Historial.txt

crontab -r

find / -name Check-Pass.sh > $ruta/tempor.txt
rutaCheckPass=$(cat $ruta/tempor.txt)
rm $ruta/tempor.txt
Intervalo=$(cat $ruta/Fechas/Intervalo)
echo "* * */$Intervalo* * bash $rutaCheckPass" >> /var/spool/cron/crontabs/root

FechaAntigua=$(date --file=$ruta/Fecha1.txt +"%m/%d/%y")
FechaNueva=$(date --date="$FechaAntigua+1 week" +"%m/%d/%y")
echo "La proxima auditoria será el día: $FechaNueva"
echo $FechaNueva > $ruta/Fecha1.txt

clear
