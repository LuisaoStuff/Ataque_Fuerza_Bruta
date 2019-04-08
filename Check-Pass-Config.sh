#!/bin/bash

#Valido los permisos de root
if [ "$USER" != "root" ]; then	
	dialog --infobox "Necesitas permisos de superusuario" 0 0
	sleep 1
	clear
	exit
fi

#Genero la ruta relativa del script
ruta=`dirname $0`

Interv=$(cat "$ruta/Fechas/Intervalo")
Dicc=$(cat "$ruta/Parametros/Diccionario")
Fecha=$(cat "$ruta/Fechas/Fecha1.txt")
Comando=$(cat "$ruta/Parametros/Comando")
# 
# Genero un fichero de parámetros temporal
echo 'Este es el script de configuración de "Check-Pass"' > $ruta/temp.txt
echo 'Parámetros actuales:' >> $ruta/temp.txt
echo "- Intervalo: 		cada  $Interv días" >> $ruta/temp.txt
echo "- Diccionario:		$Dicc" >> $ruta/temp.txt
echo "- Comando:		$Comando" >> $ruta/temp.txt
echo "- Próxima ejecucion:	$Fecha" >> $ruta/temp.txt
echo ""


dialog --backtitle "Configuración" \
 --keep-window --exit-label "Continuar" --textbox $ruta/temp.txt 0 0 \
 --and-widget --keep-window --yesno "¿Deseas modificar los parametros?" 0 0

if [ $? -eq 0 ]; then	
	while true; do
		
		Opcion=$(dialog --backtitle "Configuración" --cancel-label "Salir" \
		--menu "Selecciona una opción" 0 0 0 \
		1 "Ejecutar Check-Pass ahora" \
		2 "Seleccionar/Crear/Añadir diccionario" \
		3 "Modificar el intervalo de tiempo" \
		4 "Cambiar paquete de ejecución" \
		5 "Cambiar fecha de inicio" \
		6 "Lista de usuarios" 3>&1 1>&2 2>&3)

		if [[ -n "$Opcion" ]]; then
			case "$Opcion"	in
			"1")
				dialog --infobox "Ejecutando Check-Pass..." 0 0
				$ruta/Check-Pass.sh
			;;
			"2")
				$ruta/Config/Diccionarios-Config.sh '--cancel-label "Salir"'
			;;
			"3")
				$ruta/Fechas/Intervalo-Config.sh
			;;
			"4")
				$ruta/Config/CommandMenu.sh
			;;
			"5")
				$ruta/Fechas/Fechas-Config.sh
			;;
			"6")
				$ruta/Usuarios/Gestion-Usuarios.sh
			esac
		else
			clear
			#Borro el fichero temporal
			rm $ruta/temp.txt
			exit
		fi
	done

fi
clear
#Borro el fichero temporal
rm $ruta/temp.txt

