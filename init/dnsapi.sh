#!/bin/bash
cs={};
function get_info() {
  local content=$(cat "$1")
  local info=$(echo "$content" | sed -n -e '/#/ p' | sed -n '1p' | sed -e 's/[\r\n\t]//g')
  local name=$( (basename "$1") | sed -e 's/\.env$//g')
  cs[$name]=$content;
  if [ -n "$info" ]; then
    printf "%s (%s) \n" "$name" "$info"
  else
    echo "$name"
  fi
}
for f in ./dns_template/*.env; do
  [[ -e "$f" ]] || break # handle the case of no *.wav files
  get_info "$f"
done