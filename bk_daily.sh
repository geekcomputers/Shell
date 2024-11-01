#!/bin/bash
##
#####   NOME:                           rotina_backup_diario.sh
#####   VERSÃO:                         0.1
#####   DESCRIÇÃO:                      Implementação rotina de backup diario com arquivos modificados#####   DATA DA CRIAÇÃO:                14/06/2023
#####   ATUALIZADO EM:                  18/08/2023
#####   ESCRITO POR:                    Natan Ogliari
#####   E-MAIL:                         natanogliari@gmail.com
#####   DISTRO:                         Ubuntu GNU/Linux 22.04
#####   LICENÇA:                        MIT license
#####   PROJETO:                        https://github.com/OgliariNatan/servidor-file-samba4
#########################Torne o script executável ##########
## chmod +x novo_script
##############################
## Script idealizado para manter uma política de backup dos arquivos
## compartilhados no Servidor de Arquivos.
##
## A linha mais abaixo é uma maneira otimizada de backup, pois realiza
## a compactação dos arquivos compartilhados e já os coloca na pasta
## montada referente ao servidor de backup.
##
## Opção: [v] exibe o progresso, [p] mantem as permissões
echo -e "Inicializado o backup diario" $(date +%d%m%y) >> /home/servidor/samba/conf/log/log.bk_diario

# Data de ontem
DATA=$(date -d "yesterday" '+%Y-%m-%d')

# Criar o backup apenas dos arquivos modificados no dia anterior

find /home/servidor/samba/data/compartilhados -type f -newermt "$DATA" -print0 | tar --null -czvf /home/servidor/samba/bk_diario/$(date -d "yesterday" +%d%m%y)_backup_diario.tar.gz --files-from=-
#Remove arquivos antigos

echo -e "Removendo o arquivo\t" $(find /home/servidor/samba/bk_diario/ -mtime +7) >> /home/servidor/samba/conf/log/log.bk_diario

rm $(find /home/servidor/samba/bk_diario/ -mtime +7)


echo -e "Finalizado o backup diario\n" >> /home/servidor/samba/conf/log/log.bk_diario
echo -e "################################"
