# ScriptSistemas

## Escribe un script que compruebe la fortaleza de las contraseñas de los usuarios, haciendo semanalmente un ataque de diccionario/fuerza bruta contra los hashes de las contraseñas que han cambiado en la última semana.

Esta aplicación está conformada por distintas carpetas y scripts, divididos por funciones y ficheros de configuración. Esto permite un mayor orden en el código.
Auque inicialmente se ejecutaba cada semana, ahora existe un script de instalación y otro de configuración que te permiten modificar todos estos parámetros.
Desde el establecimiento del intervalo de tiempo, la fecha de la primera auditoría, la elección / generación del diccionario, etc.

Para un mejor entendimiento del código dejo la estructura de la aplicación:

## Check-Pass-Install
- Comprueba que están instalados los paquetes pertinentes e instala los que falten.
- Despliega el menú de configuración del diccionario
- Establece el intervalo
- Escoge el binario para ejecutar el ataque de diccionario
- Establece la fecha de la próxima auditoría
- Lee el fichero /etc/shadow e imprime un menú de seleccion de los usuarios con contraseña

## Check-Pass-Config
Imprime una caja de información con los parámetros actuales y te permite modificarlos

## Check-Pass
Script de ejecución del ataque de fuerza bruta

## Trigger
Se ejecuta la primera vez cuando se establece una nueva fecha inicial. Ejecuta Check-Pass y seguidamente establece en crontab la ejecución de Check-Pass según el intervalo de tiempo marcado en el fichero correspondiente.

## CommandMenu
Despliega un menú de seleccion con los binarios disponibles en el fichero [ListaComandos.txt](ScriptSistemas/Config/ListaComandos.txt) para realizar el ataque de fuerza bruta

## Diccionarios-Config
Despliega un menú que te permite elegir una de las siguientes funciones:
- Elegir uno de los diccionarios de dicha [carpeta](ScriptSistemas/Parametros/Diccionarios)
-
