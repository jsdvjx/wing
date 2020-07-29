#!/bin/bash
# blue to echo
function blue() {
  echo -e "\033[34m[ $1 ]\033[0m"
}

## green to echo
function green() {
  echo -e "\033[32m[ $1 ]\033[0m"
}

## Error to warning with blink
function red() {
  echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m";
}

## Error
function b_red() {
  echo -e "\033[31m\033[01m[ $1 ]\033[0m"
}

## warning
function b_yellow() {
  echo -e "\033[33m\033[01m[ $1 ]\033[0m"
}
(printf "%s %s" "$0" "$1") | bash
exit 0;
