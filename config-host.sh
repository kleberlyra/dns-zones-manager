#!/bin/bash

source definicoes.sh
source funcoes.sh

InserirHost(){
	Cabecalho "HOST - Incluir"

	read -p "ID do domínimo, informe '0' para sair: " DOMINIO
	( [ "${DOMINIO}" = "0" ] || [ -z "${DOMINIO}" ] ) && return 0

	read -p "Nome do host:" NOME

	OP_ID=($(SelectMySQL "select id from operadora where ativo='S'"))
	OP_NOME=($(SelectMySQL "select nome from operadora where ativo='S'"|tr " " "_"))

	for ((X=0;X<${#OP_ID[@]};X=X+1)); do
		echo ${OP_NOME[X]}
	done
	exit 0;
}

AlterarHost(){
	clear
}

ExcluirHost(){
	clear
}

ListarHost(){
	echo -e "Hosts cadastrados\n"
	ListMySQL "select * from host"
}


MenuHost(){
	Cabecalho "HOST - Principal"
	echo -e "\n1 - Listar Hosts\n2 - Inserir Hosts\n\n0 - Sair\n"
	read -p "Escolha uma das opcoes: " OPCAO

	case ${OPCAO} in
		1) clear; Cabecalho "HOST - Listagem"; ListarHost; Pause;;
		2) clear; InserirHost;;
		0) return 0;;
		
	esac
	MenuHost
}


MenuHost
