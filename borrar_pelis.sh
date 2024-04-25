#!/bin/bash

RUTA_PELIS="/media/terramaster/plex/Peliculas/" 
DIAS=90

ls -tr $RUTA_PELIS | grep -v 'pelis.lista' > pelis.lista

while IFS= read -r archivo
do
    fecha_modificacion=$(stat -c "%y" "${RUTA_PELIS}${archivo}"| cut -d' ' -f1)
    fecha_actual=$(date +'%Y-%m-%d')
    timestamp1=$(date -d "$fecha_actual" +%s)
    timestamp2=$(date -d "$fecha_modificacion" +%s)
    diferencia_segundos=$((timestamp1 - timestamp2))
    diferencia_dias=$((diferencia_segundos / (60*60*24)))
    if [[ $diferencia_dias -ge $DIAS ]]
    then
	echo "--------------------------------------------------------------------------"
    	echo -e "\n \e[4;30;43m${archivo}\e[0m se subió hace $DIAS días o más, ¿quieres eliminarla?\n" 
	echo -e "1. Borrar"
	echo -e "2. Actualizar"
        echo -e "3. Omitir"	
	echo -e "4. Salir\n"
	read -p "Elige una opción: " opcion < /dev/tty 
		case $opcion in
			1)	
				rm ${RUTA_PELIS}"$archivo"
				echo -e "\n\033[31mSe ha eliminado la pelicula $archivo\033[0m\n"
			;;

			2)
				touch ${RUTA_PELIS}"$archivo"
				echo -e "\nSe ha actualizado ${RUTA_PELIS}'$archivo'"
			;;
		
			3)
				echo -e "\nNo se ha eliminado ${RUTA_PELIS}'$archivo'"
			;;

			4)
				exit 0
			;;
		esac	
	else
		check=1
	fi
done < pelis.lista

if [[ $check == 1 ]]
then
	echo "No hay películas para borrar"
fi

