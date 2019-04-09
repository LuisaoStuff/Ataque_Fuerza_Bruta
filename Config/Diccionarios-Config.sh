#!/bin/bash

VolverMenu() {

	dialog --yesno "¿Deseas modificar alguna opción más? $Extra" 0 0
	if [ $? -eq 1 ];then
		echo "0" > $ruta/../salida.txt && clear && exit
	fi
}

CrunchInstalado() {
	set `whereis crunch`
	if [ $# -eq 1 ]; then
		dialog --yesno "crunch no está instalado. ¿Deseas instalarlo?" 0 0
		if [ $? -eq 0 ]; then
			apt-get install crunch
			if [ $? -eq 0 ]; then
				dialog --msgbox "Instalación existosa" 0 0
				return 0
			fi
		else
			return 1
		fi
		return 0
	fi
	return 0
}

CancelarPulsado() {
	if [ $? -eq 1 ]; then
		dialog --infobox "Operación cancelada" 0 0
		VolverMenu		
		sleep 1
	fi
}

#Valido los permisos de root
if [ "$USER" != "root" ]; then	
	dialog --infobox "Necesitas permisos de superusuario" 0 0
	sleep 1
	clear
	return 1
fi

ruta=`dirname $0`

Extra=$2

while true; do
		
	Opcion=$(dialog --backtitle "Configuración" $1 \
	--menu "Selecciona una opción" 0 0 0 \
	1 "Cambiar el diccionario" \
	2 "Crear un diccionario (crunch)" \
	3 "Añadir un diccionario al directorio" \
	4 "Diccionario por defecto" \
	3>&1 1>&2 2>&3)
	echo "$Opcion"
	if [[ -n "$Opcion" ]]; then
		case "$Opcion"	in
		"1")
		ls $ruta/../Parametros/Diccionarios/ > $ruta/Lista-Diccionarios.txt

		exec 3< $ruta/Lista-Diccionarios.txt
		Contador=1
		typeset -A Menu
		Diccionario=$(cat $ruta/../Parametros/Diccionario | rev | cut -d "/" -f 1 | rev)

		while read linea <&3; do
			if [ "$Diccionario" = "$linea" ]; then 
				radiolist="$radiolist $Contador $Diccionario on "
				Contador=$(($Contador+1))
			else
				radiolist="$radiolist $Contador $linea off "
				Menu[$Contador]="$linea"
				Contador=$(($Contador+1))
			fi
		done
		Opcion=$(dialog --backtitle "Configuracion" \
		--radiolist "Selecciona un diccionario" 0 0 $Contador \
		$radiolist 3>&1 1>&2 2>&3)
		if [[ $? -eq 0 ]]; then
			if [[ -n "$Opcion" ]];then
				echo "${Menu[$Opcion]}" > $ruta/../Parametros/Diccionario
				dialog --infobox "Seleccionaste: ${Menu[$Opcion]}" 0 0
				sleep 1.5
			fi
		fi
		VolverMenu	
		;;
		"2")
			
		set `whereis crunch`
		if [ $# -eq 1 ]; then
			dialog --yesno "crunch no está instalado. ¿Deseas instalarlo?" 0 0
			if [ $? -eq 0 ]; then
				dialog --infobox "Instalando crunch..." 0 0
				apt-get install crunch -y > /dev/null			
				if [ $? -eq 0 ]; then
					dialog --msgbox "Instalación existosa" 0 0
				fi
			else
				echo "254"  > $ruta/../salida.txt && clear && exit
			fi
		fi

		if [ $Instalado -eq 1 ]; then
			dialog --ok-label "Volver" --msgbox "No se puede continuar sin crunch instalado" 0 0
			echo "254"  > $ruta/../salida.txt && clear && exit
		fi
		LongMin=$(dialog --rangebox "Selecciona una longitud mínima de contraseña" \
		0 0 1 10 5 3>&1 1>&2 2>&3)
		CancelarPulsado
		LongMax=$(dialog --rangebox "Selecciona una longitud mínima de contraseña" \
		0 0 $LongMin 10 3 3>&1 1>&2 2>&3)
		CancelarPulsado
		Caracteres=$(dialog --inputbox "Introduce los caracteres que va a contener la contraseña:" \
				0 0 3>&1 1>&2 2>&3)
		typeset -i NumChar	
		NumChar=$(echo -n "$Caracteres" | wc -c)

		while [ $NumChar -lt 8 ]; do
			dialog --ok-label "Continuar" --msgbox "Debes introducir al menos 8 caracteres distintos" 0 0
			Caracteres=$(dialog --inputbox "Introduce los caracteres que va a contener la contraseña:" \
					0 0 3>&1 1>&2 2>&3)
			CancelarPulsado
			NumChar=$(echo -n "$Caracteres" | wc -c)
		done
		CancelarPulsado
		nombre=$(dialog --inputbox "Introduce un nombre para el archivo (se le añadirá la extensión '.txt')" \
				0 0 3>&1 1>&2 2>&3)
			CancelarPulsado
			NumChar=$(echo -n "$nombre" | wc -c)
		while [ $NumChar -lt 1 ]; do
			dialog --ok-label "Continuar" --msgbox "Debes introducir al menos 8 caracteres distintos" 0 0
			nombre=$(dialog --inputbox "Introduce un nombre para el archivo (se le añadirá la extensión '.txt')" \
				0 0 3>&1 1>&2 2>&3)
			CancelarPulsado
			NumChar=$(echo -n "$nombre" | wc -c)
		done
		nombre="$ruta/../Parametros/Diccionarios/$nombre.txt"
		
		crunch $LongMin $LongMax [$Caracteres] -o $nombre 2&> "$ruta/tam-temp.txt" &

		set `ps aux | grep crunch | grep -v grep`
		PID=$(echo $2)
		kill -9 $PID
		dialog --backtitle "Configuración" \
		 --keep-window --echo "254"  > $ruta/../salida.txt && clear && exit-label "Continuar" --textbox $ruta/tam-temp.txt 0 0 \
		 --and-widget --keep-window --yesno "¿Deseas continuar con la creacion del diccionario?" 0 0
		if [ $? -eq 1 ]; then
			dialog --infobox "Operación cancelada" 0 0		
			rm $ruta/tam-temp.txt
			rm $nombre
			sleep 1
			echo "254"  > $ruta/../salida.txt && clear && exit
		fi
		echo ""
		clear
		dialog --infobox "Creando diccionario..." 0 0
		crunch $LongMin $LongMax [$Caracteres] -o $nombre 2&> "$ruta/tam-temp.txt"
		dialog --msgbox "Proceso finalizado" 0 0
		rm $ruta/tam-temp.txt
		VolverMenu
		;;
		"3")
			destino="$ruta/../Parametros/Diccionarios/"
			RUTA=$(dialog --backtitle "Configuración" --fselect /home 20 15 3>&1 1>&2 2>&3)
			CancelarPulsado
			dialog --backtitle "Configuración" --yesno "¿Estás seguro de mover $RUTA a $destino?" 0 0
			if [ $? -eq 0 ]; then
				mv $RUTA $destino
				dialog --infobox "Operación echo "254"  > $ruta/../salida.txt && clear && exitosa" 0 0
				sleep 1
				clear
			else
				dialog --infobox "Operación cancelada" 0 0
				sleep 1
				clear			
			fi
		VolverMenu
		;;
		"4")
			echo "Top304Thousand-probable-v2.txt" > $ruta/../Parametros/Diccionario
			dialog --infobox "Se ha establecido el diccionario por defecto (Top304Thousand-probable-v2.txt)" 0 0
			sleep 2
			VolverMenu
		esac
	else
		clear
		echo "255"  > $ruta/../salida.txt && clear && exit
	fi
done
clear
