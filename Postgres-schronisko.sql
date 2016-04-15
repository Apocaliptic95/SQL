
DROP TABLE IF EXISTS Adopcja;
DROP TABLE IF EXISTS Przyjecie;
DROP TABLE IF EXISTS Specjalista;
DROP TABLE IF EXISTS Specjalizacja;
DROP TABLE IF EXISTS Klient;
DROP TABLE IF EXISTS Pracownik;
DROP TABLE IF EXISTS Diagnoza;
DROP TABLE IF EXISTS Badanie;
DROP TABLE IF EXISTS Choroba;
DROP TABLE IF EXISTS Zwierze;
DROP TABLE IF EXISTS Weterynarz;
DROP TABLE IF EXISTS Typ;
DROP TABLE IF EXISTS Rasa;
DROP TABLE IF EXISTS Adres;
DROP TABLE IF EXISTS Poziom_zagrozenia;
DROP TABLE IF EXISTS Stanowisko;


CREATE TABLE Adres (
  id_Adres INT  NOT NULL SERIAL PRIMARY KEY,
  Ulica VARCHAR(20) NOT NULL CHECK(LENGTH(Ulica)>2),
  Miejscowosc VARCHAR(25) NOT NULL CHECK(LENGHT(Miejscowosc)>2),
  Nr_mieszkania VARCHAR(10) NOT NULL,
  Kod_poczt VARCHAR(6) NOT NULL,
);

CREATE TABLE Poziom_zagrozenia (
	id_zagrozenia INT NOT NULL SERIAL PRIMARY KEY,
	opis TEXT NOT NULL
);

CREATE TABLE Choroba (
  id_Choroba INT  NOT NULL SERIAL PRIMARY KEY,
  Nazwa VARCHAR(20) NOT NULL,
  Poziom_zagrozenia INT  NOT NULL REFERENCES Poziom_zagrozenia (id_zagrozenia),
);

CREATE TABLE Rasa (
  id_Rasa INT  NOT NULL SERIAL PRIMARY KEY,
  Nazwa VARCHAR(20)  NOT NULL,
);

CREATE TABLE Specjalizacja (
  id_Specjalizacja INT  NOT NULL SERIAL PRIMARY KEY,
  Nazwa VARCHAR(50) NOT NULL,
);

CREATE TABLE Typ (
  id_Typ INT  NOT NULL SERIAL PRIMARY KEY,
  Nazwa VARCHAR(20) NOT NULL,
);

CREATE TABLE Stanowisko (
  id_Stanowisko INT  NOT NULL SERIAL PRIMARY KEY,
  Nazwa VARCHAR(20) NOT NULL,
  Pensja MONEY NOT NULL,
);

CREATE TABLE Weterynarz (
  id_Weterynarz INT  NOT NULL SERIAL PRIMARY KEY,
  Adres INT  NOT NULL REFERENCES Adres (id_Adres),
  Adres_korespondencji INT REFERENCES Adres (id_Adres),
  Imie VARCHAR(20) NOT NULL,
  Nazwisko VARCHAR(25) NOT NULL,
  Telefon VARCHAR(15) NOT NULL,
);

CREATE TABLE Specjalista (
  id_Weterynarz INT  NOT NULL REFERENCES Weterynarz (id_Weterynarz) ON DELETE CASCADE,
  id_Specjalizacja INT  NOT NULL REFERENCES Specjalizacja (id_Specjalizacja) ON DELETE CASCADE,
  PRIMARY KEY(id_Weterynarz, id_Specjalizacja)
);

CREATE TABLE Zwierze (
  id_Zwierze INT  NOT NULL SERIAL PRIMARY KEY,
  id_Rasa INT  NOT NULL REFERENCES Rasa (id_Rasa),
  id_Typ INT  NOT NULL REFERENCES Typ (id_Typ),
  Imie VARCHAR(20) NOT NULL,
  Wiek INT NOT NULL,
  Opis TEXT NOT NULL,
);

