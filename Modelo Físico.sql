CREATE DATABASE CONSTRUTORA
GO

USE CONSTRUTORA
GO

--Criação de Tabelas--------------------------------------------------------------------------------------------------
CREATE TABLE Clientes 
( 
 IdCliente INT PRIMARY KEY IDENTITY(1,1),
 Nome VARCHAR(30) NOT NULL,  
 Cpf CHAR(11) NOT NULL UNIQUE,
 DataNasc DATE NOT NULL,    
 Email VARCHAR(30) NOT NULL,  
 Telefone VARCHAR(15) NOT NULL,   
 Endereço VARCHAR(200)
)

CREATE TABLE Obras 
( 
 IdObra INT PRIMARY KEY IDENTITY(1,1),
 idCliente INT FOREIGN KEY (idCliente) REFERENCES Clientes(IdCliente),
 Nome VARCHAR(30) NOT NULL,  
 DataInicio DATE NOT NULL,  
 DataFim DATE NOT NULL,  
 StatusObra VARCHAR(30) NOT NULL CHECK (StatusObra = 'Iniciado' or StatusObra = 'Em andamento' or StatusObra = 'Concluido'),  
 Descrição VARCHAR(200) NOT NULL
)

CREATE TABLE Pessoas
( 
 IdPessoa INT PRIMARY KEY IDENTITY(1,1),  
 Nome VARCHAR(30) NOT NULL, 
 Cpf VARCHAR(11) NOT NULL UNIQUE,  
 DataNasc DATE NOT NULL,  
 Especialidades VARCHAR(200) NOT NULL,  
 ValorPorHora FLOAT NOT NULL,  
 Telefone VARCHAR(15) NOT NULL,  
 Email VARCHAR(30) NOT NULL
)

CREATE TABLE Etapas 
( 
 IdEtapa INT PRIMARY KEY IDENTITY(1,1), 
 idObra INT NOT NULL FOREIGN KEY(idObra) REFERENCES Obras(IdObra),
 Nome VARCHAR(30) NOT NULL, 
 Descrição VARCHAR(200) NOT NULL,  
 Andamento VARCHAR(200) NOT NULL,  
 DataFim DATE NOT NULL,  
 DataInicio DATE NOT NULL,
 Anexo VARCHAR(200) NOT NULL
)

CREATE TABLE PessoaEtapa 
( 
 IdPessoa INT FOREIGN KEY(IdPessoa) REFERENCES Pessoas(IdPessoa),
 IdEtapa INT FOREIGN KEY(IdEtapa) REFERENCES Etapas(IdEtapa),
 HorasExigidas INT NOT NULL,  
 HorasTrabalhadas INT NOT NULL,  
 ValorCobrado FLOAT NOT NULL,  
 PRIMARY KEY(IdPessoa, IdEtapa)
)

CREATE TABLE Materiais 
( 
 IdMaterial INT PRIMARY KEY IDENTITY(1,1),
 Nome VARCHAR(30) NOT NULL,  
 Descrição VARCHAR(200) NOT NULL,  
 Valor FLOAT NOT NULL
 )

CREATE TABLE MateriaisEtapa 
( 
 IdEtapa INT FOREIGN KEY (IdEtapa) REFERENCES Etapas(IdEtapa),  
 idMaterial INT FOREIGN KEY (idMaterial) REFERENCES Materiais(IdMaterial), 
 Quantidade INT NOT NULL,  
 Valor FLOAT NOT NULL,  
 PRIMARY KEY(IdEtapa, idMaterial)
)

CREATE TABLE Logs
(	
	IdLog INT PRIMARY KEY IDENTITY(1,1),
	Tabela VARCHAR(20),
	Id INT NOT NULL,
	IdSecundario INT,
	Acao VARCHAR(100) not null,
	DataHoraMudança DATETIME not null
)
GO


--Criação de INDEX--------------------------------------------------------------------------------------------------

CREATE NONCLUSTERED INDEX IDX_IdClienteCliente
ON Clientes(IdCliente)
CREATE NONCLUSTERED INDEX IDX_CpfCliente
ON Clientes(Cpf)
CREATE NONCLUSTERED INDEX IDX_EmailCliente
ON Clientes(Email)

