#!/bin/bash

ComprobarInstalado() {
set `whereis $1`

if [ $# -ne 1 ];then
	return 0
else
	return 1
fi
}

Pausa() {
	read -p "	Pulsa enter para continuar" X
}

	ruta=$0
	ruta=$(echo "${ruta/CommandMenu.sh/}")

	typeset -A Menu
	find $loc -name "Comando"
	Comando=$(cat "$ruta../Parametros/Comando" | sed q2)
	
	exec 3< $ruta./ListaComandos.txt	
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

	Opcion=$(dialog --backtitle "Configuracion" \
	--radiolist "Selecciona un comando" 0 0 $Contador \
	$radiolist 3>&1 1>&2 2>&3)
	if [ $? -eq 0 ]; then
		echo "${Menu[$Opcion]}" > $ruta../Parametros/Comando
		dialog --infobox "Seleccionaste: ${Menu[$Opcion]}" 0 0
		sleep 2
	fi
