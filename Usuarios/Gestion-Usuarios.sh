#!/bin/bash

ruta=$0
ruta=$(echo "${ruta/Gestion-Usuarios.sh/}")

cat /etc/passwd | cut -d ":" -f 1 > $ruta/temp-users.txt
exec 5< $ruta/temp-users.txt
Contador=1
checklist=""
typeset -i Indicador

while read linea <&5; do

	Indicador=1
	exec 4< $ruta/Lista-Usuarios.txt
	C=1
	typeset -A ListaFinal
	while read usuario <&4; do
		ListaFinal[$C]=$linea
		C=$(($C+1))
		if [ "$usuario" = "$linea" ]; then
			Indicador=0
		fi
	done

	if [ $Indicador -eq 0 ]; then 
		checklist="$checklist $Contador $linea on "
	else
		checklist="$checklist $Contador $linea off "
	fi
	Usuarios[$Contador]="$linea"
	Contador=$(($Contador+1))
done

Lista=$(dialog --backtitle "Configuracion" \
	--separate-output \
	--checklist "Selecciona un comando" 0 0 $Contador \
	$checklist 3>&1 1>&2 2>&3)


Contador=1
for i in $Lista; do
	if [ $Contador -eq 1 ]; then
		echo "${Usuarios[$i]}" > $ruta/Lista-Usuarios.txt
	else
		echo "${Usuarios[$i]}" >> $ruta/Lista-Usuarios.txt
	fi
	Contador=$(($Contador+1))
done

dialog --backtitle "Configuración" \
--title "Seleccionados:" \
--keep-window --exit-label "Continuar" \
--textbox $ruta/Lista-Usuarios.txt 0 0

rm $ruta/temp-users.txt
clear
