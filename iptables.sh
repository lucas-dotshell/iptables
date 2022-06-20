#!/bin/sh
# @(#) iptables.sh - Script for config firewall with iptables
setterm -foreground green
echo "################# github.com/lucas-dotshell ##################"
echo ""

# Definindo intervalo de endereço ip para acesso SSH
SSH_ALLOWED_RANGE="192.168.10.100-192.168.10.110"
# Definindo rede interna
INTERNAL_NETWORK="192.168.10.0/24"

END_CONFIG(){
    # Bloquear todas as outras portas e sair
    iptables -A INPUT -j DROP
    iptables -A OUTPUT -j DROP
    setterm -foreground green
    echo "You have successfully! ${1} server configured"
    setterm -foreground white
    exit
}

# Resetando regras do firewall
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

# Definindo novas regras do firewall
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitindo acesso via SSH para SSH_ALLOWED_RANGE
setterm -foreground yellow
echo "Allowing SSH to IT staff on this server..."
iptables -A INPUT -p tcp -m iprange --src-range ${SSH_ALLOWED_RANGE} --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --src-range ${SSH_ALLOWED_RANGE} --sport 22 -j ACCEPT
echo "Done!"

# Permitindo acesso via HHTP para a rede interna
echo "Allowing HTTP from the internal network..."
iptables -A INPUT -p tcp -s ${INTERNAL_NETWORK} --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -s ${INTERNAL_NETWORK} --sport 80 -j ACCEPT
echo "Done!"

# Pergunte o tipo do servidor que está rodando o script
setterm -foreground cyan
echo "Is this your MAIL server? [Yes: y | No: Any key ]"
read EMAIL_SERVER
if [ ${EMAIL_SERVER} = "y" ]; then
    # Servidor de email
    iptables -A INPUT -p tcp --dport 587 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 587 -j ACCEPT
    END_CONFIG "MAIL"
fi

echo "Is this your DNS server? [Yes: y | No: Any key ]"
read DNS_SERVER
if [ ${DNS_SERVER} = "y" ]; then
    # Servidor DNS
    iptables -A INPUT -p tcp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT
    END_CONFIG "DNS"
fi

echo "Is this your HTTP server? [Yes: y | No: Any key ]"
read HTTP_SERVER
if [ ${HTTP_SERVER} = "y" ]; then
    # Servidor HTTP
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
    END_CONFIG "HTTP"
else
    setterm -foreground red
    echo "Ivalid options"
    setterm -foreground white
    exit
fi
