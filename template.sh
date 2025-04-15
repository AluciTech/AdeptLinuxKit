#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

#Get user home if using "sudo" or "sudo su" to launch script. Terminate execution if using root account
if [[ $HOME = "/root" ]]; then
	if [[ $SUDO_USER != "" ]]; then 
		REAL_HOME="/home/$SUDO_USER"
	else
		echo -e "${RED}It is not recommended to execute these scripts as root${RESET}"
		exit -1
	fi
else	
	REAL_HOME=$HOME
fi

#Affichage de l'aide en cas d'appel à l'option -h ou en cas de mauvaise option
dhelp() {
	cat << EOF
Usage: $0 [OPTIONS]

<DESCRIPTION DU SCRIPT>

Options:
  -h, --help	Display this help
  -d, --debug	Display all log during the install

Exemples:
  $0 -h
  $0 -d
EOF
}

#Parsing des options (-o pour les noms court, --long pour les noms long, ajouter ":" après le nom pour pouvoir ajouter un argument)
OPTS=$(getopt -o hd --long help,debug -n'<NOM DU SCRIPT>' -- "$@")

#En cas d'option inexistante, appel à la fonction dhelp
if [ $? -ne 0 ]; then
	dhelp
	exit 0
fi

eval set -- "$OPTS"

DEBUG=false

#Traitement des options
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

#Redirection des sortie vers le /dev/null pour ne pas afficher les sorties en dehors du mode debug
if [ $DEBUG = false ]; then
	REDIRECT="&> /dev/null"
fi

#Installation
eval "<COMMANDE D'INSTALLATION> $REDIRECT"
eval "<COMMANDE DE VÉRIFICATION DE L'INSTALLATION> $REDIRECT"

#Récupétation du code de sortie de la commande de vérification
exitcode=$?
#Si code == 0 alors Succès sinon Échec (si le code de succès n'est pas 0 le changer dans le if)
if [ $exitcode -eq 0 ]; then
	echo -e "${GREEN}<SCRIPT> sucessfully installed\n${RESET}Type \"sdk help\" to learn how to use"
else
	echo -e "${RED}Error while installing <SCRIPT>${RESET}"
fi

#Sortie du script avec le code de sortie de la vérification pour pouvoir remonter au script appellant le statut du script.
exit $exitcode
