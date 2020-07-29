#!/bin/bash
function _tip() {
  local def="$2"
  local info='Enter '$1
  if [ "" != "$def" ]; then
    info=$info"(default "$def")"
  fi
  info=$info" :"
  echo -n "$info"
}
#重新设置密码
#$1 username
#$2 password
#$3 ?output path
function _set_passwd() {
  local tip=$(_tip name admin)
  local name
  read -p "$tip" -r name
  if [ -z "$name" ]; then name=admin; fi
  local uuid_path=/proc/sys/kernel/random/uuid
  local _passwd=$(head /dev/urandom | cksum | md5sum | cut -c 1-9)
  local passwd
  tip=$(_tip passwd "$_passwd")
  local passwd
  read -p "$tip" -r passwd
  if [ -z "$passwd" ]; then passwd=$_passwd; fi
  local dir="$(cd "$(dirname "$0")" && pwd)"
  local passwd_path="$dir"/passwd
  local cache="${name}:${passwd}"
  local result="${name}:$(openssl passwd -apr1 "$passwd")"
  echo "$cache"
  if [ "" != "$1" ]; then
    if [ -f "$1" ]; then
      local content=$(cat "$1")
      sed -i -e '/^$/d' "$1"
      printf "sed -i '/^%s:/d' %s" "$name" "$1" | bash
      echo "$result" >>"$1"
    else
      echo "$result" >"$1"
    fi
  fi
}

function _cache() {
  local name=$1
  local val=$2
  local path=./variables
  if [ ! -f "$path" ]; then touch "$path"; fi
  if [ -z "$name" ]; then
    echo 'must set path!'
    return 1
  fi
  if [ -n "$val" ]; then
    (printf "sed -i -e '/^%s:/d' %s" "$name" "$path") | bash
    echo "$name":"$val" >>"$path"
  else
    sed -n '/^'"$name"'/ p' "$path" | sed -e 's/'"$name"'://'
  fi
}

function _get_uuid() {
  local uuid=_cache uuid
  if [ ${#uuid} -lt 10 ]; then
    uuid=$(cat /proc/sys/kernel/random/uuid)
    _cache uuid "$uuid"
  fi
  echo -n "$uuid"
}

case $1 in
set_passwd)
  _set_passwd "$2"
  ;;
cache)
  _cache "$2" "$3"
  ;;
uuid)
  _get_uuid "$1"
  ;;
esac
exit 0
