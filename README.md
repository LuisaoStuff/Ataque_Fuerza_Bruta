# ScriptSistemas

### Escribe un script que compruebe la fortaleza de las contraseñas de los usuarios, haciendo semanalmente un ataque de diccionario/fuerza bruta contra los hashes de las contraseñas que han cambiado en la última semana.
Esta aplicación está conformada por distintas carpetas y scripts, divididos por funciones y ficheros de configuración. Esto permite un mayor orden en el código.
Auque inicialmente se ejecutaba cada semana, ahora existe un script de instalación y otro de configuración que te permiten modificar todos estos parámetros.
Desde el establecimiento del intervalo de tiempo, la fecha de la primera auditoría, la elección / generación del diccionario, etc.

Para un mejor entendimiento del código dejo la estructura de la aplicación:

## Check-Pass-Install
[Check-Pass-Install](Check-Pass-Install.sh) inicia un proceso de instalación que sigue los siguientes pasos:
- Comprueba que están instalados los paquetes pertinentes e instala los que falten.
- Despliega el menú de configuración del diccionario
- Establece el intervalo
- Escoge el binario para ejecutar el ataque de diccionario
- Establece la fecha de la próxima auditoría
- Lee el fichero /etc/shadow e imprime un menú de seleccion de los usuarios con contraseña

## Check-Pass-Config
[Check-Pass-Config](Check-Pass-Config.sh) imprime una caja de información con los parámetros actuales y te permite modificarlos

## Check-Pass
[Check-Pass](Check-Pass.sh) es un script de ejecución del ataque de fuerza bruta

## Trigger
[Trigger](Fechas/Trigger.sh) se ejecuta la primera vez cuando se establece una nueva fecha inicial. Ejecuta Check-Pass y seguidamente establece en crontab la ejecución de Check-Pass según el intervalo de tiempo marcado en el fichero correspondiente.

###	Ejemplo
	Fichero crontab:		(Intervalo = 6)
	* * 10 04 * bash /home/usuario/Trigger.sh	# Se ejecuta el 10/04
	.....................................................................
	Una vez se ejecute añadirá la linea:
	* * */6 * * bash /home/usuario/Check-Pass	# Se ejecutará cada 6 días

## CommandMenu
[CommandMenu](Config/CommandMenu.sh) despliega un menú de seleccion con los binarios disponibles en el fichero [ListaComandos.txt](Config/ListaComandos.txt) para realizar el ataque de fuerza bruta

## Diccionarios-Config
[Diccionrios-Config](Config/Diccionrios-Config.sh) despliega un menú que te permite elegir una de las siguientes funciones:
- Elegir uno de los diccionarios de dicha [carpeta](Parametros/Diccionarios)
- Añadir un diccionario
- Crear un diccionario con el paquete "crunch"

## Gestion-Usuarios
[Gestion-Usuarios](Usuarios/Gestion-Usuarios.sh) lee el fichero /etc/shadow e imprime un menú de seleccion de los usuarios con contraseña permitiendote elegir qué usuarios se van a monitorizar las contraseñas, para una posible comprobación de la fortaleza de aquellas que hallan cambiado en el intervalo de tiempo.

## Auditoria-Contraseñas
[Auditoria-Contraseñas](Usuarios/Auditoria-Contraseñas.sh) genera una lista de las contraseñas actuales de los usuarios seleccionados en el script de [Gestion-Usuarios](Usuarios/Gestion-Usuarios.sh) y las compara con la lista que se generó al elegir la fecha de inicio en el script [Fechas-Config](Fechas/Fechas-Config.sh). Si encuentra alguna contraseña que fue modificada, añade al usuario al fichero [Auditorias](Usuarios/Auditoria.txt) que se usará en la ejecución del ataque por diccionario.

## Fechas-Config
[Fechas-Config](Fechas/Fechas-Config.sh) te permite elgir qué dia se llevará a cabo la auditoría, siempre y cuando se respete el intervalo de tiempo escogido en el script [Intervalo-Config](Fechas/Intervalo-Config.sh).

###	Ejemplo
	Si el intervalo es 5 dias, y estamos a 09/04/19, podrás escoger una fecha a partir del día 14/09/19.

## Intervalo-Config
[Intervalo-Config](Fechas/Intervalo-Config.sh) simplemente te permite escoger cada cuántos días se harán las auditorias.


