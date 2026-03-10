# Projeto DBMG - Gerenciamento de Tarefas

Este projeto consiste em uma **API em Delphi (Horse + FireDAC)** e um **cliente VCL** que consome a API via REST para gerenciar tarefas.

## Ambiente de Desenvolvimento
- Delphi: 12 Alexandria
- Biblioteca Horse: instalada via Boss (última versão estável)
- Banco de dados: SQL Server 2019 (X64)
- FireDAC para conexão com SQL Server

## Estrutura do Projeto
Projetos\DBMG
├── Bin -> Executáveis
├── Units\api-horse -> Units da API (controller, connection)
├── Units\client -> Units do cliente VCL
├── DBMG_Create.sql -> Script para criar o banco e tabela
├── README.md -> Este arquivo

## Pré-requisitos

- Delphi 10.x ou superior
- SQL Server (Local ou remoto)
- FireDAC configurado para SQL Server
- Conexão de rede entre cliente e API (mesma máquina ou IP acessível)

## Como rodar a API

1. Execute o script `DBMG_Create.sql` no SQL Server para criar o banco e a tabela `Tarefas` e mova para ..\\DBMG\DB.
2. Abra o projeto `ProjetoDBMG` (console application) no Delphi.
3. Ajuste as credenciais no `connection.factory.pas` (usuário, senha ou autenticação Windows que já está configurado).
4. Compile e execute a API.  
   A API irá escutar por padrão na porta `9000`.

## Como rodar o Cliente VCL

1. Abra o projeto `ProjetoDBMGClient` no Delphi.
2. Ajuste a URL base do RESTRequest, se necessário, para `http://localhost:9000/`.
3. Compile e execute o cliente.
4. Utilize os botões para:
   - Adicionar tarefa
   - Concluir tarefa
   - Excluir tarefa
   - Visualizar estatísticas

## Observações

- As validações do cliente incluem:
  - Título, descrição e prioridade obrigatórios
  - Prioridade deve estar entre 1 e 5
  - Cancelar qualquer input interrompe a operação
- API retorna JSON padrão:
  ```json
  [
    {
      "id": "1",
      "titulo": "API",
      "descricao": "Desenvolvimento API",
      "prioridade": "5",
      "status": "Pendente"
    }
  ]
