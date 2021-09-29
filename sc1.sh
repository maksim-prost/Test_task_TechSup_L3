#!/bin/bash

SERVER_DATE=${1:-'default_server'}$(date +_%d_%m_%Y)
running_out="$SERVER_DATE"_running.out
failed_out="$SERVER_DATE"_failed.out
report_out="$SERVER_DATE"_report.out

if [[ ! -d archives ]]
    then mkdir archives
fi
if [[ ! -f archives/"$SERVER_DATE".tar ]]
    then 
        link='https://raw.githubusercontent.com/GreatMedivack/files/master/list.out'
        curl -so temp  $link >> /dev/null
        awk '/Running/ {print $1;}' temp | sed 's/-[a-z0-9]\{9,\}-[a-z0-9]\{5\}$//'  > "$running_out"
        awk  '/Error|CrashLoopBackOff/ {print $1}' temp | sed 's/-[a-z0-9]\{9,\}-[a-z0-9]\{5\}$//' > "$failed_out" 
        echo "Количество работающих сервисов: $(cat $running_out | wc -l)
Количество сервисов с ошибками: $(cat $failed_out | wc -w)
Имя системного пользователя: $USER
Дата: $(date +%d/%m/%y )">"$report_out"
        chmod 444 "$report_out"
        tar -cf archives/"$SERVER_DATE".tar "$report_out" "$failed_out" "$running_out"
        rm -f "*".out temp
        # rm  -f "$report_out" "$failed_out" "$running_out" temp
fi

tar -xf archives/"$SERVER_DATE".tar >> /dev/null
if [[ $? -eq 0 ]] 
    then echo "Successfull completed"
    else echo $?
fi


