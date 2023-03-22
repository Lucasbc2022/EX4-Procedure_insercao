CREATE DATABASE querydinamica
GO
USE querydinamica

CREATE TABLE produto (
idProduto             INT             NOT NULL,
tipo                  VARCHAR(100),
cor                   VARCHAR(50)
PRIMARY KEY(idProduto)
)
GO

CREATE TABLE camiseta (
idProduto             INT             NOT NULL,
tamanho               VARCHAR(3)     
PRIMARY KEY(idProduto)
FOREIGN KEY(idProduto) REFERENCES produto(idProduto)
)
GO

CREATE TABLE tenis (
idProduto             INT             NOT NULL,
tamanho               INT
PRIMARY KEY(idProduto)
FOREIGN KEY(idProduto) REFERENCES produto(idProduto)
)
GO

CREATE TABLE produto (
codigo                INT      IDENTITY(101,1)       NOT NULL,
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
WHILE(SELECT COUNT(codigo) FROM produto ) != 10
BEGIN
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
  INSERT INTO produto VALUES 
  (@nome, @valor)
    
	INSERT INTO entrada VALUES
	(@codigo, @quantidade, @quantidade * @valor)
	SET @saida = 'Produto comprado'
     END

     ELSE

	 BEGIN
     IF(LOWER(@opcao) = 's') 
     BEGIN
     INSERT INTO produto VALUES 
     (@nome, @valor)
    
	 INSERT INTO saida VALUES
	 (@codigo, @quantidade, @quantidade * @valor)
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

  SELECT * FROM  produto
  SELECT * FROM  saida
  SELECT * FROM entrada