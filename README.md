## Boa Vista - Desafio Técnico (Data Engineer)

O objetivo desse projeto é apresentar para os avaliadores a solução proposta para o desafio técnico (Engenheiro de Dados).

Nesse desafio, o foco será o de modelar de forma eficaz os dados fornecidos, criar a infraestrutura e os artefatos necessários para carregar os arquivos e apresentar os resultados através de um dashboard.

#### Pré-requisitos

* Python 3
* [GCP SDK](https://cloud.google.com/sdk/docs/install?hl=it)
* informar a variável do sistema GCP_ACCOUNT

#### Diretórios

* src/.private/ - armazena o arquivo de credenciais gerado automaticamente
* src/raw_data/tables - armazena os CSVs
* src/raw_data/schemas - armazena os schemas
* src/raw/views - armazena as views materializadas que alimentam os dashboards
* env/ - diretório criado pelo virtualenv contendo as bibliotecas python
* src/- código python (pipeline)
* src/config - arquivo de configuração (gerado automaticamente)
* dashboards/ - dashboards gerados pelo data studio no formato pdf, para eventuais problemas com o link de acesso.

#### Modelagem Conceitual:

De acordo com a documentação do GCP,  JOINs são possíveis com o BigQuery e, às vezes, recomendados em tabelas pequenas. No entanto, eles normalmente não têm um desempenho tão bom quanto as estruturas desnormalizadas.

Devido a esse fato, a abordagem escolhida para a modelagem será a de views materializadas desnormalizadas (uma view para cada dashboard).

#### IaC (infrastructure as a code)

Inicialmente considerei a possibilidade de utilizar o **terraform** para o deploy dos artefatos, entretanto, após pensar um pouco decidi utilizar comandos gcloud no shell script, e dessa forma manter a solução simples (KISS principle) e customizada de acordo com as minhas necessidades. Além disso, a solução foi construida tendo como premissa que toda a sua execução fosse realizada através de uma única linha de comando, algo que seria inviável ao optar pelo terraforms.

Os arquivos responsáveis pelo IaC são:

* create_enviroment.sh
* destroy_enviroment.sh

#### Execução

Com o SDK instalado, precisaremos informar ao sistema qual o e-mail vinculado a sua conta no GCP, para isso, será utilizado a variável de sistema ***GCP_ACCOUNT.***

***O preenchimento dessa variável é obrigatório, sem ela o sistema não será executado***.

Execute o comando abaixo, substituindo o email proposto pelo email vinculado a sua conta do GCP.

```
export GCP_ACCOUNT = "username@domain.com"
```

em seguida, execute no console os comandos abaixo para montar o ambiente no GCP e executar o pipeline:

```
git clone https://github.com/daniel-dqsdatalabs/boa_vista_gcp
cd gcp

./create_enviroment.sh
```

Após realizar os testes e validação da solução, é possível remover todos os artefatos criados da sua conta no GCP de forma automática, através do comando abaixo:

```
./destroy_enviroment.sh
```

Os logs da operação podem ser visualizados no arquivo **resultado.log** localizado no diretório src\

### Dashboards

Os dashboards criados podem ser consultados nos seguintes links:

[Non-Bracket Pricing - Supplier Analysis](https://datastudio.google.com/s/uxA37HMC0iU)

[Bracket Pricing - Supplier Analysis](https://datastudio.google.com/s/qTtEuiOdBAY)

[Materials- Consumption Analysis](https://datastudio.google.com/s/vj3reK-GUuA)

Obrigado!
