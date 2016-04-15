﻿--1a) Tworzymy widok
--Pokazuje liczbę opinii o każdym piwie
AS
	SELECT p.idPiwo, COUNT(o.idopinie) AS ilosc_opinii
	FROM Piwo p LEFT JOIN opinie o ON p.idopinie=o.idopinie
	GROUP BY p.idPiwo
	HAVING COUNT(o.idopinie)>0
BEFORE DELETE OR UPDATE OR INSERT
ON opinie
FOR EACH ROW
EXECUTE PROCEDURE moc_jest_jedna();
AFTER DELETE
ON dane_producenta
FOR EACH ROW
EXECUTE PROCEDURE usun_producenta();
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
EXECUTE PROCEDURE blokada_numer();
VALUES (7,2,23223,49645,77123,'ziemniak@gmail.com');
FOR EACH ROW
EXECUTE PROCEDURE admin_blokada();
SELECT  sum(case when moc = 2 then 1 end) AS Moc_2,
		sum(case when moc = 3 then 1 end) AS Moc_3,
        sum(case when moc = 5 then 1 end) AS Moc_5,
        sum(case when moc = 40 then 1 end) AS Moc_40
    FROM opinie
    LIMIT 1;