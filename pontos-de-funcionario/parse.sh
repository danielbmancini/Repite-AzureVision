#!/bin/bash

#exportar variaveis de sistema AI_SERVICE_KEY e AI_SERVICE_ENDPOINT (redatado)
#criar .env com as suas variáveis da Azure
set -a
. ../.env
set +a

#./parse.sh <arquivo>
source ../myenv/bin/activate

#ler arquivo e cortar primeiras 40 linhas, remover espaços e transfomar patterns do tipo ddcdd em dd:dd
python ../read-text.py "$1" | 
    #remover primeiras 40 linhas de bloat (induzido)
    tail -n +40 |
    #remover espaços
    sed 's/ //g' |
    #remover datas (indicadores no papel)
    sed -E 's/[0-9]{2}\/[0-9]{2}//g' |
    #reparar patterns do tipo ddddd, quando o ROC confunder ':' por um digito, vírgula ou ponto
    sed -E 's/^([0-9]{2})([0-9]{1}|.|,)([0-9]{2})$/\1:\3/'|
    #capturar patterns do tipo dddd
    sed 's/\([0-9][0-9]\)\([0-9][0-9]\)/\1:\2/' |
    #folgas e feriados -> 00:00. Padrões induzidos
    sed -E 's/[Ff][Oo][Ll]|[Ii][Aa][Dd][Oo]|[Ff][Ee][Rr][Ii][Aa][Ss]|[Ff][Oo]|[Gg][Aa]|[Ff][Ee][Rr]|[Dd][Ee][Ss]|[Cc][Aa][Nn]/00:00/' |
    #tomar horários para processamento em outra classe
    grep -o "[0-9][0-9]:[0-9][0-9]" > output.txt

#limpar fin4pontos
echo "" > fin4pontos.txt

#remover 00:00 se ocorrer na primeira linha (debug)
awk 'NR==1 && $0=="00:00" {next} 1' output.txt > temp.txt && mv temp.txt output.txt

#output.txt contém os tempos em linhas diferentes. Esta classe irá separá-las em dias diferentes e salvar em fin4pontos.txt.
./organizar.awk output.txt



