#!/bin/bash

DATE=$(date +%d-%m-%Y-%Hh-%Mm)
PASTA_BACKUP_INPUT="$HOME/.pastasparabackup.txt"
LOCAL_FILE_SAVE="$HOME/Backup/snapshots/backup-${DATE}.tar.gz"
LOCAL_DIRETORIO="$HOME/Backup/snapshots"
NUMBER_OF_FILES_BACKUP=$(ls $LOCAL_DIRETORIO | wc -l)
DIFERENCA=$(expr 6 - $NUMBER_OF_FILES_BACKUP)


limpezabackups()
{
    if [ $NUMBER_OF_FILES_BACKUP -gt 5 ]
    then
        cd $LOCAL_DIRETORIO && ls -1 -t | tail $DIFERENCA | xargs rm
    fi
}

compress()
{
    if [ ! -d $LOCAL_DIRETORIO ]
    then
        mkdir $LOCAL_DIRETORIO
    fi
    cd $HOME
    clear
    echo -e "\t\t\t\tItens salvos"
    if tar -czvf $LOCAL_FILE_SAVE -T $PASTA_BACKUP_INPUT
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
read -r opcao

case $opcao in
1) compress ;;
2) limpezabackups ;;
3) limpezabackups && compress ;;
esac