CREATE TABLE Badanie (
  id_Badanie INT  NOT NULL SERIAL PRIMARY KEY,
  id_Zwierze INT  NOT NULL REFERENCES Zwierze (id_Zwierze),
  id_Weterynarz INT  NOT NULL REFERENCES Weterynarz (id_Weterynarz),
  Data_badania DATE NOT NULL DEFAULT NOW(),
  Zalecenia TEXT NOT NULL,
  Oplata_badania MONEY NOT NULL,
);

CREATE TABLE Diagnoza (
  id_Badanie INT NOT NULL REFERENCES Badanie (id_Badanie) ON DELETE CASCADE,
  id_Choroba INT NOT NULL REFERENCES Choroba (id_Choroba),
  PRIMARY KEY(id_Badanie, id_Choroba)
);

CREATE TABLE Klient (
  id_Klient INT  NOT NULL SERIAL PRIMARY KEY,
  Adres_korespondencji INT REFERENCES Adres (id_Adres),
  Adres_staly INT  NOT NULL REFERENCES Adres (id_Adres),
  Imie VARCHAR(20) NOT NULL,
  Nazwisko VARCHAR(25) NOT NULL,
  Pesel VARCHAR(11) NOT NULL,
  Telefon VARCHAR(15) NOT NULL,
  Pozwolenie BIT NOT NULL,
);

CREATE TABLE Pracownik (
  id_Pracownik INT  NOT NULL SERIAL PRIMARY KEY,
  Stanowisko INT  NOT NULL REFERENCES Stanowisko (id_Stanowisko),
  Adres_korespondencji INT REFERENCES Adres (id_Adres),
  Adres_staly INT  NOT NULL REFERENCES Adres (id_Adres),
  Imie VARCHAR(20) NOT NULL,
  Nazwisko VARCHAR(25) NOT NULL,
  Pesel VARCHAR(11) UNIQUE NOT NULL,
  Telefon VARCHAR(15) NOT NULL,
  Premia MONEY NOT NULL,
);

CREATE TABLE Adopcja (
  id_Zwierze INT NOT NULL PRIMARY KEY REFERENCES Zwierze (id_Zwierze),
  id_Pracownik INT  NOT NULL REFERENCES Pracownik (id_Pracownik),
  id_Klient INT  NOT NULL REFERENCES Klient (id_Klient),
  Data_adopcji DATE NOT NULL DEFAULT NOW(),
  Oplata MONEY NOT NULL,
);

CREATE TABLE Przyjecie (
  id_Zwierze INT NOT NULL PRIMARY KEY REFERENCES Zwierze (id_Zwierze),
  id_Klient INT  NOT NULL REFERENCES Klient (id_Klient),
  id_Pracownik INT  NOT NULL REFERENCES Pracownik (id_Pracownik),
  Data_przyjecia DATE NOT NULL DEFAULT NOW(),
  Opis TEXT NOT NULL,
  Oplata MONEY NOT NULL,
);

INSERT INTO Adres (Ulica,Miejscowosc,Nr_mieszkania,Kod_poczt) VALUES 
('Mazowiecka','Gdańsk','50','06-500'),
('Abrahama','Gdańsk','13','80-210'),
('Traugutta','Warszawa','250','10-520'),
('Leśna','Łódź','20','22-599'),
('Cicha','Kraków','80','09-789');

INSERT INTO Choroba (Nazwa,Poziom_zagrozenia) VALUES
('Wścieklizna',5),
('Złamanie',2),
('Nieznana',5),
('Zatrucie',3),
('Nosówka',5);

INSERT INTO Rasa (Nazwa) VALUES 
('Labrador'),
('Perski'),
('Dalmatyńczyk'),
('Amstaff'),
('Mieszana');

INSERT INTO Specjalizacja (Nazwa) VALUES 
('Choroby psów i kotów'),
('Radiologia Weterynaryjna'),
('Chirurgia Weterynaryjna'),
('Choroby Ryb'),
('Choroby Zwierząt Nieudomowionych');

