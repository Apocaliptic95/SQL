--1a) Tworzymy widok
--Pokazuje liczbę opinii o każdym piwieCREATE VIEW ilosc_komentarzy
AS
	SELECT p.idPiwo, COUNT(o.idopinie) AS ilosc_opinii
	FROM Piwo p LEFT JOIN opinie o ON p.idopinie=o.idopinie
	GROUP BY p.idPiwo
	HAVING COUNT(o.idopinie)>0	ORDER BY p.idPiwo;--1b)Sprawdzenie czy działaSELECT * FROM ilosc_komentarzy;--2a) Tworzymy funkcję 1-- F-nkcja sprawdza ile jest opini w tabeli opinie--DROP FUNCTION ile_opiniCREATE OR REPLACE FUNCTION ile_opini()RETURNS INTAS$$BEGIN	RETURN (SELECT COUNT(*) FROM opinie);END;$$ LANGUAGE plpgsql;--2b) Sprawdzenie, że funkcja 1 działaSELECT ile_opini();--3a) Tworzymy funkcję 2CREATE OR REPLACE FUNCTION roznica_mocy()RETURNS INTAS$$BEGIN	RETURN ((SELECT MAX(moc) FROM opinie) - (SELECT MIN(moc) FROM opinie));END;$$ LANGUAGE plpgsql;--3b) Sprawdzenie, że funkcja 2 działaSELECT roznica_mocy() AS roznica;--4a) Tworzymy procedurę 1--Usuwa producentaCREATE OR REPLACE FUNCTION moc (id INT)RETURNS VARCHAR(15)AS$$SELECT CASE 			WHEN moc<2 THEN 'slabe'			WHEN moc BETWEEN 2 AND 7 THEN 'mocny'			WHEN moc>7 THEN 'bardzo_mocny' 			ELSE 'inne'			END			FROM opinie			WHERE idopinie=id$$ LANGUAGE SQL;--4b) Sprawdzenie, że procedura 1 działaSELECT moc(CAST(2 AS INT));--5a) Tworzymy procedurę 2--Wyświetlamy butelki wieksze lub rowne 500 ml, domyslnie procedura ustawiona na 300 mlCREATE OR REPLACE FUNCTION pojemność (zpojemność INT = 300)RETURNS SETOF butelkowanieAS$$	SELECT *	FROM butelkowanie	WHERE pojemność>=zpojemność	ORDER BY pojemność, kolor_butelki, idbutelkowanie$$ LANGUAGE SQL;--5b) Sprawdzenie czy procedura 2 działa--Poszukujemy butelki większej lub równej 500 ml.SELECT pojemność();SELECT pojemność(500);--6a) Tworzymy wyzwalacz 1--Blokada usuwania z tabeliCREATE OR REPLACE FUNCTION moc_jest_jedna()RETURNS TRIGGERAS$$BEGIN	RAISE EXCEPTION 'Moc jest jedna!';	RETURN NULL;END;$$ LANGUAGE plpgsql;CREATE TRIGGER moc_jest_jedna
BEFORE DELETE OR UPDATE OR INSERT
ON opinie
FOR EACH ROW
EXECUTE PROCEDURE moc_jest_jedna();--6b) Sprawdzenie, że wyzwalacz 1 działaDELETE FROM opinie;--9a) Tworzymy wyzwalacz 2--Wyświetlamy informacje o skasowamnym właśnie rekordzie z tabeli komentarzCREATE OR REPLACE FUNCTION usun_producenta()RETURNS TRIGGERAS$$BEGIN	 RAISE NOTICE 'Skasowane zostało: % % % %',OLD.numer_telefonu,OLD.ulica,OLD.kod_pocztowy,OLD.numer_budynku;	 RETURN OLD;END;$$ LANGUAGE plpgsql;CREATE TRIGGER usun_producenta
AFTER DELETE
ON dane_producenta
FOR EACH ROW
EXECUTE PROCEDURE usun_producenta();--7b) Sprawdzenie, że wyzwalacz 4 działaDELETE FROM dane_producenta WHERE id_kraj=1;--8a) Tworzymy wyzwalacz 3CREATE OR REPLACE FUNCTION blokada_numer()
RETURNS TRIGGER 
AS
$$
BEGIN
	IF EXISTS (SELECT * FROM kontakt k WHERE k.numer_tel_kom= NEW.numer_tel_kom) THEN
	RAISE EXCEPTION 'Podany numer istnieje!';
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER blokada_numer 
AFTER INSERT OR UPDATE
ON kontakt
FOR EACH ROW
EXECUTE PROCEDURE blokada_numer();--8b) Sprawdzenie, że wyzwalacz 3 działaINSERT INTO kontakt(idkontakt,idhurtownia,numer_tel_kom,numer_tel_stacj,fax,mail)
VALUES (7,2,23223,49645,77123,'ziemniak@gmail.com');--9a) Tworzymy wyzwalacz 4--Nie pozwalamy aby użytkownik nadał sobie nazwę użytkownika 'admin'CREATE OR REPLACE FUNCTION admin_blokada()RETURNS TRIGGERAS$$BEGIN	IF(NEW.nazwa='admin')		THEN RAISE EXCEPTION 'Nie mozna nadac nazwy admin!';	ELSE		RETURN NEW;	END IF;END;$$ LANGUAGE plpgsql;CREATE TRIGGER admin_blokadaBEFORE INSERT OR UPDATEON producent
FOR EACH ROW
EXECUTE PROCEDURE admin_blokada();--9b) Sprawdzenie, że wyzwalacz 4 działaINSERT INTO producent(nazwa,opis)VALUES ('admin','dobry');--10a) Tworzymy tabelę przestawną
SELECT  sum(case when moc = 2 then 1 end) AS Moc_2,
		sum(case when moc = 3 then 1 end) AS Moc_3,
        sum(case when moc = 5 then 1 end) AS Moc_5,
        sum(case when moc = 40 then 1 end) AS Moc_40
    FROM opinie
    LIMIT 1;