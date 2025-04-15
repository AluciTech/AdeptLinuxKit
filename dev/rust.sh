#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

dhelp() {
	cat << EOF
Usage: $0 [OPTIONS]

Script to quicly install rust and dependencies

Options:
  -h, --help	Display this help
  -d, --debug	Display all log during the install

Exemples:
  $0 -h
  $0 -d
EOF
}

OPTS=$(getopt -o hd --long help,debug -n'rust.sh' -- "$@")

if [ $? -ne 0 ]; then
	dhelp
	exit 0
fi

eval set -- "$OPTS"

DEBUG=false

while true; do
	case "$1" in
		-h | --help)
			dhelp
			exit;;
		-d | --debug)
			DEBUG=true
			shift
			;;
		--)
			shift
			break
			;;
	esac
done

if [ $DEBUG = false ]; then
	REDIRECT="&> /dev/null"
fi

eval "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh $REDIRECT"
eval "rustc --version $REDIRECT"
exitcode=$?
if [ $exitcode -eq 0 ]; then
	echo -e "${GREEN}Rust sucessfully installed${RESET}"
else
	echo -e "${RED}Error while installing Rust${RESET}"
fi
exit $exitcode

