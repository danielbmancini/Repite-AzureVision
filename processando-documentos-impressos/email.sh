#!/bin/bash


#Organizar e tratar dados de texto - emails na pasta emails
#uso: ./email.sh 
#Aplicar ROC na pasta, chamar sera.py e usar $instruct para organizar em cnpj,login e senha e o nome do arquivo de origem
#e colocar em empresas2.csv para confeccionar planilha

#criar .env com as suas variaveis da Azure
set -a
. ../.env
set +a

source ../myenv/bin/activate

#prompt
instruct=$(cat prompt)


for file in emails/*; do
    out=$(python ../read-text.py "$file" ) 
    #echo "$out" > "${file}.txt"
    if [ -n "$out" ]; then
    #tomar dados como pedido ao VertexAI e atrelar nome do arquivo de origem com awk
    python vertex.py "$out" "$instruct" | awk -v file="$(basename "$file")" '{print $0 "," file}' >> empresas.csv
    fi

done



