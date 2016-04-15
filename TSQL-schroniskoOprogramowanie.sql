
--Imiê i nazwisko:Sebastian Majewski
--Numer indeksu:235317
--Temat bazy danych:Schronisko dla zwierz¹t

--1a) Tworzymy widok 
--Widok pokazuje zwierzêta które nie mia³y jeszcze badañ
--DROP VIEW bez_badan;
CREATE VIEW bez_badan AS
	SELECT z.id_Zwierze, z.Imie, CASE WHEN COUNT(*)=0 THEN 'Nie' WHEN COUNT(*)>0 THEN 'Tak' END AS Badany
	FROM Zwierze z LEFT JOIN Badanie b 
	ON z.id_Zwierze=b.id_Zwierze 
	GROUP BY z.id_Zwierze,z.Imie 
	HAVING COUNT(*)=0;
--1b) Sprawdzenie, ¿e widok dzia³a
SELECT * FROM bez_badan;
--2a) Tworzymy funkcjê 1
--Funkcja zwraca liczbê specjalistow w danej dziedzinie
--DROP FUNCTION dbo.specjalisci;
CREATE FUNCTION dbo.specjalisci (@nazwa_spec VARCHAR(50)) RETURNS INT
BEGIN
RETURN (
	SELECT COUNT(*) 
	FROM Specjalizacja s LEFT JOIN Specjalista t 
	ON s.id_Specjalizacja=t.id_Specjalizacja 
	WHERE Nazwa=@nazwa_spec
	)   
END;
--2b) Sprawdzenie, ¿e funkcja 1 dzia³a
SELECT dbo.specjalisci('Choroby Ryb');
--3a) Tworzymy funkcjê 2
--Funkcja zwraca Przyjêcia i Adopcje w danym czasie
--DROP FUNCTION dbo.operacje_tabela;
CREATE FUNCTION dbo.operacje_tabela(@data_pocz DATE, @data_konc DATE) 
RETURNS @Przyjecia_Adopcje TABLE
(
	id_Zwierze INT NOT NULL,
	id_Pracownik INT  NOT NULL,
	id_Klient INT  NOT NULL,
	Data DATE NOT NULL,
	Oplata MONEY NOT NULL,
	Typ VARCHAR(10) NOT NULL
)
AS
BEGIN
	DECLARE
		@id_Zwierze INT,
		@id_Pracownik INT,
		@id_Klient INT,
		@Data_adopcji DATE,
		@Data_przyjecia DATE,
		@Oplata MONEY;
	DECLARE kursor_adopcja CURSOR FOR SELECT id_Zwierze, id_Pracownik, id_Klient, Data_adopcji, Oplata FROM Adopcja;
	OPEN kursor_adopcja;
	FETCH NEXT FROM kursor_adopcja INTO @id_Zwierze, @id_Pracownik, @id_Klient, @Data_adopcji, @Oplata;
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF(@Data_adopcji>=@data_pocz AND @Data_adopcji<=@data_konc)
		BEGIN
			INSERT INTO @Przyjecia_Adopcje (id_Zwierze, id_Pracownik, id_Klient, Data, Oplata,Typ) 
			VALUES (@id_Zwierze, @id_Pracownik, @id_Klient, @Data_adopcji, @Oplata, 'Adopcja');
		END;
		FETCH NEXT FROM kursor_adopcja INTO @id_Zwierze, @id_Pracownik, @id_Klient, @Data_adopcji, @Oplata;
	END;
	DECLARE kursor_przyjecie CURSOR FOR SELECT id_Zwierze, id_Pracownik, id_Klient, Data_przyjecia, Oplata FROM Przyjecie;
	OPEN kursor_przyjecie;
	FETCH NEXT FROM kursor_przyjecie INTO @id_Zwierze, @id_Pracownik, @id_Klient, @Data_przyjecia, @Oplata;
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF(@Data_przyjecia>=@data_pocz AND @Data_przyjecia<=@data_konc)
		BEGIN
			INSERT INTO @Przyjecia_Adopcje (id_Zwierze, id_Pracownik, id_Klient, Data, Oplata,Typ) 
			VALUES (@id_Zwierze, @id_Pracownik, @id_Klient, @Data_przyjecia, @Oplata,'Przyjecie');
		END;
		FETCH NEXT FROM kursor_adopcja INTO @id_Zwierze, @id_Pracownik, @id_Klient, @Data_przyjecia, @Oplata;
	END;
	RETURN;
