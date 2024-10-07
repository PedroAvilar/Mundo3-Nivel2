USE loja;
GO

--Dados completos de pessoas fisicas
SELECT p.*, pf.CPF
FROM Pessoas p 
INNER JOIN PessoasFisicas pf ON p.IDPessoa = pf.Pessoas_IDPessoa
ORDER BY p.IDPessoa ASC;
GO

--Dados completos de pessoas juridicas
SELECT p.*, pj.CNPJ
FROM Pessoas p
INNER JOIN PessoasJuridicas pj ON p.IDPessoa = pj.Pessoas_IDPessoa
ORDER BY p.IDPessoa ASC;
GO

--Movimentos de entrada (E)
SELECT m.IDMovimento,
	p.NomePessoa AS Fornecedor,
	prod.NomeProduto,
	m.QuantidadeMovimentado,
	m.PrecoUnitario,
	(m.QuantidadeMovimentado * m.PrecoUnitario) AS ValorTotal
FROM Movimentos m
INNER JOIN Pessoas p ON m.Pessoas_IDPessoa = p.IDPessoa
INNER JOIN PessoasJuridicas pj ON p.IDPessoa = pj.Pessoas_IDPessoa
INNER JOIN Produtos prod ON m.Produtos_IDProduto = prod.IDProduto
WHERE m.Tipo = 'E'
ORDER BY m.IDMovimento ASC;
GO

--Movimentos de saida (S)
SELECT m.IDMovimento,
	p.NomePessoa AS Comprador,
	prod.NomeProduto,
	m.QuantidadeMovimentado,
	m.PrecoUnitario,
	(m.QuantidadeMovimentado * m.PrecoUnitario) AS ValorTotal
FROM Movimentos m
INNER JOIN Pessoas p ON m.Pessoas_IDPessoa = p.IDPessoa
INNER JOIN PessoasFisicas pf ON p.IDPessoa = pf.Pessoas_IDPessoa
INNER JOIN Produtos prod ON m.Produtos_IDProduto = prod.IDProduto
WHERE m.Tipo = 'S'
ORDER BY m.IDMovimento ASC;
GO

--Entrada total por produto (E)
SELECT prod.NomeProduto,
	SUM (m.QuantidadeMovimentado * m.PrecoUnitario) AS ValorTotalEntradas
FROM Movimentos m
INNER JOIN Produtos prod ON m.Produtos_IDProduto = prod.IDProduto
WHERE m.Tipo = 'E'
GROUP BY prod.NomeProduto
ORDER BY ValorTotalEntradas DESC;
GO

--Saida total por produto (S)
SELECT prod.NomeProduto,
	SUM (m.QuantidadeMovimentado * m.PrecoUnitario) AS ValorTotalSaidas
FROM Movimentos m
INNER JOIN Produtos prod ON m.Produtos_IDProduto = prod.IDProduto
WHERE m.Tipo = 'S'
GROUP BY prod.NomeProduto
ORDER BY ValorTotalSaidas DESC;
GO

--Usuarios sem entradas feitas (E)
SELECT u.IDUsuario, u.NomeUsuario
FROM Usuarios u
LEFT JOIN Movimentos m ON u.IDUsuario = m.Usuarios_IDUsuario AND m.Tipo = 'E'
WHERE m.IDMovimento IS NULL;
GO

--Total de entradas por usuario (E)
SELECT u.IDUsuario, u.NomeUsuario,
	SUM (m.QuantidadeMovimentado * m.PrecoUnitario) AS ValorTotalEntradas
FROM Movimentos m
INNER JOIN Usuarios u ON m.Usuarios_IDUsuario = u.IDUsuario
WHERE m.Tipo = 'E'
GROUP BY u.IDUsuario, u.NomeUsuario
ORDER BY ValorTotalEntradas DESC;
GO

--Total de saidas por usuario (S)
SELECT	u.IDUsuario, u.NomeUsuario,
	SUM (m.QuantidadeMovimentado * m.PrecoUnitario) AS ValorTotalSaidas
FROM Movimentos m
INNER JOIN Usuarios u ON m.Usuarios_IDUsuario = u.IDUsuario
WHERE m.Tipo = 'S'
GROUP BY u.IDUsuario, u.NomeUsuario
ORDER BY  ValorTotalSaidas DESC;
GO

--Valor medio de venda (S)
SELECT p.IDProduto, p.NomeProduto,
	CAST (SUM (m.PrecoUnitario * m.QuantidadeMovimentado) / NULLIF (SUM (m.QuantidadeMovimentado), 0) AS DECIMAL (10, 2)) AS MediaPonderadaVendas
FROM Movimentos m
INNER JOIN  Produtos p ON m.Produtos_IDProduto = p.IDProduto
WHERE m.Tipo = 'S'
GROUP BY p.IDProduto, p.NomeProduto
ORDER BY MediaPonderadaVendas DESC;
GO