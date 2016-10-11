#!/bin/bash

source definicoes.sh
source funcoes.sh

Menu(){
	Cabecalho "Menu Principal"
	echo -e "\n1 - Operadoras\n2 - Ranges e IPs\n3 - Domínios\n0 - Sair\n"
	read -p "Escolha uma das opcoes: " OPCAO

	case ${OPCAO} in
		1) ./config-operadora.sh;;
		2) ./config-range.sh;;
		3) ./config-dominio.sh;;
		0) return 0;;
	esac
	Menu
}


Menu

