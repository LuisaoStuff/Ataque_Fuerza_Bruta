#!/bin/bash

Interv=$(cat ./Parametros/Intervalo)
Dicc=$(cat ./Parametros/Diccionario)
Fecha=$(cat ./Parametros/Ultima-Ejecucion)

echo '	Este es el script de configuración de "Check-Pass"'
echo '		Parámetros actuales:'
echo "		- Intervalo: 		$Interv"
echo "		- Diccionario:		$Dicc"
echo "		- Última vez ejecutado:	$Fecha"
echo ""
read -p "	¿Deseas modificar algún parámetro? (S/N) " Decision


echo 'Seleccione a continuación una de las siguientes opciones:'
echo '	1- Inicializar el script'
echo '	2- Seleccionar/Crear diccionario'
echo '	3- Modificar intervalo de tiempo'
