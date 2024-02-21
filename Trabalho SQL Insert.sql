USE CONSTRUTORA
GO

INSERT INTO Clientes (DataNasc, Email, Nome, Telefone, Cpf, Endereço)
VALUES ('2005-03-04', 'example@gmail.com', 'Gabriel Sampaio Santos', '(35)98726-2837', '82716726372', 'Extrema, Centro'),
	('2003-02-04', 'example@hotmail.com', 'Jose Alvares Cabral', '(35)98456-2845', '92837263741', 'Braganca Paulista, Centro'),
	('1984-02-05', 'example@gmail.com', 'Maria Campos', '(35)8374-2837', '88394826378', 'Extrema, Zona Rural')

INSERT INTO Materiais(Nome, Descrição, Valor)
VALUES ('Tijolo', 'Feito de cerâmica, vermelho', 1.00),
		('Cimento', 'Cinza', 2.00),
		('Argamassa', 'Branca', 3.00)

INSERT INTO Pessoas(Nome, DataNasc, Especialidades, Cpf, ValorPorHora, Telefone, Email)
VALUES ('Jose Carlos', '1984-02-05', 'Pedreiro e eletricista', '92837483923', 20, '(11)983746253', 'example@yahoo.com'),
		('Andre Luiz', '1980-07-10', 'Projetista e designer de interiores', '92837463526', 30, '(11)92837465', 'example@yahoo.com')


INSERT INTO Obras(Nome, DataInicio, DataFim, StatusObra, Descrição, idCliente)
VALUES ('Casa moderna', '2023-05-12', '2025-05-12', 'Iniciado', 'Definindo projeto', 1),
	('Casa simples', '2022-04-12', '2026-04-12', 'Em andamento', 'Montando base estrutural', 2),
	('Mansao', '2022-04-12', '2023-04-12', 'Concluido', 'Finalizada', 1)

INSERT INTO Etapas(Anexo, Nome, Descrição, Andamento, DataFim, DataInicio, idObra)
VALUES ('', 'Construção da Base', 'Cavar e criar base da casa', 'Em andamento', '2022-10-12', '2022-04-12', 2),
('', 'Design Estrutura', 'Fazer Projeto da casa', 'Em andamento', '2023-07-12', '2023-05-12', 2)

INSERT INTO PessoaEtapa(HorasExigidas, HorasTrabalhadas, ValorCobrado, IdPessoa, IdEtapa)
VALUES (20, 1, 20, 1, 1),
	(30, 2, 30, 2, 2)

INSERT INTO MateriaisEtapa(IdEtapa, idMaterial, Valor, Quantidade)
VALUES(1, 1, 2, 200),
(1, 2, 2, 10)
