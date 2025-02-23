#!/bin/bash

# HomeServerStart
# Versão: 1.0
# Descrição: Script para configuração automatizada de um servidor caseiro baseado em Ubuntu
# Este script instala e configura apenas programas que funcionam em linha de comando (CLI)
# Autor: Seu Nome
# Data: $(date +%Y-%m-%d)

# Definir strict mode para bash
# Isso ajuda a pegar erros e falhas mais rapidamente
set -euo pipefail
IFS=$'\n\t'

# Verificar se está rodando como root
if [[ $EUID -ne 0 ]]; then
   echo "Este script precisa ser executado como root (sudo)" 
   exit 1
fi

# Função para log com timestamp
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Função para verificar erro após execução de comandos
check_error() {
    if [ $? -ne 0 ]; then
        log "ERRO: Falha ao executar $1"
        exit 1
    fi
}

# Função para fazer backup de arquivos de configuração
backup_config() {
    local file=$1
    if [ -f "$file" ]; then
        cp "$file" "${file}.bak.$(date +%Y%m%d_%H%M%S)"
        check_error "backup do arquivo $file"
    fi
}

# Função para perguntar ao usuário se deseja instalar um pacote
# Inclui descrição detalhada de cada programa
ask_install() {
    local name=$1
    local package=$2
    local description=$3
    local config_cmd=${4:-""}
    
    echo -e "\n=== $name ==="
    echo -e "$description\n"
    
    while true; do
        read -rp "Deseja instalar $name? (y/n): " response
        case $response in
            [Yy])
                log "Instalando $name..."
                apt install -y "$package"
                check_error "instalação de $package"
                
                if [ -n "$config_cmd" ]; then
                    log "Configurando $name..."
                    eval "$config_cmd"
                    check_error "configuração de $package"
                fi
                break
                ;;
            [Nn])
                log "Pulando instalação de $name"
                break
                ;;
            *)
                echo "Por favor, responda y ou n."
                ;;
        esac
    done
}

# Verificar conexão com internet antes de começar
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    log "ERRO: Sem conexão com a internet"
    exit 1
fi

# Criar diretório para logs
LOG_DIR="/var/log/homeserverstart"
mkdir -p "$LOG_DIR"
check_error "criação do diretório de log"

# Atualizar a lista de pacotes
log "Atualizando lista de pacotes..."
apt update && apt upgrade -y
check_error "atualização do sistema"

# === SERVIÇOS PRINCIPAIS ===

# Servidor FTP
ask_install "vsftpd" "vsftpd" \
    "Servidor FTP seguro e estável para transferência de arquivos.
    - Suporte a SSL/TLS para transferências seguras
    - Controle de acesso por usuário
    - Configuração padrão focada em segurança" \
    'backup_config "/etc/vsftpd.conf"
    echo "anonymous_enable=NO
    local_enable=YES
    write_enable=YES
    ssl_enable=YES
    allow_anon_ssl=NO
    force_local_data_ssl=YES
    force_local_logins_ssl=YES" >> /etc/vsftpd.conf
    systemctl enable vsftpd
    systemctl restart vsftpd'

# Servidor SSH
ask_install "OpenSSH Server" "openssh-server" \
    "Servidor SSH para acesso remoto seguro.
    - Acesso remoto criptografado ao servidor
    - Transferência segura de arquivos via SCP
    - Configuração padrão com autenticação por chave" \
    'backup_config "/etc/ssh/sshd_config"
    echo "PermitRootLogin no
    PasswordAuthentication no
    X11Forwarding no" >> /etc/ssh/sshd_config
    systemctl enable ssh
    systemctl restart ssh'

# Git
ask_install "Git" "git" \
    "Sistema de controle de versão distribuído.
    - Controle de versão de arquivos e projetos
    - Trabalho colaborativo
    - Histórico completo de alterações" \
    'git config --system core.fileMode true
    git config --system core.autocrlf input'

