-- Cria banco de dados
CREATE DATABASE DBMG;
GO

USE DBMG;
GO

-- Cria tabela Tarefas
CREATE TABLE Tarefas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Titulo VARCHAR(200) NOT NULL,
    Descricao VARCHAR(500),
    Prioridade INT,
    Status VARCHAR(50),
    DataCriacao DATETIME DEFAULT GETDATE(),
    DataConclusao DATETIME
);
GO

INSERT INTO Tarefas (Titulo, Descricao, Prioridade)
VALUES 
('API Horse','Desenvolver API Horse',5),
('Client','Desenvolver Client para consumir API',4);
GO