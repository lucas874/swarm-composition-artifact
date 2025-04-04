for (( i = 1 ; i <= 100 ; i++ )); do sleep 1; echo $i; done | (>&2 echo -en "\r"; pv --progress --line-mode --size 100 --eta --timer) > /dev/null