# === SERVIÇOS WEB ===

# Apache
ask_install "Apache" "apache2" \
    "Servidor web mais popular do mundo.
    - Hospedagem de sites e aplicações web
    - Suporte a virtual hosts
    - Módulos extensíveis" \
    'backup_config "/etc/apache2/conf-available/security.conf"
    echo "ServerTokens Prod
    ServerSignature Off
    TraceEnable Off" >> /etc/apache2/conf-available/security.conf
    a2enconf security
    systemctl enable apache2
    systemctl restart apache2'

# MySQL
ask_install "MySQL Server" "mysql-server" \
    "Sistema de gerenciamento de banco de dados.
    - Armazenamento estruturado de dados
    - Suporte a múltiplos bancos
    - Interface via linha de comando" \
    'systemctl enable mysql
    mysql_secure_installation'

# === FERRAMENTAS DE MONITORAMENTO ===

# Monitoramento de Sistema
ask_install "HTOP" "htop" \
    "Monitor de processos interativo.
    - Visualização detalhada de processos
    - Interface interativa no terminal
    - Monitoramento de CPU e memória"

ask_install "Glances" "glances" \
    "Monitor de sistema avançado em Python.
    - Monitoramento completo do sistema
    - Suporte a plugins
    - Interface web opcional"

# Monitoramento de Rede
ask_install "Iftop" "iftop" \
    "Monitor de banda em tempo real.
    - Visualização do uso de banda por conexão
    - Estatísticas de tráfego
    - Filtros por host/porta"

ask_install "Nload" "nload" \
    "Monitor de tráfego de rede.
    - Gráficos de download/upload
    - Médias de uso
    - Múltiplas interfaces"

ask_install "IPTraf" "iptraf" \
    "Analisador de tráfego IP.
    - Estatísticas detalhadas de rede
    - Monitoramento por interface
    - Logs de tráfego"

ask_install "Nethogs" "nethogs" \
    "Monitor de banda por processo.
    - Uso de rede por aplicação
    - Atualização em tempo real
    - Classificação por consumo"

ask_install "Tcpdump" "tcpdump" \
    "Analisador de pacotes de rede.
    - Captura de pacotes em tempo real
    - Filtros avançados
    - Análise detalhada do tráfego"

# === FERRAMENTAS UTILITÁRIAS ===

# Editores
ask_install "Nano" "nano" \
    "Editor de texto simples e intuitivo.
    - Interface amigável
    - Destaque de sintaxe
    - Atalhos intuitivos"

# Ferramentas de Rede
ask_install "Curl" "curl" \
    "Ferramenta para transferência de dados.
    - Suporte a múltiplos protocolos
    - Testes de API
    - Downloads via linha de comando"

ask_install "Wget" "wget" \
    "Ferramenta de download via linha de comando.
    - Downloads recursivos
    - Suporte a múltiplos protocolos
    - Retomada de downloads"

ask_install "Net-Tools" "net-tools" \
    "Conjunto de ferramentas de rede.
    - Comandos ifconfig, netstat, route
    - Diagnóstico de rede
    - Configuração de interfaces"

# Ferramentas de Backup e Compressão
ask_install "Rsync" "rsync" \
    "Ferramenta de sincronização de arquivos.
    - Backup incremental
    - Sincronização remota
    - Preservação de atributos"

ask_install "Zip/Unzip" "zip unzip" \
    "Ferramentas de compressão/descompressão.
    - Compactação de arquivos
    - Suporte a senhas
    - Preservação de permissões"

# Criar arquivo de log final
log "Instalação concluída com sucesso!"
echo "Um log detalhado está disponível em $LOG_DIR"
echo "
=== HomeServerStart ===
Instalação concluída! Seu servidor está configurado com as ferramentas selecionadas.
Recomendamos verificar as configurações de cada serviço instalado.
Para suporte ou mais informações, consulte a documentação de cada ferramenta.
"
