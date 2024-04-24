#!/bin/bash
################################################
## Fecha de creación - 15/02/2024             ## 
## 					      ##
## Alerta si hay pelis nuevas o eliminadas    ##
##                                            ##
################################################
cd $(dirname $0)
source ./alerta_pelis_funciones.sh

#Ruta donde guardes tus pelis
RUTA_PELIS="INTRODUCE VALOR"

#Siempre tiene que existir un old.temp, si no existe, lo crea.
#En este old.temp guadaremos la lista de pelis con formato "Titulo", sin año y sustituiremos los espacios por "."
if [[ ! -f old.temp ]]; then 
	ls $RUTA_PELIS | grep -wo "^.*[0-9][0-9][0-9][0-9]" | sed 's/ /./g'| sed 's/(//g' > old.temp
fi

#Crearemos otro fichero llamada compara.temp para comparar la lista de peliculas de old.temp con compara.temp
ls $RUTA_PELIS | grep -wo "^.*[0-9][0-9][0-9][0-9]" | sed 's/ /./g' | sed 's/(//g' > compara.temp

#Aquí usaremos diff para sacar las diferencias entre ambos ficheros
diff -y --suppress-common-lines 'old.temp' 'compara.temp' > cambios.temp

#Si la salida es 0 no ha habido cambios. Si es 1, hay cambios.
if [[ $? == 0 ]]; then
	rm compara.temp cambios.temp 2>&1
	exit 0

#Si hay cambios, el if entra aquí y con awk enviará a subidas.temp todo lo que pille como nuevo ">" y a borradas.temp lo que pille como borrado "<"
elif [[ $? == 1 ]]; then
	awk '{if ($0 ~ />/) print $2}' cambios.temp > subidas.temp
	awk '{if ($0 ~ /</) print $1}' cambios.temp > borradas.temp

#Si hay contenido en subidas.temp, ejecutamos la función aviso_subidas
	if [ -s "subidas.temp" ]; then
		aviso_subidas
	fi

#Si hay contenido en subidas.temp, ejecutamos la función aviso_borradas
	if [ -s "borradas.temp" ]; then
		aviso_borradas
	fi
fi

#Hacemos esto para que el fichero de compara ahora sea old.temp y pueda compararse de nuevo con el compara.temp que se vaya a crear en una nueva ejecución.
mv compara.temp old.temp 

