#!/bin/bash

ComprobarInstalado() {
set `whereis $1`

if [ $# -ne 1 ];then
	return 0
else
	return 1
fi
}


ruta=`dirname $0`


typeset -A Menu
Comando=$(cat "$ruta/../Parametros/Comando" | sed q2)

exec 3< $ruta/ListaComandos.txt	
Contador=1
radiolist=""
while read linea <&3; do
	if [ "$Comando" = "$linea" ]; then 
		radiolist="$radiolist $Contador $Comando on "
		Contador=$(($Contador+1))
	else
		radiolist="$radiolist $Contador $linea off "
		Menu[$Contador]="$linea"
		Contador=$(($Contador+1))
	fi
done

Opcion=$(dialog $1 --backtitle "Configuracion" \
--radiolist "Selecciona un comando" 0 0 $Contador \
$radiolist 3>&1 1>&2 2>&3)
if [[ -n $Opcion ]]; then
	echo "${Menu[$Opcion]}" > $ruta../Parametros/Comando
	dialog --infobox "Seleccionaste: ${Menu[$Opcion]}" 0 0
	sleep 2
	echo "0"  > $ruta/../salida.txt && clear && exit
else
	echo "255"  > $ruta/../salida.txt && clear && exit
fi
