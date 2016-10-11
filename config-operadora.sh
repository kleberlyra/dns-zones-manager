#!/bin/bash

source definicoes.sh
source funcoes.sh

TotalOperadoras() {
	SelectMySQL "select count(id) from operadora" 
}

TotalOperadorasAtivas() {
	SelectMySQL "select count(id) from operadora where ativo='S' "
}

ListarOperadoras(){
	echo -e "Operadoras Cadastradas\n"
	ListMySQL "select * from operadora"
}
InserirOperadora(){
	read -p "Nome da Operadora: " OPERADORA
	read -e -i "S" -p "Confirma inclusao da operadora \"${OPERADORA}\" (S/n) ? " CONFIRMA
	case ${CONFIRMA} in
		S|s) InsertMySQL "insert into operadora (nome) values (\"${OPERADORA}\");";
			[ $? ] && Pause "Nova operadora inserida com sucesso..." || Pause "Falha ao inserir a nova operadora";;
		*) Pause "Operacao cancelada..."
	esac
}
ExcluirOperadora(){
	read -p "Informe o Id da Operadora que deseja excluir: " OPERADORA
	read -e -i "S" -p "Confirma exclusao da operadora \"${OPERADORA}\" (S/n) ? " CONFIRMA
	case ${CONFIRMA} in
		S|s) DeleteMySQL "delete from operadora where id=${OPERADORA}";
			[ $? ] && Pause "Operadora excluida com sucesso..." || Pause "Erro ao excluir operadora...";;
		*) Pause "Operacao cancelada..."
	esac
}

MenuOperadora(){
	Cabecalho "Operadoras - Principal"
	echo Total de Operadoras: $(TotalOperadoras)
	echo Total de Operadoras Ativas: $(TotalOperadorasAtivas)
	echo -e "\n1 - Listar Operadoras\n2 - Inserir Operadora\n3 - Excluir Operadora\n0 - Sair\n"
	read -p "Escolha uma das opcoes: " OPCAO

	case ${OPCAO} in
		1) clear;ListarOperadoras;Pause;;
		2) clear;InserirOperadora;;
		3) clear;ListarOperadoras;ExcluirOperadora;;
		0) return 0;;
	esac
	MenuOperadora
}


MenuOperadora
