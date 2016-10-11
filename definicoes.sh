#!/bin/bash
#
# variaveis globais
#

source /etc/os-release

#APLICACAO
INSTALACAO_BASE="/opt/dns-conf"
#DB_DIRETORIOS="$INSTALACAO_BASE/db_diretorios.csv"
DB_OPERADORA="$INSTALACAO_BASE/db_operadora.cvs"
DB_IP="$INSTALACAO_BASE/db_ip.cvs"
DB_SERVICO="$INSTALACAO_BASE/db_servico.cvs"
DB_DESIGNACAO="$INSTALACAO_BASE/db_designacao.cvs"

#BIND 
BIND_BASE="/etc/bind"
BIND_ZONAS="$BIND_BASE/zonas"
BIND_CHAVES="$BIND_BASE/chaves"

#VALORES PADRAO PARA ZONAS EM SEGUNDOS
SOA_TTL="604800"
SOA_REFRESH="604800"
SOA_RETRY="86400"
SOA_NEGATIVE="604800"

#BANCO
DB_SERVIDOR="localhost"
DB_PORTA="3306"
DB_USUARIO="root"
DB_SENHA="123456"
DB_BANCO="dnsconf"


VerificarRequisitosDebianUbuntu(){
	echo -n "Checando PRIPS...."; PRIPS=$(dpkg -l | grep "prips"); [ -z "${PRIPS}" ] && echo "Não Instalado" || echo "Instalado";
}

VerificarRequisitosRedHatCentosFedora(){
	echo -n "Checando PRIPS...."; PRIPS=$(rpm -qa | grep "prips"); [ -z "${PRIPS}" ] && echo "Não Instalado" || echo "Instalado";
}

TestarRequisitos(){
	case ${ID} in
		"debian"|"ubuntu"|"mint") VerificarRequisitosDebianUbuntu;;
		"redhat"|"centos"|"fedora") VerificarRequisitosRedHatCentosFedora;;
	esac
}

