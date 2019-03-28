#!/bin/bash

Limpiar() {
	clear
	for i in $(seq 0 $1) ; do
		echo ""
	done
}

Pausa() {
	read -p "	Pulsa enter para continuar" X
}

if [ "$USER" = "root" ]; then	
	clear
else
	echo ""	
	echo "	Necesitas permisos de root"
	echo ""	
	exit
fi

Interv=$(cat ./Parametros/Intervalo)
Dicc=$(cat ./Parametros/Diccionario)
Fecha=$(cat ./Parametros/Ultima-Ejecucion)

Limpiar 7
echo '	Este es el script de configuración de "Check-Pass" \n'
echo '		Parámetros actuales:'
echo "		- Intervalo: 		$Interv"
echo "		- Diccionario:		$Dicc"
echo "		- Última vez ejecutado:	$Fecha \n"
read -p "	¿Deseas modificar algún parámetro? (S/N) " D

if [ "$D" = "S" -o "$D" = "s" ]; then	
	while true; do

		Limpiar 8
		echo '	Seleccione a continuación una de las siguientes opciones:'
		echo '\n		1- Ejecutar el "Check-Pass" ahora'
		echo '		2- Seleccionar/Crear diccionario'
		echo '		3- Modificar intervalo de tiempo'
		echo '		0- Salir\n'
		read -p "	Opcion: " Opcion

		case "$Opcion"	in
		"0")
		break
		;;	
		"1")
		echo "Opcion $Opcion"
		Pausa
		;;
		"2")
		echo "Opcion $Opcion"
		Pausa
		;;
		"3")
		echo "Opcion $Opcion"
		Pausa
		;;
		*)
		echo "	Debes introducir una opcion válida"
		Pausa
		esac
	done
	clear
	exit
fi
clear
