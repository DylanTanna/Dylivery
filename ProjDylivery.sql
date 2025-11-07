CREATE SCHEMA Dylivery;
SET search_path TO Dylivery;

CREATE TABLE Endereco(

    IdEnder INT PRIMARY KEY,
    Rua VARCHAR(256) NOT NULL,
    Bairro VARCHAR(256) NOT NULL,
    Numero INT,
    Cep VARCHAR(256) NOT NULL,
    PontoRef VARCHAR(500)
);

CREATE TABLE Cliente (

    IdCliente INT PRIMARY KEY,
    IdEnderClient INT,
    CtCriacaoClient TIMESTAMP,
    CtAttClient TIMESTAMP,
	
    FOREIGN KEY (IdEnderClient) REFERENCES Endereco(IdEnder)
);

CREATE TABLE Estabelecimento (

    IdEc INT PRIMARY KEY,
    NomeEc VARCHAR(250) NOT NULL,
    DocEc VARCHAR(15) NOT NULL,
    IdEnderEc INT NOT NULL,
    CtCriacaoEc TIMESTAMP,
    CtAttEc TIMESTAMP,
	
    FOREIGN KEY (IdEnderEc) REFERENCES Endereco(IdEnder)
);

CREATE TABLE Entregador (

    IdEntregador INT PRIMARY KEY,
    Veiculo VARCHAR(256),
    DocEntregador VARCHAR(15),
    Saldo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CtCriacaoEntregador TIMESTAMP,
    CtAttEntregador TIMESTAMP
);

CREATE TABLE SaldoTaxa (

    IdSdTx INT PRIMARY KEY,
    TaxaEntrega DECIMAL(10,2) NOT NULL,
    RegistroTx TIMESTAMP NOT NULL,
    IdEc INT,
    IdEntregador INT,
	
    FOREIGN KEY (IdEc) REFERENCES Estabelecimento(IdEc),
    FOREIGN KEY (IdEntregador) REFERENCES Entregador(IdEntregador)
);

CREATE TYPE STATUSENTREGADOR AS ENUM (
'Inicio', 'Fim'
);

CREATE TABLE RegistroEntregador (

    IdEntregador INT,
    IdRgEntregador INT,
    Data DATE NOT NULL,
    Status STATUSENTREGADOR NOT NULL,
    Hora TIME NOT NULL,
	
    PRIMARY KEY (IdEntregador, IdRgEntregador)
);


CREATE TYPE STATUSEC AS ENUM (
'Aberto', 'Fechado'
);

CREATE TABLE RegistroEc (

    IdEc INT,
    IdRgEc INT,
    Data DATE,
    Hora TIME,
    Status STATUSEC NOT NULL,
	
    PRIMARY KEY (IdEc, IdRgEc)
);

CREATE TABLE Produto (

    IdProd INT PRIMARY KEY,
    NomeProd VARCHAR(256) NOT NULL,
    ValorProd DECIMAL(10,2) NOT NULL,
    QntdProd INT NOT NULL,
    IdEc INT,
    CtCriacaoProd TIMESTAMP,
    CtAttProd TIMESTAMP,
	
    FOREIGN KEY (IdEc) REFERENCES Estabelecimento(IdEc)
);

CREATE TABLE Pacote (

    IdPact INT PRIMARY KEY,
    ValorTotalPact DECIMAL(10,2) NOT NULL,
    CtCriacaoPact TIMESTAMP,
    CtAttPact TIMESTAMP
);

CREATE TABLE PactProd (

    IdPact INT,
    IdProd INT,
    QntdPP INT,
	
    PRIMARY KEY (IdPact, IdProd),
    FOREIGN KEY (IdPact) REFERENCES Pacote(IdPact),
    FOREIGN KEY (IdProd) REFERENCES Produto(IdProd)
);

CREATE TYPE STATUSENTREGA AS ENUM (
'EmRota', 'Cancelado', 'Problema'
);

CREATE TABLE Entrega (

    IdEntregador INT NOT NULL,
    IdPact INT NOT NULL,
    Taxa DECIMAL(10,2) NOT NULL,
    Status STATUSENTREGA NOT NULL,
    IdCliente INT NOT NULL,
    IdEnderClient INT NOT NULL,
    IdEnderEc INT NOT NULL,
    CtCriacaoEntrega TIMESTAMP,
    CtAttEntrega TIMESTAMP,

	
    FOREIGN KEY (IdPact) REFERENCES Pacote(IdPact),
    FOREIGN KEY (IdEntregador) REFERENCES Entregador(IdEntregador),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
    FOREIGN KEY (IdEnderClient) REFERENCES Endereco(IdEnder),
    FOREIGN KEY (IdEnderEc) REFERENCES Endereco(IdEnder)
);

