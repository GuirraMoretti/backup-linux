#!/bin/bash

#? Definindo as variaveis para utilizar no script
DATE=$(date +%d-%m-%Y-%Hh-%Mm)          #? Informa a data no instante que o script foi rodado
PASTA_BACKUP_INPUT="$HOME/.pastasparabackup.txt"    #? Informa as pastas que serão "backupeadas" ou seja, as pastas que serão salvas
LOCAL_FILE_SAVE="$HOME/HDD/Backups_ZIP/backup-${DATE}.tar.gz" #? Informa o local em que será salvo o arquivo de backup + o nome do arquivo
LOCAL_DIRETORIO="$HOME/HDD/Backups_ZIP" #? Pasta onde serão salvo os backups
NUMBER_OF_FILES_BACKUP=$(ls $LOCAL_DIRETORIO | wc -l) #? Informa a quantidade de backups que estão salvos na pasta
DIFERENCA=$(expr 5 - $NUMBER_OF_FILES_BACKUP) #? Informa a diferença entre a quantidade de backups (menos) - 5 (Valor que defini como excesso de backup) se
limpezabackups()        #? Bloco para limpar o excesso de backups
{
    if [ $NUMBER_OF_FILES_BACKUP -gt 5 ]        #? Se o numero de backups salvos no diretorio foi mais que 5...
    then
        cd $LOCAL_DIRETORIO && ls -1 -t | tail $DIFERENCA | xargs rm -f #? Entre no local do diretorio e apague o excesso de backup.
    fi
}
compress()      #? Bloco para compactar os backups
{
    if [[ ! -d $LOCAL_DIRETORIO && ! -e $PASTA_BACKUP_INPUT ]]
        then
        clear
        echo -e "Pasta de backup e/ou arquivo de configuração de pasta não existem."
        printf "Deseja recriar os arquivos? (s/n) "
        read -r opcao1
        case $opcao1 in
        s) criation && addfolders;;
        n) echo -e "Erro: Pasta para backup não encontrada" && return 1;;
        esac
    fi
    addfolders
    clear
    if tar -czvf "$LOCAL_FILE_SAVE" --exclude=/home/Guirra/HDD/Escola/Aulas -T <(sed 1,2d "$PASTA_BACKUP_INPUT")  #? Compacta as pastas que foram escolhidas para serem salvas num unico arquivo tar.gz.
    then
        echo -e "\n\t\t\t\tBackup feito"
    else
        echo "Backup incompleto (erro)"
        exit 1
    fi
}
addfolders()
{
    while ! tail -n +3 $PASTA_BACKUP_INPUT| grep -c -m1 -o /
    do
        clear
        echo -e "Insira o diretorio das pastas que deseja fazer backup."
        printf "Deseja abrir o editor de texto? (s/n)"
        read -r opcao2
            case $opcao2 in
                s) nano $PASTA_BACKUP_INPUT;;
                n) exit 1;;
            esac
    done
}
criation()
{
    if [[ ! -d $LOCAL_DIRETORIO && ! -e $PASTA_BACKUP_INPUT ]]
        then
            touch $PASTA_BACKUP_INPUT && mkdir $LOCAL_DIRETORIO
            echo -e "#Coloque o diretorio da pasta que será salva com o caminho COMPLETO.\n#Insira no seguinte modelo:/home/user/pasta" > $PASTA_BACKUP_INPUT
            echo -e "Arquivos criados com sucesso"
        else
            echo -e "Arquivos ja existem"
    fi
}   
menu()
{
clear
echo -e "-------------------------------------------------------------------------------"
echo -e "                            Digite a opção desejada                            "
echo -e "1. Fazer backup"
echo -e "2. Apagar excesso de backup"
echo -e "3. Completo (Limpeza + Backup)"
echo -e "4. Adicionar/Resetar pastas desejadas para backup"
echo -e "5. Editar configurações das pastas desejadas para backup"
echo -e "6. Sincronizar backups com o drive"
echo -e "-------------------------------------------------------------------------------"
printf "Digite a opção desejada: " 
read -r opcao       #? Receba a opção desejada

case $opcao in      #? Execute x de acordo com a opção desejada
1) compress ;;
2) limpezabackups ;;
3) limpezabackups && compress ;;
4) rm -f $PASTA_BACKUP_INPUT && rm -rf $LOCAL_DIRETORIO && criation;;
5) criation && nano $PASTA_BACKUP_INPUT;;
6) rclone sync -P $LOCAL_DIRETORIO gdrive:/Backup
esac
}
menu