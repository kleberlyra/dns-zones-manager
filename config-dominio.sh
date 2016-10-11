#!/bin/bash

source definicoes.sh
source funcoes.sh

TotalDominio(){
        SelectMySQL "select count(id) from dominio"
}

TotalDominioAtivo(){
        SelectMySQL "select count(id) from dominio where ativo='S' "
}

ListarDominio(){
   echo -e "Dominios Cadastrados\n"
   ListMySQL "select * from dominio"
	echo "Total de Dominios Cadastrados: " $(TotalDominio)
	echo -e "Total de Dominios Ativos: $(TotalDominioAtivo)\n"
}

InserirDominio(){

	Cabecalho "Domínio - inserir"

   read -p "Domínio (Ex. teste.com.br), informe '0' para sair: " NOME
	([ "${NOME}" = "0" ] || [ -z "${NOME}" ]) && return 0

   read -p "Alias : " ALIAS
	echo "Dados Registro SOA"
	read -e -i "${SOA_TTL}"       -p "   TTL em segundos (Padrão ${SOA_TTL}): " TTL
	read -e -i "admin.${NOME}" 	-p "   Email do administrador do domínio (use . no lugar de @. Ex. admin.teste.com.br): " EMAIL
	read -e -i "${SOA_REFRESH}"  	-p "   Refresh em segundos (Padrão ${SOA_REFRESH}): " REFRESH
	read -e -i "${SOA_RETRY}"		-p "   Retry em segundos (Padrão ${SOA_RETRY}): " RETRY
	read -e -i "${SOA_NEGATIVE}"	-p "   Negative Cache TTL em segundos (Padrão ${SOA_NEGATIVE}): " NEGATIVE
	echo
   read -e -i "S" -p "Confirma inclusão deste domínio? [S/N]: " CONFIRMA
	case ${CONFIRMA} in
   	S|s) InsertMySQL "insert into dominio (nome,alias,ttl,email,refresh,retry,negative) 						 value ('${NOME}','${ALIAS}','${TTL}','${EMAIL}','${REFRESH}','${RETRY}','${NEGATIVE}');"
				if [ $? ]; then
					Pause "Novo domínio cadastrado com sucesso..."
				else
					Pause "Erro ao inserir o novo domínio..."
				fi;;
                *) Pause "Operacao cancelada..."
   esac
}

AlterarDominio(){

	Cabecalho "Domínio - alterar"
	[ $(TotalDominio) -eq 0 ] && (Pause "Não há domínios cadastrados para alterar..."; return 0)

	ListarDominio

	read -p "Informe o ID do domínio que deseja alterar, '0' para sair: " ID
	([ "${ID}" = "0" ] || [ -z "${ID}" ]) && return 0

	REG=($(SelectMySQL "select * from dominio where id='${ID}'"))
	NOME=${REG[1]}
	ALIAS=${REG[2]}
	TTL=${REG[3]}
	EMAIL=${REG[4]}
	REFRESH=${REG[5]}
	RETRY=${REG[6]}
	NEGATIVE=${REG[7]}
   read -e -i "${NOME}" -p "Domínio (Ex. teste.com.br): " NOME
   read -e -i "${ALIAS}" -p "Alias : " ALIAS
   echo "Dados Registro SOA"
   read -e -i "${TTL}"             -p "   TTL (Padrão ${SOA_TTL}): " TTL
   read -e -i "${EMAIL}"		-p "   Email do administrador do domínio (use . no lugar de @. Ex. admin.teste.com.br): " EMAIL
   read -e -i "${REFRESH}" 	-p "   Refresh (Padrão ${SOA_REFRESH}): " REFRESH
   read -e -i "${RETRY}" 		-p "   Retry (Padrão ${SOA_RETRY}): " RETRY
   read -e -i "${NEGATIVE}"        -p "   Negative Cache TTL (Padrão ${SOA_NEGATIVE}): " NEGATIVE
   echo
   read -e -i "S" -p "Confirma alteração deste domínio? [S/N]: " CONFIRMA
   case ${CONFIRMA} in
		S|s) UpdateMySQL "update dominio set nome='${NOME}',alias='${ALIAS}',ttl='${TTL}',email='${EMAIL}',refresh='${REFRESH}',retry='${RETRY}',negative='${NEGATIVE}' where id=${ID};"
      	if [ $? ]; then
            Pause "Domínio alterado com sucesso..."
         else
            Pause "Erro ao alterar os dados do domínio..."
         fi;;
      *) Pause "Operacao cancelada..."
	esac
}

ExcluirDominio(){
	Cabecalho "Dominio - Excluir"
	ListarDominio

        read -p "Informe o ID do domínio que deseja excluir, '0' para sair: " DOMINIO
	([ "${DOMINIO}" = "0" ] || [ -z "${DOMINIO}" ]) && return 0


        read -e -i "S" -p "Confirma exclusao do domínio \"${DOMINIO}\"? (S/N): " CONFIRMA
        case ${CONFIRMA} in
                S|s) DeleteMySQL "delete from dominio where id=${DOMINIO}";
                        [ $? ] && Pause "Dominio excluido com sucesso..." || Pause "Erro ao excluir o domínio...";;
                *) Pause "Operacao cancelada..."
        esac
}

MenuDominio(){
        Cabecalho "Domínio - Principal"
	echo "Total de Domínios Cadastrados: " $(TotalDominio)
	echo "Total de Domínios Ativos: " $(TotalDominioAtivo)
        echo -e "\n1 - Listar Domínios\n2 - Inserir Domínios\n3 - Excluir Domínio\n4 - Alterar Domínios\n0 - Sair\n"
        read -p "Escolha uma das opcoes: " OPCAO

        case ${OPCAO} in
                1) clear;Cabecalho "Domínio - Listagem"; ListarDominio;Pause;;
                2) clear;InserirDominio;;
                3) clear;ExcluirDominio;;
                4) clear;AlterarDominio;;
                0) return 0;;
        esac
        MenuDominio
}

MenuDominio