END;
--3b) Sprawdzenie, ¿e funkcja 2 dzia³a
SELECT * FROM dbo.operacje_tabela('2010/12/8','2011/01/01');
--4a) Tworzymy procedurê 1
--Procedura dodaje przyjêcie i zwierze które zosta³o przyjête
--DROP PROCEDURE dodaj_przyjecie
CREATE PROCEDURE dodaj_przyjecie 
	@id_Pracownik INT,
	@id_Klient INT,
	@Data DATE,
	@Oplata MONEY,
	@Opis TEXT,
	@id_Rasa INT,
	@id_Typ INT,
	@Imie VARCHAR(20),
	@Wiek VARCHAR(20)
AS
BEGIN
	INSERT INTO Zwierze(id_Rasa,id_Typ,Imie,Wiek,Opis) VALUES (@id_Rasa,@id_Typ,@Imie,@Wiek,@Opis);
	DECLARE @id_zwierze INT;
	SELECT @id_zwierze=id_Zwierze FROM Zwierze WHERE id_rasa=@id_Rasa AND id_Typ=@id_Typ AND Imie=@Imie AND Wiek=@Wiek;
	INSERT INTO Przyjecie(id_Zwierze,id_Klient,id_Pracownik,Data_przyjecia,Opis,Oplata) VALUES (@id_zwierze,@id_Klient,@id_Pracownik,@Data,@Opis,@Oplata);
END;
--4b) Sprawdzenie, ¿e procedura 1 dzia³a
EXECUTE dodaj_przyjecie 2,1,'2011/10/03',100,'Mi³e zwierze',3,1,'Reja','2';
--5a) Tworzymy procedurê 2
--Procedura zwieksza pensje gdy jest ni¿sza ni¿ podana o podan¹ sumê
--DROP PROCEDURE zwieksz_zarobki;
CREATE PROCEDURE zwieksz_zarobki @limit_gorny MONEY, @suma MONEY
AS
BEGIN
	DECLARE 
		@id_Pracownik INT,
		@Stanowisko INT,
		@Premia MONEY,
		@Pensja MONEY;
	DECLARE kursor_pracownik CURSOR FOR SELECT id_Pracownik,Stanowisko,Premia FROM Pracownik;
	OPEN kursor_pracownik;
	FETCH NEXT FROM kursor_pracownik INTO @id_Pracownik,@Stanowisko,@Premia;
	WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT @Pensja=Pensja FROM Stanowisko WHERE id_Stanowisko=@Stanowisko;
		IF((@Pensja+@Premia)<@limit_gorny)
		BEGIN
			UPDATE Pracownik SET Premia+=@suma WHERE id_Pracownik=@id_Pracownik;
		END;
		FETCH NEXT FROM kursor_pracownik INTO @id_Pracownik,@Stanowisko,@Premia;	
	END;
	CLOSE kursor_pracownik;
	DEALLOCATE kursor_pracownik;
END;
--5b) Sprawdzenie, ¿e procedura 2 dzia³a
EXECUTE zwieksz_zarobki 1000,100;
--6a) Tworzymy wyzwalacz 1
--Wyzwalacz blokuje dodanie istniej¹cego numeru pesel pracownika
--DROP TRIGGER blokada_pesel;
CREATE TRIGGER blokada_pesel ON pracownik
AFTER INSERT
AS
BEGIN
	DECLARE pesel CURSOR
	FOR SELECT Pesel FROM Inserted
	OPEN Pesel;
	DECLARE @pesel VARCHAR(11);
	FETCH NEXT FROM pesel INTO @pesel;
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF((SELECT COUNT(*) FROM Pracownik WHERE Pesel=@pesel)>1)
		BEGIN
			ROLLBACK;
			RAISERROR('Nie mo¿na wstawiæ pracownika z tym nr pesel!',1,2)
		END;
		FETCH NEXT FROM pesel INTO @pesel;
	END;
	CLOSE pesel;
	DEALLOCATE pesel;