CREATE NONCLUSTERED INDEX IDX_IdObras
ON Obras(IdObra)
CREATE NONCLUSTERED INDEX IDX_NomeObras
ON Obras(Nome)
CREATE INDEX IDX_IdClienteObras
ON Obras(IdCliente)

CREATE NONCLUSTERED INDEX IDX_IdPessoaPessoas
ON Pessoas(IdPessoa)
CREATE NONCLUSTERED INDEX IDX_CpfPessoas
ON Pessoas(Cpf)
CREATE NONCLUSTERED INDEX IDX_EmailPessoas
ON Pessoas(Email)

CREATE NONCLUSTERED INDEX IDX_IdEtapaEtapa
ON Etapas(IdEtapa)
CREATE NONCLUSTERED INDEX IDX_IdObraEtapa
ON Etapas(IdObra)
CREATE NONCLUSTERED INDEX IDX_NomeEtapa
ON Etapas(Nome)

CREATE NONCLUSTERED INDEX IDX_IdEtapaPessoaEtapa
ON PessoaEtapa (IdEtapa)
CREATE NONCLUSTERED INDEX IDX_IdPessoaPessoaEtapa
ON PessoaEtapa (IdPessoa)

CREATE NONCLUSTERED INDEX IDX_IdMaterialMaterial
ON Materiais(IdMaterial)
CREATE NONCLUSTERED INDEX IDX_NomeMaterial
ON Materiais(Nome)

CREATE NONCLUSTERED INDEX IDX_IdEtapaMateriaisEtapa
ON MateriaisEtapa(IdEtapa)
CREATE NONCLUSTERED INDEX IDX_IdMaterialMateriaisEtapa
ON MateriaisEtapa(IdMaterial)

CREATE NONCLUSTERED INDEX IDX_IdLogLogs
on Logs(IdLog)
CREATE NONCLUSTERED INDEX IDX_TabelaLogs
on Logs(Tabela)
GO
--Criação Triggers Insert---------------------------------------------------------------------------------------------

CREATE TRIGGER TriggerLogInsertedClientes
ON Clientes
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(8) = 'Clientes'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdCliente, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogInsertedEtapas
ON Etapas
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(6) = 'Etapas'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdEtapa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogInsertedMateriais
ON Materiais
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(9) = 'Materiais'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdMaterial, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogInsertedMateriaisEtapa
ON MateriaisEtapa
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(14) = 'MateriaisEtapa'

	INSERT INTO Logs (Id, IdSecundario, Acao, DataHoraMudança, Tabela) 
	SELECT i.idMaterial, i.IdEtapa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogInsertedObras
