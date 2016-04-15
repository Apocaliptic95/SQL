
--Imiê i nazwisko:Sebastian Majewski
--Numer indeksu:235317
--Temat bazy danych:Schronisko dla zwierz¹t

--1a) Tworzymy widok 
--Widok pokazuje zwierzêta które nie mia³y jeszcze badañ
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
CREATE OR REPLACE FUNCTION specjalisci (VARCHAR(50)) RETURNS BIGINT
AS $$
	SELECT COUNT(*) 
	FROM Specjalizacja s LEFT JOIN Specjalista t 
	ON s.id_Specjalizacja=t.id_Specjalizacja 
	WHERE Nazwa=$1 
$$ LANGUAGE SQL;
--2b) Sprawdzenie, ¿e funkcja 1 dzia³a
SELECT specjalisci('Choroby Ryb');
--3a) Tworzymy funkcjê 2
--Funkcja zwraca Przyjêcia i Adopcje w danym czasie
CREATE OR REPLACE FUNCTION operacje_tabela(data_pocz DATE, data_konc DATE) RETURNS TABLE
(
	id_Zwierze INT,
	id_Pracownik INT,
	id_Klient INT,
	Data DATE,
	Oplata MONEY,
	Typ VARCHAR(10)
)
AS
$$
BEGIN
	FOR id_Zwierze, id_Pracownik, id_Klient, Data, Oplata, Typ IN
		SELECT id_Zwierze, id_Pracownik, id_Klient, Data, Oplata, 'Adopcja' FROM Adopcja WHERE Data_adopcji>=data_pocz AND Data_adopcji<=data_konc LOOP
    RETURN NEXT;
	END LOOP;
	
	FOR id_Zwierze, id_Pracownik, id_Klient, Data, Oplata, Typ IN
		SELECT id_Zwierze, id_Pracownik, id_Klient, Data, Oplata, 'Przyjecie' FROM Przyjecie WHERE Data_przyjecia>=data_pocz AND Data_przyjecia<=data_konc LOOP
    RETURN NEXT;
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;
--3b) Sprawdzenie, ¿e funkcja 2 dzia³a
SELECT * FROM operacje_tabela('2010/12/8','2011/01/01');
--4a) Tworzymy procedurê 1
--Procedura dodaje przyjêcie i zwierze które zosta³o przyjête
CREATE OR REPLACE FUNCTION dodaj_przyjecie (zid_Pracownik INT,zid_Klient INT,zData DATE,zOplata MONEY,zOpis TEXT,zid_Rasa INT,zid_Typ INT,zImie VARCHAR(20),zData_Urodzenia DATE)
RETURNS VOID AS
$$
DECLARE id INT;
BEGIN
	INSERT INTO Zwierze(id_Rasa,id_Typ,Imie,data_urodzenia,Opis) VALUES (zid_Rasa,zid_Typ,zImie,zData_Urodzenia,zOpis);
	SELECT INTO id z.id_Zwierze FROM Zwierze z WHERE z.id_rasa=zid_Rasa AND z.id_Typ=zid_Typ AND z.Imie=zImie AND z.data_urodzenia=zData_Urodzenia;
	INSERT INTO Przyjecie(id_Zwierze,id_Klient,id_Pracownik,Data_przyjecia,Opis,Oplata) VALUES (id,zid_Klient,zid_Pracownik,zData,zOpis,zOplata);
END;
$$ LANGUAGE plpgsql;
--4b) Sprawdzenie, ¿e procedura 1 dzia³a
SELECT dodaj_przyjecie(CAST(2 AS INT),CAST(1 AS INT),CAST('2011/10/03' AS DATE),CAST(100 AS MONEY),CAST('Mile zwierze' AS TEXT),CAST(3 AS INT),CAST(1 AS INT),CAST('Reja' AS VARCHAR(20)),CAST('2010/05/06' AS DATE));
--5a) Tworzymy procedurê 2
--Procedura zwieksza pensje gdy jest ni¿sza ni¿ podana o podan¹ sumê
CREATE OR REPLACE FUNCTION zwieksz_zarobki (limit_gorny MONEY, suma MONEY)
RETURNS VOID AS
$$
BEGIN
	DECLARE zid_Pracownik INT;
	DECLARE	zPremia MONEY;
	DECLARE	zPensja MONEY;
	BEGIN
		FOR zid_Pracownik, zPensja, zPremia IN 
			SELECT p.id_Pracownik, s.Pensja,p.Premia FROM Pracownik p LEFT JOIN Stanowisko s ON s.id_Stanowisko=p.Stanowisko WHERE (s.Pensja+p.Premia) <= limit_gorny LOOP
			UPDATE Pracownik SET Premia=zPremia+suma WHERE id_Pracownik=zid_Pracownik;
		END LOOP;
	END;
