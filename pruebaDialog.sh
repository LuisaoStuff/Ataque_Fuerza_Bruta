
#!/bin/bash

ruta=$0
ruta=$(echo "${ruta/\/pruebaDialog.sh/}")

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


dialog --backtitle "Configuracion" \
 --keep-window --exit-label "Continuar" --textbox $ruta/temp.txt 0 0 \
 --and-widget --keep-window --yesno "¿Deseas modificar los parametros?" 0 0

rm $ruta/temp.txt
