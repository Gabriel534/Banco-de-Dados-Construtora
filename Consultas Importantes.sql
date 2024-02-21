USE CONSTRUTORA
GO

SELECT * FROM ViewObrasIniciadas
SELECT * FROM ViewObrasEmAndamento
SELECT * FROM ViewObrasConcluidas

SELECT * FROM Logs --Mostra o log do servidor sql

exec obrasPorCpfCliente '82716726372' -- Mostra quantas Obras um cliente tem

exec pessoasPorIdObra 2 --Indica quantas pessoas trabalham por Obra

exec obrasPorPessoa '92837463526' --Indica quantas obras uma pessoa tem