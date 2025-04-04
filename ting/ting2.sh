(
  while true; do
    size=$(du -sb target/criterion/data/main/General-pattern-algorithm1-vs.-exact-short-run | cut -f1)
    echo $size
    sleep 1
  done
)

