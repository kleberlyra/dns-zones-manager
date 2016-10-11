#!/bin/bash

source definicoes.sh
source funcoes.sh

TotalRange() {
        SelectMySQL "select count(id) from rangeaddr"
}

TotalRangeAtivo() {
        SelectMySQL "select count(id) from rangeaddr where ativo='S' "
}

ListarRange(){
        echo -e "Ranges Cadastrados\n"
        ListMySQL "select r.*,o.nome as 'nome da operadora' from rangeaddr r inner join operadora o on o.id=r.operadora"
	echo "Total de Ranges Cadastrados: " $(TotalRange)
	echo -e "Total de Ranges Ativos: $(TotalRangeAtivo)\n"
}

ListarOperadoraRange(){
        echo -e "Operadoras Cadastradas\n"
        ListMySQL "select * from operadora"
}

ListarIPsRange(){
	# $1 id range, se 0 lista tudo
	# $2 ativo

	[ $1 -eq 0 ] && WHERE1=" 1=1 " || WHERE1=" i.rangeaddr=$1 "

	case "$2" in
		"S") WHERE2=" i.ativo='S' " ;;
		"N") WHERE2=" i.ativo='N' " ;;
		*) WHERE2=" 1=1 ";;
	esac

	echo -e "IPs Cadastrados\n"
	#echo "pager more; \
	ListMySQL "pager more; \
		   select i.id,o.nome as operadora,i.ip,concat(r.alias,'-',i.ip) as 'ip alias', \
                          i.ativo from iprange i \
                   inner join rangeaddr r on r.id=i.rangeaddr \
                   inner join operadora o on o.id=r.operadora \
		   where ${WHERE1} and ${WHERE2};" | more -d -10
	Pause
}

AtivarIP(){
	Cabeçalho "Range - Ativa/Desativa IP"
	ListarRange
	read -p "Informe o ID do range do qual deseja desativar o IP: " RANGEADDR
	ListarIPsRange $RANGEADDR '*'
	read -p "Informe o ID do IP que deseja Ativar/Desativar: " IP
	read -e -i "S" -p "Informe 'S' para ativar e 'N' para desativar o IP [S/N]: " ATIVO
	read -e -i "N" -p "Confirma mudança no IP de ID \"${IP}\"? [S/N]: " CONFIRMA
	case ${CONFIRMA} in
		"S"|"s") UpdateMySQL "update iprange set ativo='${ATIVO}' where id=${IP};"
			[ $? ] && Pause "Atualização realizada com sucesso...." || Pause "Erro ao atualizar registro...";;
		*) Pause "Operação cancelada...";;
	esac
}

InjetarIPsRange(){
	# $1 NETADDRESS
	# $2 CIDR
	# $3 NETADDRESS ID
	LISTAIP=$(prips ${1}/${2} |  tail -n +2 | head -n -1)
	for IP in $LISTAIP; do
		InsertMySQL "insert into iprange (rangeaddr,ip) values (${3},'${IP}');"
	done
}

InserirRange(){
	Cabecalho "Range - inserir"
	ListarOperadoraRange
	ListarRange
        read -p "Id da Operadora: " OPERADORA
	read -p "Alias (5 posicoes): " ALIAS
	read -p "Endereco de rede: " NETADDRESS
	read -p "CIDR (Ex. 24): " CIDR
        read -e -i "S" -p "Confirma inclusao deste range (S/n) ? " CONFIRMA
        case ${CONFIRMA} in
                S|s) IDRANGE=$(InsertRetIDMySQL "insert into rangeaddr (alias,netaddress,operadora,cidr) values (\"${ALIAS}\",\"${NETADDRESS}\", \"${OPERADORA}\",\"${CIDR}\");")
                        if [ $? ]; then
				echo -e "Novo range cadastrado com sucesso...\nGerando lista de ips..."
				InjetarIPsRange ${NETADDRESS} ${CIDR} ${IDRANGE}
			else
				Pause "Erro ao inserir o novo range..."
			fi;;
                *) Pause "Operacao cancelada..."
        esac
}

ExcluirRange(){
	Cabecalho "Range - Excluir"
	ListarRange
        read -p "Informe o Id do range que deseja excluir: " RANGE
        read -e -i "S" -p "Confirma exclusao do range \"${RANGE}\" (S/n) ? " CONFIRMA
        case ${CONFIRMA} in
                S|s) DeleteMySQL "delete from rangeaddr where id=${RANGE}";
                        [ $? ] && Pause "Range excluido com sucesso..." || Pause "Erro ao excluir o range...";;
                *) Pause "Operacao cancelada..."
        esac
}

MenuRange(){
        Cabecalho "Range - Principal"
	echo "Total de Ranges Cadastrados: " $(TotalRange)
	echo "Total de Ranges Ativos: " $(TotalRangeAtivo)
        echo -e "\n1 - Listar Ranges\n2 - Inserir Range\n3 - Excluir Range\n4 - Listar IPs\n5 - Ativa/Desativa IP\n0 - Sair\n"
        read -p "Escolha uma das opcoes: " OPCAO

        case ${OPCAO} in
                1) clear;Cabecalho "Range - Listagem"; ListarRange;Pause;;
                2) clear;InserirRange;;
                3) clear;ExcluirRange;;
		4) clear;Cabecalho "Range - Listagem de IPs"; ListarIPsRange 0 '*';;
                5) clear;AtivarIP;;
                0) return 0;;
        esac
        MenuRange
}

MenuRange
#InjetarIPsRange "200.242.91.128" "26"
