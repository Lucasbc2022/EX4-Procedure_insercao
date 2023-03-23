CREATE DATABASE querydinamica
GO
USE querydinamica


CREATE TABLE produto (
codigo                INT             NOT NULL,
nome                  VARCHAR(100),
valor                 DECIMAL(7, 2)
PRIMARY KEY(codigo)
)
GO

CREATE TABLE entrada(
codigo_transacao              INT    IDENTITY(1,1)       NOT NULL,
codigo_produto                INT           NOT NULL,
quantidade                    INT           NOT NULL,
valor_total                   DECIMAL(7,2)  NOT NULL
PRIMARY KEY(codigo_transacao)
FOREIGN KEY(codigo_produto)  REFERENCES produto(codigo)
)
GO

CREATE TABLE saida(
codigo_transacao              INT    IDENTITY(1,1)       NOT NULL,
codigo_produto                INT           NOT NULL,
quantidade                    INT           NOT NULL,
valor_total                   DECIMAL(7,2)  NOT NULL
PRIMARY KEY(codigo_transacao)
FOREIGN KEY(codigo_produto)  REFERENCES produto(codigo)
)
GO

CREATE PROCEDURE sp_empresa(@opcao CHAR(1),
							@saida VARCHAR(100))
AS 
  DECLARE @query1 VARCHAR(100)
  DECLARE @query2 VARCHAR(100)

DECLARE @produto INT
SET @produto = 0

WHILE(SELECT COUNT(codigo) FROM produto ) != 10
BEGIN



  SET @produto += 1  

  DECLARE @quantidade INT
  SET @quantidade = CAST(((RAND() * 1) + 10)AS INT)

  DECLARE @valor DECIMAL(7, 2)
  SET @valor = ((RAND() * 91) + 10)

  DECLARE @codigo  INT
  SET @codigo = (SELECT codigo FROM produto)



  DECLARE @nome VARCHAR(100)
  SET @nome = 'espada'

  IF(LOWER(@opcao) = 'e') 
  BEGIN
  
  SET @query1 = 'INSERT INTO produto VALUES 
  ('+CAST(@produto AS VARCHAR(10))+', '''+@nome+''', '+CAST(@valor AS VARCHAR(100))+')'
  Print(@query1) 
EXEC (@query1)  
    
	SET @query2 = 'INSERT INTO entrada VALUES
	 ('+CAST(@produto AS VARCHAR(10))+', '+CAST(@quantidade AS VARCHAR(10))+', '+CAST((@quantidade * @valor) AS VARCHAR(10))+')'
   Print @query2
EXEC (@query2)

	SET @saida = 'Produto comprado'
     END

     ELSE

	 BEGIN
     IF(LOWER(@opcao) = 's') 
     BEGIN
  
  SET @query1 = 'INSERT INTO produto VALUES 
  ('+CAST(@produto AS VARCHAR(10))+', '''+@nome+''', '+CAST(@valor AS VARCHAR(100))+')'
  Print(@query1) 
EXEC (@query1)  
    
	SET @query2 = 'INSERT INTO saida VALUES
	 ('+CAST(@produto AS VARCHAR(10))+', '+CAST(@quantidade AS VARCHAR(10))+', '+CAST((@quantidade * @valor) AS VARCHAR(10))+')'
   Print @query2
EXEC (@query2)
	 SET @saida = 'Produto vendido'
	 END

  ELSE
  BEGIN
     RAISERROR('Erro de inserção de produto', 16, 1)
	 SET @saida = 'ERRO DE PROCESSAMENTO'

	 END
  END
  END

  DECLARE @OUT   VARCHAR(100)
  EXEC sp_empresa 's', @OUT
  PRINT(@OUT)

  SELECT * FROM produto
  SELECT * FROM saida
  SELECT * FROM entrada
 