#!/bin/bash

source definicoes.sh

Pause(){
	[ $# -gt 0 ] && read -p "$*" || read -p "Pressione [Enter] para continuar..."
}

Cabecalho(){
	clear
	echo -e "************************************************************************"
	echo -e "* Sistema de Configuracao de DNS - Data: $(date)"
	echo -e "* Menu: $*"
	echo -e "************************************************************************\n"
}

SelectMySQL(){
#
# Retorna um select em forma de lista simples cabeçalho e linhas da tabela
#
	mysql -h ${DB_SERVIDOR} -P ${DB_PORTA} -u ${DB_USUARIO} -p${DB_SENHA} -D ${DB_BANCO} -B -N -e "$1"
	return $?
}

ListMySQL(){
#
# Retorna um select em forma de tabela, com cabecalho e linhas
#
	mysql -h ${DB_SERVIDOR} -P ${DB_PORTA} -u ${DB_USUARIO} -p${DB_SENHA} -D ${DB_BANCO} -t -e "$1"
	return $?
}

UpdateMySQL(){
        mysql -h ${DB_SERVIDOR} -P ${DB_PORTA} -u ${DB_USUARIO} -p${DB_SENHA} -D ${DB_BANCO} -e "$1"
        return $?
}

InsertMySQL(){
	mysql -h ${DB_SERVIDOR} -P ${DB_PORTA} -u ${DB_USUARIO} -p${DB_SENHA} -D ${DB_BANCO} -e "$1"
	return $?
}

InsertRetIDMySQL(){
	mysql -h ${DB_SERVIDOR} -P ${DB_PORTA} -u ${DB_USUARIO} -p${DB_SENHA} -D ${DB_BANCO} -B -N -e "$1;select LAST_INSERT_ID()"
	return $?
}

DeleteMySQL(){
	mysql -h ${DB_SERVIDOR} -P ${DB_PORTA} -u ${DB_USUARIO} -p${DB_SENHA} -D ${DB_BANCO} -e "$1"
	return $?
}
