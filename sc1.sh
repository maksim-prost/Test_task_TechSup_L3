#!/bin/bash

SERVER_DATE=${1:-'default_server'}$(date +_%d_%m_%Y)

if [[ -f archives ]]
    then echo mkdir archives
    elif [[ ! -f archives/"$SERVER_DATE".tar ]]
        then 
            # link='https://raw.githubusercontent.com/GreatMedivack/files/master/list.out'
            # curl -o temp  $link
            regexp='/-[a-z0-9]+-[a-z0-9]+$/'
            awk '/Running/ {print $1;}' temp | sed 's/-[a-z0-9]\{9,\}-[a-z0-9]\{5\}$//'  > "$SERVER_DATE"_running.out
            
            # \
            #                                 sub(/-[a-z0-9]+-[a-z0-9]+$/, "", $1);\
            #                                 print $1}' temp  > "$SERVER_DATE"_running.out
            awk  '/Error|CrashLoopBackOff/ {print $1}' temp | sed 's/-[a-z0-9]\{9,\}-[a-z0-9]\{5\}$//' > "$SERVER_DATE"_failed.out 

            report_out="$SERVER_DATE"_report.out
            # echo $report_out
            echo "Количество работающих сервисов: $(cat *running.out | wc -l)
Количество сервисов с ошибками: $(cat *failed.out | wc -l)
Имя системного пользователя: $USER
Дата: $(date +%d/%m/%y )">"$report_out"

            # echo ./archives/"$SERVER_DATE".tar
            tar -cf archives/"$SERVER_DATE".tar *.out
            # rm *.out
fi

tar -xf archives/"$SERVER_DATE".tar >> /dev/null; 
if [[ $? -eq 0 ]] 
    then echo "Successfull completed"
    else echo $?
fi


