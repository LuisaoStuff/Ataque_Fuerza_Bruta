#!/bin/bash

exec 4< $ruta/Lista-Usuarios.txt

typeset -i Contador
Contador=1

while read linea <&4; do

	if [ $Contador -eq 1 ]; then
		cat /etc/shadow |cut -d ":" -f 1,2 | grep -v "*" | grep -v "!" | grep $linea > $ruta/UsuariosYContraseñasActual.txt
	else
		cat /etc/shadow |cut -d ":" -f 1,2 | grep -v "*" | grep -v "!" | grep $linea > $ruta/UsuariosYContraseñasActual.txt
	fi
	Contador=$(($Contador+1))
done

exec 5< $ruta/UsuariosYContraseñas.txt
exec 6< $ruta/UsuariosYContraseñasActual.txt
Contador=1

while read linea <&6; do

	while read usuario <&5; do
		
		if [ "$linea" != "$usuario" ]; then
			if [ $Contador -eq 1 ];then 
				cat /etc/shadow | grep $linea | cut -d ":" -f 1 > $ruta/Auditoria.txt
			else
				cat /etc/shadow | grep $linea | cut -d ":" -f 1 >> $ruta/Auditoria.txt
			fi
		fi
	done

done

cat $ruta/Auditoria.txt > $ruta/Lista-Usuarios.txt
cat $ruta/UsuariosYContraseñasActual.txt > $ruta/UsuariosYContraseñas.txt