END;
$$ LANGUAGE plpgsql;
--5b) Sprawdzenie, ¿e procedura 2 dzia³a
SELECT zwieksz_zarobki(CAST(1000 AS MONEY),CAST(100 AS MONEY));
--6a) Tworzymy wyzwalacz 1
--Wyzwalacz blokuje dodanie istniej¹cego numeru pesel pracownika
CREATE OR REPLACE FUNCTION blokada_pesel()
RETURNS TRIGGER 
AS
$$
BEGIN
	IF EXISTS (SELECT * FROM Pracownik p WHERE p.Pesel= NEW.Pesel) THEN
	RAISE EXCEPTION 'Podany Pesel istnieje!';
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER blokada_pesel AFTER INSERT OR UPDATE
ON Pracownik
FOR EACH ROW
EXECUTE PROCEDURE blokada_pesel();
--6b) Sprawdzenie, ¿e wyzwalacz 1 dzia³a
INSERT INTO Pracownik (Stanowisko,Adres_korespondencji,Adres_staly,Imie,Nazwisko,Pesel,Telefon,Premia)
VALUES (1,NULL,5,'Agata','Potocka','73948574527','346346344',100);
--7a) Tworzymy wyzwalacz 2
--Wyzwalacz zabrania usuwania adresów gdy istniej¹ osoby pod nim zamieszka³e
CREATE OR REPLACE FUNCTION usun_adres()
RETURNS TRIGGER
AS
$$
BEGIN
		IF ((SELECT COUNT(*) FROM Pracownik WHERE Adres_korespondencji=OLD.id_Adres OR Adres_staly=OLD.id_Adres)>0)
			 THEN RAISE EXCEPTION 'Adres jest uzywany';
		ELSIF ((SELECT COUNT(*) FROM Klient WHERE Adres_korespondencji=OLD.id_Adres OR Adres_staly=OLD.id_Adres)>0)
			 THEN RAISE EXCEPTION 'Adres jest uzywany';
		ELSIF  ((SELECT COUNT(*) FROM Weterynarz WHERE Adres_korespondencji=OLD.id_Adres OR Adres=OLD.id_Adres)>0)
			 THEN RAISE EXCEPTION 'Adres jest uzywany';
		ELSE
            RETURN OLD;
		END IF;
		RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER usun_adres
BEFORE DELETE ON Adres 
FOR EACH ROW
EXECUTE PROCEDURE usun_adres();
--7b) Sprawdzenie, ¿e wyzwalacz 2 dzia³a
DELETE FROM Adres WHERE id_Adres=20;
DELETE FROM Adres WHERE id_Adres=1;
--8a) Tworzymy wyzwalacz 3
--Wyzwalacz zabrania adopcji klientowi bez pozwolenia
CREATE OR REPLACE FUNCTION pozwolenie()
RETURNS TRIGGER
AS
$$
BEGIN
	
	IF EXISTS(SELECT * FROM Klient WHERE id_klient=NEW.id_klient AND Pozwolenie='1')
		THEN RETURN NEW;
	ELSE
		RAISE EXCEPTION 'Klient nie ma pozwolenia!';
	END IF;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER pozwolenie
BEFORE INSERT ON Adopcja 
FOR EACH ROW
EXECUTE PROCEDURE pozwolenie();
--8b) Sprawdzenie, ¿e wyzwalacz 3 dzia³a
UPDATE Klient SET Pozwolenie=CAST(0 AS BIT) WHERE id_Klient=1;
INSERT INTO Adopcja (id_Zwierze,id_Pracownik,id_Klient,Data_adopcji,Oplata)
VALUES (7,1,1,'2010/10/10',100);
--9a) Tworzymy wyzwalacz 4
--Wyzwalacz przenosi usuniete zwierzeta do innej tabeli
CREATE TABLE IF NOT EXISTS usuniete_zwierze
(
	id_Zwierze INT  NOT NULL PRIMARY KEY,
	id_Rasa INT  NOT NULL REFERENCES Rasa (id_Rasa),
	id_Typ INT  NOT NULL REFERENCES Typ (id_Typ),
	Imie VARCHAR(20) NOT NULL,
	data_urodzenia DATE NOT NULL,
	Opis TEXT NOT NULL
);
--DROP TRIGGER usuniete_zwierze_tri;
CREATE OR REPLACE FUNCTION usuniete_zwierze_tri()
RETURNS TRIGGER
AS
$$
BEGIN
	INSERT INTO usuniete_zwierze VALUES(OLD.id_Zwierze,OLD.id_Rasa,OLD.id_Typ,OLD.Imie,OLD.data_urodzenia,OLD.Opis);
	DELETE FROM Adopcja WHERE id_Zwierze=OLD.id_Zwierze;
	DELETE FROM Przyjecie WHERE id_Zwierze=OLD.id_Zwierze;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER usuniete_zwierze_tri
BEFORE DELETE ON Zwierze 
FOR EACH ROW
EXECUTE PROCEDURE usuniete_zwierze_tri();
--9b) Sprawdzenie, ¿e wyzwalacz 4 dzia³a
DELETE FROM Zwierze WHERE id_Zwierze=8;
--10a) Tworzymy tabelê przestawn¹
--Tabela pokazuje liczbê specjalistów w danej dziedzinie
SELECT  sum(case when id_Specjalizacja = 1 then 1 end) AS Choroby_psow_i_kotow,
		sum(case when id_Specjalizacja = 2 then 1 end) AS Radiologia_Weterynaryjna,
        sum(case when id_Specjalizacja = 3 then 1 end) AS Chirurgia_Weterynaryjna,
        sum(case when id_Specjalizacja = 4 then 1 end) AS Choroby_Ryb,
        sum(case when id_Specjalizacja = 5 then 1 end) AS Choroby_Zwierzat_Nieudomowionych
    FROM Specjalista
    LIMIT 1;
--10b) Sprawdzenie, ¿e tabela przestawna dzia³a
INSERT INTO Specjalista VALUES (1,3);