INSERT INTO Typ (Nazwa) VALUES 
('Kot'),
('Pies'),
('Ryba'),
('Chomik'),
('Kanarek');

INSERT INTO Stanowisko (Nazwa,Pensja) VALUES 
('Obsługa klienta',1200),
('Pomocnik',800),
('Nadzorca',1500),
('Stróż',1300),
('Wolontariusz',0);

INSERT INTO Weterynarz (Adres,Adres_korespondencji,Imie,Nazwisko,Telefon) VALUES
(1,NULL,'Jan','Kowalski','102013012'),
(2,NULL,'Andrzej','Nowak','999222333'),
(3,NULL,'Marek','Witkowski','112244556'),
(4,NULL,'Wojciech','Grabowski','858923034'),
(5,NULL,'Maria','Ślesicka','098653534');

INSERT INTO Specjalista VALUES (1,1),(2,2),(3,3),(4,4),(5,5);

INSERT INTO Zwierze (id_Rasa,id_Typ,Imie,Wiek,Opis) VALUES
(1,2,'Reks',2,'Przyjazny pies.'),
(3,2,'Antek',1,'Lubiący zabawę szczeniak.'),
(2,1,'Mruczek',1,'Wyjątkowo leniwy kot.'),
(4,2,'Drago',5,'Silny i niezależny pies.'),
(5,2,'Diana',2,'Przyjazna i lubiąca dzieci.');

SET DATEFORMAT dmy;

INSERT INTO Poziom_zagrozenia (opis) VALUES
('Brak'),
('Niski'),
('Średni'),
('Wysoki'),
('Śmiertelny');

INSERT INTO Badanie (id_Zwierze,id_Weterynarz,Data_badania,Zalecenia,Oplata_badania) VALUES
(1,1,'09/09/2012','Izolacja i szczepionka',50),
(2,2,'04/05/2013','Gips',100),
(3,3,'12/12/2014','Antybiotyk',120),
(4,4,'15/10/2015','Dieta',20),
(5,5,'19/01/2012','Izolacja i antybiotyk',140);

INSERT INTO Diagnoza (id_Badanie,id_Choroba) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

INSERT INTO Klient (Adres_korespondencji,Adres_staly,Imie,Nazwisko,Pesel,Telefon,Pozwolenie) VALUES
(NULL,1,'Jan','Kowalski','94636271723','102013012',1),
(NULL,2,'Andrzej','Nowak','09786754321','999222333',1),
(NULL,3,'Marek','Witkowski','09435261783','112244556',1),
(NULL,4,'Wojciech','Grabowski','77648362345','858923034',1),
(NULL,5,'Maria','Ślesicka','74521345732','098653534',1);

INSERT INTO Pracownik (Stanowisko,Adres_korespondencji,Adres_staly,Imie,Nazwisko,Pesel,Telefon,Premia) VALUES
(1,NULL,5,'Agata','Potocka','73948574627','090988763',0),
(2,NULL,4,'Mariusz','Doliński','54858696749','857465443',100),
(3,NULL,3,'Jan','Spędowski','89576342512','244233456',200),
(4,NULL,2,'Michał','Spelak','09877678965','122312334',0),
(5,NULL,1,'Aleksandra','Górska','96756544323','675464674',0);

INSERT INTO Adopcja (id_Zwierze,id_Pracownik,id_Klient,Data_adopcji,Oplata) VALUES
(1,1,5,'09/12/2010',100),
(2,2,4,'21/10/2001',10),
(3,3,3,'23/04/2009',150),
(4,4,2,'26/01/2013',50),
(5,5,1,'01/02/2003',40);

INSERT INTO Przyjecie (id_Zwierze,id_Pracownik,id_Klient,Data_przyjecia,Opis,Oplata) VALUES
(1,1,5,'09/12/2010','Przyjazne zwierze',100),
(2,2,4,'21/10/2001','Miły zwierzak',10),
(3,3,3,'23/04/2009','Pełny radosci',150),
(4,4,2,'26/01/2013','Potulny',50),
(5,5,1,'01/02/2003','Przyjazna psina',40);