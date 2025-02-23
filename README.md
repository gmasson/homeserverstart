# HomeServerStart
HomeServerStart é uma ferramenta que automatiza a instalação e configuração inicial de um servidor caseiro. O script foi desenvolvido para sistemas Ubuntu e foca exclusivamente em ferramentas que funcionam via linha de comando, tornando o servidor mais leve e eficiente.

## Características
- Instalação interativa (escolha quais programas instalar)
- Apenas ferramentas CLI (sem interface gráfica)
- Configurações de segurança pré-definidas
- Sistema de logs para rastreamento
- Backup automático de configurações
- Verificações de segurança e dependências

## Programas Disponíveis

### Serviços Principais
- **vsftpd**: Servidor FTP seguro
- **OpenSSH Server**: Acesso remoto seguro
- **Git**: Sistema de controle de versão

### Serviços Web
- **Apache**: Servidor web
- **MySQL**: Banco de dados

### Ferramentas de Monitoramento
- **HTOP**: Monitor de processos
- **Glances**: Monitor de sistema
- **Iftop**: Monitor de banda
- **Nload**: Monitor de tráfego
- **IPTraf**: Analisador de tráfego
- **Nethogs**: Monitor de banda por processo
- **Tcpdump**: Analisador de pacotes

### Utilitários
- **Nano**: Editor de texto
- **Curl**: Transferência de dados
- **Wget**: Downloads via CLI
- **Net-Tools**: Ferramentas de rede
- **Rsync**: Sincronização de arquivos
- **Zip/Unzip**: Compressão/descompressão

## Pré-requisitos
- Sistema Ubuntu (testado nas versões 20.04 e 22.04)
- Acesso root (sudo)
- Conexão com internet

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/gmasson/homeserverstart.git
```

2. Entre no diretório:
```bash
cd homeserverstart
```

3. Dê permissão de execução ao script:
```bash
chmod +x homeserverstart.sh
```

4. Execute o script:
```bash
sudo ./homeserverstart.sh
```

## Segurança
O script inclui várias medidas de segurança:

- Configurações seguras para FTP e SSH
- Firewall (UFW) pré-configurado
- Backups automáticos de configurações
- Verificações de integridade
- Logs detalhados

## Logs
Os logs são armazenados em `/var/log/homeserverstart/` e incluem:
- Programas instalados
- Configurações alteradas
- Erros encontrados
- Timestamp de todas as operações

## Importante
- Faça backup dos seus dados antes de executar
- Revise as configurações após a instalação
- Mantenha seu sistema atualizado
- Modifique senhas padrão

## Contribuindo
Contribuições são bem-vindas! Por favor, siga estes passos:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

## Licença
Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
