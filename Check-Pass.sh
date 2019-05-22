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

ruta=`dirname $0`;

$ruta/Usuarios/Auditoria-Contraseñas.sh

Comando=$(cat $ruta/Parametros/Comando)
Diccionario=$(cat $ruta/Parametros/Diccionario)

echo "Se usará el paquete $Comando, y el diccionario $Diccionario"

echo "Ejecutado el día $(date)" >> ~/.Historial.txt
echo "Nueva configuracion" >> ~/.Historial.txt
echo "$(cat /var/spool/cron/crontabs/root | tail -1)" >> ~/.Historial.txt
echo "#######################################################" >> ~/.Historial.txt

crontab -r
SCRIPT=$(readlink -f $0)
dir=`dirname $SCRIPT`
dir=`dirname $dir`
dir="$dir/Check-Pass.sh"
echo "* * */$Intervalo* * bash $dir" >> /var/spool/cron/crontabs/root

FechaAntigua=$(date --file=$ruta/Fecha1.txt +"%m/%d/%y")
FechaNueva=$(date --date="$FechaAntigua+1 week" +"%m/%d/%y")
echo "La proxima auditoria será el día: $FechaNueva"
echo $FechaNueva > $ruta/Fecha1.txt

Comando=$(cat "$ruta/Parametros/Comando" | sed q2)
Dic=$(cat $ruta/Parametros/Diccionario)

Diccionario="$ruta/Parametros/Diccionarios/$Dic"
Usuarios="$ruta/Usuarios/Auditoria.txt"


case "$Comando" in
"Hydra")
	hydra -L $Usuarios -P $Diccionario -u -o $ruta/Cuentas-Vulnerables.txt
;;
"Medusa")
	medusa -M ssh -h 127.0.0.1 -U $Usuarios -P $Diccionario -O $ruta/Cuentas-Vulnerables.txt
esac

clear