--Inserções testes

INSERT INTO Endereco (IdEnder, Rua, Bairro, Numero, Cep, PontoRef) VALUES
(1, 'Rua das Flores', 'Centro', 120, '12345-000', 'Próximo ao mercado'),
(2, 'Av. Brasil', 'Jardim América', 450, '98765-200', NULL),
(3, 'Rua Projetada 5', 'Vila Nova', NULL, '44444-100', 'Perto do posto'),
(4, 'Rua A', 'Bairro B', 10, '22222-000', NULL), 
(5, 'Av. Santos', 'Industrial', 899, '33333-555', 'Galpão azul'),
(6, 'Rua Alfa', 'Beta', 55, '55555-888', NULL);

INSERT INTO Cliente (IdCliente, IdEnderClient, CtCriacaoClient, CtAttClient) VALUES
(1, 1, NOW(), NOW()),
(2, 2, NOW(), NOW()),
(3, NULL, NOW(), NOW());

INSERT INTO Estabelecimento (IdEc, NomeEc, DocEc, IdEnderEc, CtCriacaoEc, CtAttEc) VALUES
(1, 'Lanchonete Bom Sabor', '1234567890001', 5, NOW(), NOW()),
(2, 'Pizzaria Massa Fina', '9876543210001', 6, NOW(), NOW());

INSERT INTO Entregador (IdEntregador, Veiculo, DocEntregador, Saldo, CtCriacaoEntregador, CtAttEntregador) VALUES
(1, 'Moto Honda CG160', '11122233344', 10.00, NOW(), NOW()),
(2, 'Bike Elétrica', '55566677788', 0.00, NOW(), NOW()),
(3, NULL, '22233344455', 5.50, NOW(), NOW()); 

INSERT INTO RegistroEntregador (IdEntregador, IdRgEntregador, Data, Status, Hora) VALUES
(1, 1, CURRENT_DATE, 'Inicio', '08:00'),
(1, 2, CURRENT_DATE, 'Fim', '12:30'),
(2, 1, CURRENT_DATE, 'Inicio', '09:15');

INSERT INTO RegistroEc (IdEc, IdRgEc, Data, Hora, Status) VALUES
(1, 1, CURRENT_DATE, '08:00', 'Aberto'),
(1, 2, CURRENT_DATE, '23:00', 'Fechado'),
(2, 1, CURRENT_DATE, '17:00', 'Aberto');

INSERT INTO Produto (IdProd, NomeProd, ValorProd, QntdProd, IdEc, CtCriacaoProd, CtAttProd) VALUES
(1, 'X-Burger', 15.00, 50, 1, NOW(), NOW()),
(2, 'Batata Frita Média', 10.00, 100, 1, NOW(), NOW()),
(3, 'Pizza Grande Calabresa', 45.00, 20, 2, NOW(), NOW()),
(4, 'Refrigerante Lata', 6.50, 200, 1, NOW(), NOW());

INSERT INTO Pacote (IdPact, ValorTotalPact, CtCriacaoPact, CtAttPact) VALUES
(1, 31.50, NOW(), NOW()), -- X-Burger + Refrigerante
(2, 45.00, NOW(), NOW()),
(3, 10.00, NOW(), NOW()), -- Só batata
(4, 00.00, NOW(), NOW()); -- Pacote criado mas sem valor ainda

INSERT INTO PactProd (IdPact, IdProd, QntdPP) VALUES
(1, 1, 1),
(1, 4, 1),
(2, 3, 1),
(3, 2, 1);

INSERT INTO Entrega (
    IdEntregador, IdPact, Taxa, Status, IdCliente, IdEnderClient, IdEnderEc,
    CtCriacaoEntrega, CtAttEntrega
) VALUES
-- Entrega normal em rota
(1, 1, 7.00, 'EmRota', 1, 1, 5, NOW(), NOW()),

-- Entrega cancelada
(2, 2, 8.00, 'Cancelado', 2, 2, 6, NOW() - INTERVAL '1 day', NOW()),

-- Entrega com problema
(1, 3, 5.00, 'Problema', 3, 4, 5, NOW(), NOW()),

-- Entrega sem pacote finalizado (valor NULL no pacote)
(3, 4, 9.00, 'EmRota', 1, 1, 6, NOW(), NOW());

select * from entrega;