ON Obras
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(6) = 'Obras'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdObra, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogInsertedPessoaEtapa
ON PessoaEtapa
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(11) = 'PessoaEtapa'

	INSERT INTO Logs (Id, IdSecundario, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdPessoa, i.IdEtapa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogInsertedPessoas
ON Pessoas
AFTER INSERT
AS
BEGIN
	DECLARE @acao char(6) = 'INSERT'
	DECLARE @Tabela char(6) = 'Pessoas'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdPessoa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

--Triggers Delete------------------------------------------------------------------------------------------------------
CREATE TRIGGER TriggerLogDeletedClientes
ON Clientes
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(8) = 'Clientes'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdCliente, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO

CREATE TRIGGER TriggerLogDeletedEtapas
ON Etapas
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(6) = 'Etapas'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdEtapa, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO

CREATE TRIGGER TriggerLogDeletedMateriais
ON Materiais
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(9) = 'Materiais'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdMaterial, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO

CREATE TRIGGER TriggerLogDeletedMateriaisEtapa
ON MateriaisEtapa
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(14) = 'MateriaisEtapa'

	INSERT INTO Logs (Id, IdSecundario, Acao, DataHoraMudança, Tabela) 
	SELECT i.idMaterial, i.IdEtapa, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO

CREATE TRIGGER TriggerLogDeletedObras
ON Obras
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(6) = 'Obras'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdObra, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO

CREATE TRIGGER TriggerLogDeletedPessoaEtapa
ON PessoaEtapa
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(11) = 'PessoaEtapa'

	INSERT INTO Logs (Id, IdSecundario, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdPessoa, i.IdEtapa, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO

CREATE TRIGGER TriggerLogDeletedPessoas
ON Pessoas
AFTER DELETE
AS
BEGIN
	DECLARE @acao char(6) = 'DELETE'
	DECLARE @Tabela char(6) = 'Pessoas'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdPessoa, @acao, GETDATE(), @Tabela
	from deleted i
END;
GO
--Triggers Update-----------------------------------------------------------------------------------------------------
CREATE TRIGGER TriggerLogUpdatedClientes
ON Clientes
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(8) = 'Clientes'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdCliente, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogUpdatedEtapas
ON Etapas
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(6) = 'Etapas'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdEtapa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogUpdatedMateriais
ON Materiais
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(9) = 'Materiais'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdMaterial, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogUpdatedMateriaisEtapa
ON MateriaisEtapa
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(14) = 'MateriaisEtapa'

	INSERT INTO Logs (Id, IdSecundario, Acao, DataHoraMudança, Tabela) 
	SELECT i.idMaterial, i.IdEtapa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogUpdatedObras
ON Obras
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(6) = 'Obras'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdObra, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogUpdatedPessoaEtapa
ON PessoaEtapa
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(11) = 'PessoaEtapa'

	INSERT INTO Logs (Id, IdSecundario, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdPessoa, i.IdEtapa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO

CREATE TRIGGER TriggerLogUpdatedPessoas
ON Pessoas
AFTER UPDATE
AS
BEGIN
	DECLARE @acao char(6) = 'UPDATE'
	DECLARE @Tabela char(6) = 'Pessoas'

	INSERT INTO Logs (Id, Acao, DataHoraMudança, Tabela) 
	SELECT i.IdPessoa, @acao, GETDATE(), @Tabela
	from inserted i
END;
GO
--Criação de Views---------------------------------------------------------------------------------------------------
CREATE VIEW ViewObrasConcluidas AS
SELECT * FROM Obras o
WHERE o.StatusObra = 'Concluido'
GO

CREATE VIEW ViewObrasEmAndamento AS
SELECT * FROM Obras o
WHERE o.StatusObra = 'Em andamento'
GO 

CREATE VIEW ViewObrasIniciadas AS
SELECT * FROM Obras o
WHERE o.StatusObra = 'Iniciado'
GO

--Funções---------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE obrasPorCpfCliente(
	@cpf char(11)
)
as
begin
	SELECT o.Nome as 'Nome Obra', o.DataInicio as 'Data Inicio',
	o.DataFim as 'Data Fim', o.StatusObra as 'Status', o.Descrição FROM Clientes c INNER JOIN 
	Obras o ON c.IdCliente = o.idCliente
	WHERE c.Cpf = @cpf
end
GO

CREATE PROCEDURE obrasPorCpfPessoa(
	@cpf char(11)
)
as
begin
	SELECT o.Nome as 'Obra', e.Nome as 'Etapa', pe.HorasExigidas as 'Horas Exigidas', 
	pe.HorasTrabalhadas as 'Horas Trabalhadas'
	FROM Pessoas p 
	INNER JOIN PessoaEtapa pe ON p.IdPessoa = pe.IdPessoa
	INNER JOIN Etapas e ON pe.IdEtapa = e.IdEtapa
	INNER JOIN Obras o ON o.IdObra = e.idObra
	WHERE p.Cpf = @cpf
end
GO

CREATE PROCEDURE pessoasPorIdObra(
	@idObra int
)
as
begin
	SELECT p.Nome, p.Cpf, o.Nome as 'Nome Obra', e.Nome as 'Etapa', 
	pe.HorasExigidas as 'Horas Exigidas', pe.HorasTrabalhadas as 'Horas Trabalhadas'
	FROM Pessoas p 
	INNER JOIN PessoaEtapa pe ON p.IdPessoa = pe.IdPessoa
	INNER JOIN Etapas e ON pe.IdEtapa = e.IdEtapa
	INNER JOIN Obras o ON o.IdObra = e.idObra
	WHERE o.IdObra = @idObra
end
