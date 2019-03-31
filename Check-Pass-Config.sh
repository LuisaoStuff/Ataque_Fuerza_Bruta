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

ruta=$0
ruta=$(echo "${ruta/\/Check-Pass-Config.sh/}")

Interv=$(cat "$ruta/Parametros/Intervalo")
Dicc=$(cat "$ruta/Parametros/Diccionario")
Fecha=$(cat "$ruta/Parametros/Ultima-Ejecucion")
Comando=$(cat "$ruta/Parametros/Comando")

echo ""

echo 'Este es el script de configuración de "Check-Pass"' > $ruta/temp.txt
echo 'Parámetros actuales:' >> $ruta/temp.txt
echo "- Intervalo: 		$Interv" >> $ruta/temp.txt
echo "- Diccionario:		$Dicc" >> $ruta/temp.txt
echo "- Comando:		$Comando" >> $ruta/temp.txt
echo "- Última ejecucion:	$Fecha" >> $ruta/temp.txt
echo ""


dialog --backtitle "Configuración" \
 --keep-window --exit-label "Continuar" --textbox $ruta/temp.txt 0 0 \
 --and-widget --keep-window --yesno "¿Deseas modificar los parametros?" 0 0

rm $ruta/temp.txt

if [ $? -eq 0 ]; then	
	while true; do
		
		Opcion=$(dialog --backtitle "Configuración" --cancel-label "Salir" \
		--menu "Selecciona una opción" 0 0 0 \
		1 "Ejecutar Check-Pass ahora" \
		2 "Seleccionar/Crear diccionario" \
		3 "Modificar el intervalo de tiempo" \
		4 "Cambiar paquete de ejecución" \
		5 "Cambiar fecha de inicio" \
		6 "Lista de usuarios" 3>&1 1>&2 2>&3)

		if [ $? -eq 0 ]; then
			case "$Opcion"	in
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
			"4")
				bash $ruta/Config/CommandMenu.sh
			;;
			"5")
				echo "Opcion $Opcion"
				Pausa
			;;
			"6")
				echo "Opcion $Opcion"
				Pausa
			esac
		else
			clear
			exit
		fi
	done
	clear

fi
