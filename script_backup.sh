#!/bin/bash

#? Definindo as variaveis para utilizar no script

DATE=$(date +%d-%m-%Y-%Hh-%Mm)          #? Informa a data no instante que o script será rodado 
PASTA_BACKUP_INPUT="$HOME/.pastasparabackup.txt"    #? Informa as pastas que serão "backupiadas" ou seja, as pastas que serão salvas
LOCAL_FILE_SAVE="$HOME/Backup/snapshots/backup-${DATE}.tar.gz" #? Informa o local em que será salvo o arquivo de backup + o nome do arquivo
LOCAL_DIRETORIO="$HOME/Backup/snapshots" #? Pasta onde serão salvo os backups
NUMBER_OF_FILES_BACKUP=$(ls $LOCAL_DIRETORIO | wc -l) #? Informa a quantidade de backups que estão salvos na pasta
DIFERENCA=$(expr 6 - $NUMBER_OF_FILES_BACKUP) #? Informa a diferença entre a quantidade de backups (menos) - 5 (Valor que defini como excesso de backup) se

limpezabackups()        #? Bloco para limpar o excesso de backups
{
    if [ $NUMBER_OF_FILES_BACKUP -gt 5 ]        #? Se o numero de backups salvos no diretorio foi mais que 5...
    then
        cd $LOCAL_DIRETORIO && ls -1 -t | tail $DIFERENCA | xargs rm #? Entre no local do diretorio e apague o excesso de backup.
    fi
}

compress()      #? Bloco para compactar os backups
{
    if [ ! -d $LOCAL_DIRETORIO ]    #? Checaguem se o diretorio de backups existe. se não...
    then
        mkdir $LOCAL_DIRETORIO #? Faça o diretorio
    fi
    
    if [ ! -f $PASTA_BACKUP_INPUT]
    then
        touch $PASTA_BACKUP_INPUT
    fi

    cd $HOME
    clear
    echo -e "\t\t\t\tItens salvos"
    if tar -czvf $LOCAL_FILE_SAVE -T $PASTA_BACKUP_INPUT        #? Compacta as pastas que foram escolhidas para serem salvas num unico arquivo tar.gz.
    then
        echo -e "\n\t\t\t\tBackup feito"
    else
        echo "Backup incompleto (erro)"
        exit 1
    fi
}

echo -e "-------------------------------------------------------------------------------"
echo -e "                            Digite a opção desejada                            "
echo -e "1. Fazer backup"
echo -e "2. Apagar excesso de backup"
echo -e "3. Completo (Limpeza + Backup)"
echo -e "-------------------------------------------------------------------------------"
printf "Digite a opção desejada: " 
read -r opcao       #? Receba a opção desejada

case $opcao in      #? Execute x de acordo com a opção desejada
1) compress ;;
2) limpezabackups ;;
3) limpezabackups && compress ;;
esac

