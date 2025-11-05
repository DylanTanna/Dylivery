SET search_path TO Dylivery;


CREATE TABLE Endereco (

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




