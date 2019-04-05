#!/bin/bash

ComprobarSalida() {
	typeset -i salida
	typeset -i contador
	typeset -a Menu
	salida=$1
	contador=$2
	echo $salida
	Menu=("Seleccionar/Crear/Añadir diccionario" "Modificar el intervalo de tiempo" "Cambiar paquete de ejecución" "Cambiar fecha de inicio" "Lista de usuarios")
	menubox=""
	if [ $salida -eq 255 ]; then
		typeset -i Opcion
		for i in {1..$contador}; do
			menubox="$menubox $i ${Menu[$i]} "
		done
		Opcion=$(dialog --menu "Elige una de las opciones:" 0 0 0 $menubox 3>&1 1>&2 2>&3)
		return $Opcion
	else
		return $contador
	fi	
}

ComprobarInstalado() {
	paquete=$1
	set `whereis $paquete`
	if [ $# -eq 1 ]; then
		apt-get install -y $paquete
		if [ $? -eq 0 ];then
			return 0
		else
			return 1
		fi
	fi
	return 0
}

if [ "$USER" != "root" ]; then
	echo "Debes tener permisos de superusuario"
	sleep 1.5
	clear
	exit
fi

ruta=$0
ruta=$(echo "${ruta/\/Check-Pass-Install.sh/}")

echo "Este es el script de instalación de Check-Pass"

echo "Comprobando el estado de los paquetes necesarios..."

typeset -a Lista
typeset -i Instalado
typeset -a Paquetes

#Paquetes=("crontab" "hydra" "medusa" "ncrack" "dialog")

set `whereis crontab`
if [ $# -eq 1 ]; then
	apt-get install -y crontab
	if [ $? -eq 0 ];then
		Lista[1]="Crontab instalado"
	else
		Lista[1]="Crontab no instalado"
	fi
else
	Lista[1]="Crontab instalado"
fi

set `whereis hydra`
if [ $# -eq 1 ]; then
	apt-get install -y hydra
	if [ $? -eq 0 ];then
		Lista[2]="Hydra instalado"
	else
		Lista[2]="Hydra no instalado"
	fi
else
	Lista[2]="Hydra instalado"
fi

set `whereis medusa`
if [ $# -eq 1 ]; then
	apt-get install -y medusa
	if [ $? -eq 0 ];then
		Lista[3]="Medusa instalado"
	else
		Lista[3]="Medusa no instalado"
	fi
else
	Lista[3]="Medusa instalado"
fi

set `whereis ncrack`
if [ $# -eq 1 ]; then
	apt-get install -y ncrack
	if [ $? -eq 0 ];then
		Lista[4]="ncrack instalado"
	else
		Lista[4]="ncrack no instalado"
	fi
else
	Lista[4]="ncrack instalado"
fi


set `whereis dialog`
if [ $# -eq 1 ]; then
	apt-get install -y dialog
	if [ $? -eq 0 ];then
		Lista[5]="Dialog instalado"
	else
		Lista[5]="Dialog no instalado"
	fi
else
	Lista[5]="Dialog instalado"
fi



if [ "${Lista[$i]}" = "dialog no instalado" ]; then
	echo "No se pudo instalar dialog, prueba a instalarlo manualmente"
	sleep 2
	clear
	exit
fi

echo "Se han instalado los siguientes paquetes: " > $ruta/install-temp.txt

for i in {1..5}; do
	echo "  -${Lista[$i]}" >> $ruta/install-temp.txt
done

dialog --textbox $ruta/install-temp.txt 0 0
rm $ruta/install-temp.txt

typeset -i SALIDA
SALIDA=0

typeset -a Config
Config=($ruta/Config/Diccionarios-Config.sh $ruta/Fechas/Intervalo-Config.sh $ruta/Config/CommandMenu.sh $ruta/Fechas/Fechas-Config.sh $ruta/Usuarios/Gestion-Usuarios.sh)

typeset -i i
typeset -i Indicador
i=0
Indicador=0
while [ $i -le 5 ]; do
	${Config[$i]}
	if [ $? -eq 255 ]; then
		Menu=("Seleccionar/Crear/Añadir diccionario" "Modificar el intervalo de tiempo" "Cambiar paquete de ejecución" "Cambiar fecha de inicio" "Lista de usuarios")
		menubox=""
		typeset -i Opcion
		for a in {0..$contador}; do
			menubox="$menubox $a ${Menu[$a]} "
		done
		Opcion=$(dialog --menu "Elige una de las opciones:" 0 0 0 $menubox 3>&1 1>&2 2>&3)
		i=$Opcion
	else
		i=$(($i+1))
	fi	
	
done
