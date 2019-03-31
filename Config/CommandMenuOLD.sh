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

Limpiar() {
	clear
	for i in $(seq 0 $1) ; do
		echo ""
	done
}

while true; do
	
	ruta=$0
	ruta=$(echo "${ruta/CommandMenu.sh/}")

	typeset -A Menu
	find $loc -name "Comando"
	Comando=$(cat "$ruta../Parametros/Comando" | sed q2)
	
	exec 3< $ruta./ListaComandos.txt	
	Limpiar 8
	echo "		El comando seleccionado es: $Comando"
	echo "		Selecciona uno de la siguiente lista:"
	Contador=1

	while read linea <&3; do
		if [ "$Comando" = "$linea" ];then
			Menu[0]="Salir"
		else
			Menu[$Contador]=$linea
			Contador=$(($Contador+1))
		fi
	done

	echo "		0- ${Menu[0]}"
	for i in $(seq 1 $(($Contador-1))); do
	typeset -i var	
	var=$(ComprobarInstalado ${Menu[$i]})

		if [ $var -eq 1 ];then
			echo "		$i- ${Menu[$i]} << no instalado"
		else
			echo "		$i- ${Menu[$i]} << instalado"
		fi
	done
	read -p "		Opcion: " Opcion
	if [ "$Opcion" = "0" ];then
		exit
	elif [ $Opcion -gt 0 -a $Opcion -le ${#Menu[@]} ]; then
		echo "${Menu[$Opcion]}" > $ruta../Parametros/Comando
	else
		echo "Debes introducir una opcion válida"
		Pausa
	fi
done
