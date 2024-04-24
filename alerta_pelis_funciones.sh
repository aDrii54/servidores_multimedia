#!/bin/bash

function aviso_subidas(){
        while read line
        do
		api_key="8ae08e11c69497e279f94e747befdbd2"
                titulo=$(sed 's/\(.*\)\.\([0-9]\{4\}\)/\1/' subidas.temp| sed 's/\./%20/g')
                year=$(sed 's/.*\.\([0-9]\{4\}\)/\1/' subidas.temp)
                portada=$(curl "https://api.themoviedb.org/3/search/movie?api_key=$(api_key)&query=${titulo}&year=${year}&language=es-ES" | jq '.results[].poster_path | "https://image.tmdb.org/t/p/w500" + .')
                portada_w=$(echo $portada|sed 's/"//g'| awk '{ split($0,a," "); print a[1]}' ); wget $portada_w
                portada_envio=$(echo $portada_w| sed 's@https://image.tmdb.org/t/p/w500/@@g')
                sinopsis=$(curl "https://api.themoviedb.org/3/search/movie?api_key=$(api_key)&query=${titulo}&year=${year}&language=es-ES" | jq '.results[].overview')
                sinopsis_e=$(echo $sinopsis| awk '{ split($0,a,"\""); print a[2]}')
                nota=$(curl "https://api.themoviedb.org/3/search/movie?api_key=$(api_key)&query=${titulo}&year=${year}&language=es-ES" | jq '.results[].vote_average')
                nota_e=$(echo $nota| awk '{ split($0,a," "); print a[1]}')
                titulo=$(echo $titulo| sed -e 's/%20/ /g')
                TOKEN="6408734443:AAHRtxZDrKiYZFWvxPpXm1Y97EnKiPnSoGM"
                CHAT_ID="-1002094716188"
                MESSAGE="✅NUEVA PELICULA SUBIDA
<b>Nota (TMDB): </b>$nota_e
<b>Año: </b>$year
<b>Título: </b>$titulo
<b>Sinopsis: </b>$sinopsis_e"
		IMAGE_PATH="$(pwd)/$portada_envio"
                curl -X POST \
                -H 'Content-Type: multipart/form-data' \
                -F chat_id=$CHAT_ID \
                -F photo=@$IMAGE_PATH \
                -F caption="$MESSAGE" \
                -F parse_mode="HTML" \
                https://api.telegram.org/bot$TOKEN/sendPhoto
        done < subidas.temp
        rm -rf $portada_envio
}


function aviso_borradas(){
	while read line
        do
		api_key="8ae08e11c69497e279f94e747befdbd2"
                titulo=$(sed 's/\(.*\)\.\([0-9]\{4\}\)/\1/' borradas.temp| sed 's/\./%20/g')
                year=$(sed 's/.*\.\([0-9]\{4\}\)/\1/' borradas.temp)
                portada=$(curl "https://api.themoviedb.org/3/search/movie?api_key=$(api_key)&query=${titulo}&year=${year}&language=es-ES" | jq '.results[].poster_path | "https://image.tmdb.org/t/p/w500" + .')
                portada_w=$(echo $portada|sed 's/"//g'| awk '{ split($0,a," "); print a[1]}' ); wget $portada_w
                portada_envio=$(echo $portada_w| sed 's@https://image.tmdb.org/t/p/w500/@@g')
                sinopsis=$(curl "https://api.themoviedb.org/3/search/movie?api_key=$(api_key)&query=${titulo}&year=${year}&language=es-ES" | jq '.results[].overview')
                sinopsis_e=$(echo $sinopsis| awk '{ split($0,a,"\""); print a[2]}')
                nota=$(curl "https://api.themoviedb.org/3/search/movie?api_key=$(api_key)&query=${titulo}&year=${year}&language=es-ES" | jq '.results[].vote_average')
                nota_e=$(echo $nota| awk '{ split($0,a," "); print a[1]}')
                titulo=$(echo $titulo| sed -e 's/%20/ /g')
                TOKEN="6408734443:AAHRtxZDrKiYZFWvxPpXm1Y97EnKiPnSoGM"
                CHAT_ID="-1002094716188"
                MESSAGE="❌PELICULA ELIMINADA
<b>Nota (TMDB): </b>$nota_e
<b>Año: </b>$year
<b>Título: </b>$titulo
<b>Sinopsis: </b>$sinopsis_e"
		IMAGE_PATH="$(pwd)/$portada_envio"
                curl -X POST \
                -H 'Content-Type: multipart/form-data' \
                -F chat_id=$CHAT_ID \
                -F photo=@$IMAGE_PATH \
                -F caption="$MESSAGE" \
                -F parse_mode="HTML" \
                https://api.telegram.org/bot$TOKEN/sendPhoto
        done < borradas.temp
        rm -rf $portada_envio
}
