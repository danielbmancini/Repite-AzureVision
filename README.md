# Repite-AzureVision

Neste projeto, utiliza-se **Azure Computer Vision** + **VertexAI (gcloud)** para resolver problemas escriturários, como o preenchimento de planilhas de cartões-pontos de funcionários, documentos que registram as entradas e saídas dos empregados.

## **Inicialização**
Para as classes Python, é necessário um ambiente _myenv_ com os requisitos instaláveis. 

Instale os requisitos com o comando:

```bash
pip install -r requirements.txt
```

## **pontos-de-funcionário**
Aqui, tomamos as fotos dos pontos manuscritos dentro da pasta `pontos` e, com algumas suposições de estrutura, utilizamos apenas processamento de texto local (com _awk_ e _sed_) para processar o _output_ cru da **Azure**.

Para começar, use o script shell/bash `parse.sh` como:

```bash
chmod +x parse.sh
./parse.sh <arquivo>
```

São necessárias as chaves **Azure** `AI_SERVICE_KEY` e `AI_SERVICE_ENDPOINT` no arquivo de ambiente `.env`, que deve ser salvo na raiz do projeto.

------

Após executar esse script, os pontos serão salvos no arquivo `fin4pontos.txt`. A classe **excel4.py** insere esses dados em uma planilha no formato igual ao `modelo.xlsx`.

Uso de **excel4.py**:

```bash
source ../myenv/bin/activate
python excel4.py (dia do mês para colar a partir) (nome arquivo) (nome da folha MODELO) (nome funcionário)
```

-----
## **processando-documentos-impressos**

### Processamento de documentos impressos em má forma (neste caso e-mail)

#### Exemplo
> _Nota:_ Todos os exemplos de e-mail contêm informações puramente fictícias.

- [Documento exemplo](./processando-documentos-impressos/emails/julianaalmeida.jpeg) ➡️ [Preview do CSV](./processando-documentos-impressos/empresas.csv)


O script `email.sh` processa os documentos na pasta `emails` e, de acordo com o prompt, extrai informações como CNPJ e cadastro em sistema para concatená-los em um arquivo `.csv`, que pode ser aberto nativamente em uma planilha Excel, por exemplo.

O programa chama o ROC da Azure e envia os dados para o VertexAI para um processamento em nuvem rápido, e finalmente salva o conteúdo em `empresas.csv`.