END;
--6b) Sprawdzenie, ¿e wyzwalacz 1 dzia³a
INSERT INTO Pracownik (Stanowisko,Adres_korespondencji,Adres_staly,Imie,Nazwisko,Pesel,Telefon,Premia)
VALUES (1,NULL,5,'Agata','Potocka','73948574527','346346344',100);
--7a) Tworzymy wyzwalacz 2
--Wyzwalacz zabrania usuwania adresów gdy istniej¹ osoby pod nim zamieszka³e
--DROP TRIGGER usun_adres;
CREATE TRIGGER usun_adres ON Adres
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id_adres INT;
	DECLARE adres CURSOR
	FOR SELECT id_Adres FROM deleted
	OPEN adres;
	FETCH NEXT FROM adres INTO @id_adres;
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF EXISTS (SELECT * FROM Pracownik WHERE Adres_korespondencji=@id_adres OR Adres_staly=@id_adres)
		BEGIN
			RAISERROR('Adres jest u¿ywany',1,2);
			ROLLBACK;
		END;
		ELSE IF EXISTS (SELECT * FROM Klient WHERE Adres_korespondencji=@id_adres OR Adres_staly=@id_adres)
		BEGIN
			RAISERROR('Adres jest u¿ywany',1,2);
			ROLLBACK;
		END;
		ELSE IF EXISTS (SELECT * FROM Weterynarz WHERE Adres_korespondencji=@id_adres OR Adres=@id_adres)
		BEGIN
			RAISERROR('Adres jest u¿ywany',1,2);
			ROLLBACK;
		END;
		ELSE
		BEGIN
			DELETE Adres WHERE id_Adres IN (SELECT id_Adres FROM deleted);
		END;
		FETCH NEXT FROM adres INTO @id_adres;
	END;
	CLOSE adres;
	DEALLOCATE adres;
END;
--7b) Sprawdzenie, ¿e wyzwalacz 2 dzia³a
DELETE FROM Adres WHERE id_Adres=1;
--8a) Tworzymy wyzwalacz 3
--Wyzwalacz zabrania adopcji klientowi bez pozwolenia
--DROP TRIGGER pozwolenie;
CREATE TRIGGER pozwolenie ON Adopcja
INSTEAD OF INSERT
AS
BEGIN
	IF(@@ROWCOUNT>1)
	BEGIN
		RAISERROR('Nie mozna wprowadzac wiecej niz jednej adopcji naraz',1,2);
		ROLLBACK;
	END;
	ELSE
	BEGIN
		DECLARE @id_klient INT, @pozwolenie BIT;
		SELECT @id_klient=id_Klient FROM inserted;
		SELECT @pozwolenie=Pozwolenie FROM Klient WHERE id_Klient=@id_klient;
		IF(@pozwolenie=0)
		BEGIN
			RAISERROR('Klient nie ma pozwolenia!',1,2);
		ROLLBACK;
		END;
		ELSE
		BEGIN
			INSERT INTO Adopcja SELECT * FROM inserted;
		END;
	END;
END;
--8b) Sprawdzenie, ¿e wyzwalacz 3 dzia³a
UPDATE Klient SET Pozwolenie=0 WHERE id_Klient=1;
INSERT INTO Adopcja (id_Zwierze,id_Pracownik,id_Klient,Data_adopcji,Oplata)
VALUES (7,1,1,'2010/10/10',100);
--9a) Tworzymy wyzwalacz 4
--Wyzwalacz przenosi usuniete zwierzeta do innej tabeli
--DROP TABLE usuniete_zwierze;
CREATE TABLE usuniete_zwierze
(
	id_Zwierze INT  NOT NULL PRIMARY KEY,
	id_Rasa INT  NOT NULL REFERENCES Rasa (id_Rasa),
	id_Typ INT  NOT NULL REFERENCES Typ (id_Typ),
	Imie VARCHAR(20) NOT NULL,
	Wiek VARCHAR(20) NOT NULL,
	Opis TEXT NOT NULL,
)
--DROP TRIGGER usuniete_zwierze_tri;
CREATE TRIGGER usuniete_zwierze_tri ON Zwierze
INSTEAD OF DELETE
AS
BEGIN
	INSERT INTO usuniete_zwierze SELECT * FROM deleted;
	DELETE FROM Adopcja WHERE id_Zwierze IN (SELECT id_Zwierze FROM deleted);
	DELETE FROM Przyjecie WHERE id_Zwierze IN (SELECT id_Zwierze FROM deleted);
	DELETE FROM Zwierze WHERE id_Zwierze IN (SELECT id_Zwierze FROM deleted);
END;
--9b) Sprawdzenie, ¿e wyzwalacz 4 dzia³a
DELETE FROM Zwierze WHERE id_Zwierze=6;
--10a) Tworzymy tabelê przestawn¹
--Tabela pokazuje liczbê specjalistów w danej dziedzinie
SELECT [1] AS 'Choroby psów i kotów',[2] AS 'Radiologia Weterynaryjna',[3] AS 'Chirurgia Weterynaryjna',[4] AS 'Choroby Ryb',[5] AS 'Choroby Zwierz¹t Nieudomowionych' FROM Specjalista
PIVOT
(
	COUNT (id_Weterynarz)
	FOR id_Specjalizacja IN ([1],[2],[3],[4],[5] )
) AS pvt
--10b) Sprawdzenie, ¿e tabela przestawna dzia³a
INSERT INTO Specjalista VALUES (1,3);