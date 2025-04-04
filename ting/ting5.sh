(
  while true; do
    size=$(du -sb target/criterion/data/main/General-pattern-algorithm1-vs.-exact-short-run | cut -f1)
    head -c $size /dev/zero
    sleep 1
  done
) | (>&2 echo -en "\r"; pv --progress --line-mode --size 9768 --eta --timer) > /dev/null
