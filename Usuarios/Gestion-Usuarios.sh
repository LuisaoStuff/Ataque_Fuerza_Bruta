#!/bin/bash

CadEnArray() {
	echo $1
	echo $2
	read X
	A=1
	for i in $2; do
		if [ "$i" = "$1" ]; then
			A=0
		fi
	done
	return $A
}

ruta=$0
ruta=$(echo "${ruta/Gestion-Usuarios.sh/}")

exec 4< Lista-Usuarios.txt

Contador=1
typeset -A ListaFinal
while read linea <&4; do
	ListaFinal[$Contador]=$linea
	Contador=$(($Contador+1))
done

echo ${ListaFinal[*]}
read x

cat /etc/passwd | cut -d ":" -f 1 > temp-users.txt
exec 3< temp-users.txt
Contador=1
checklist=""
while read linea <&3; do

	if [ "$(CadEnArray $linea $ListaFinal)" == "0" ]; then 
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
		echo "${Usuarios[$i]}" > Lista-Usuarios.txt		
	else
		echo "${Usuarios[$i]}" >> Lista-Usuarios.txt
	fi
	Contador=$(($Contador+1))
done

cat Lista-Usuarios.txt
