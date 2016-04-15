CREATE TABLE kategoria
(
  id_kategoria INT NOT NULL AUTO_INCREMENT,
  nazwa_kategoria VARCHAR(30) NOT NULL,
  opis_kategoria TEXT NOT NULL,
  obrazek_kategoria VARCHAR(100),
  PRIMARY KEY (id_kategoria)
) ENGINE=INNODB;

CREATE TABLE podkategoria
(
  id_podkategoria INT NOT NULL AUTO_INCREMENT,
  kategoria_id INT NOT NULL,
  nazwa_podkategoria VARCHAR(30) NOT NULL,
  opis_podkategoria TEXT NOT NULL,
  obrazek_podkategoria VARCHAR(100),
  PRIMARY KEY (id_podkategoria),
  FOREIGN KEY (kategoria_id) REFERENCES kategoria(id_kategoria)
) ENGINE=INNODB;

CREATE TABLE jezyk
(
  id_jezyk INT NOT NULL AUTO_INCREMENT,
  nazwa_jezyk VARCHAR(30) NOT NULL,
  PRIMARY KEY (id_jezyk)
) ENGINE=INNODB;

CREATE TABLE rola
(
  id_rola INT NOT NULL AUTO_INCREMENT,
  nazwa_rola VARCHAR(30) NOT NULL,
  opis_rola TEXT NOT NULL,
  PRIMARY KEY (id_rola)
) ENGINE=INNODB;

CREATE TABLE slowo
(
  id_slowo INT NOT NULL AUTO_INCREMENT,
  jezyk_id INT NOT NULL,
  nazwa_slowo VARCHAR(30) NOT NULL,
  PRIMARY KEY (id_slowo),
  FOREIGN KEY (jezyk_id) REFERENCES jezyk(id_jezyk)
) ENGINE=INNODB;

CREATE TABLE tlumaczenie
(
  id_tlumaczenie INT NOT NULL AUTO_INCREMENT,
  slowo_id_one INT NOT NULL,
  slowo_id_two INT NOT NULL,
  PRIMARY KEY (id_tlumaczenie),
  FOREIGN KEY (slowo_id_one) REFERENCES slowo(id_slowo),
  FOREIGN KEY (slowo_id_two) REFERENCES slowo(id_slowo)
) ENGINE=INNODB;

CREATE TABLE konto
(
  id_konto INT NOT NULL AUTO_INCREMENT,
  rola_id INT NOT NULL,
  imie_konto VARCHAR(20) NOT NULL,
  nazwisko_konto VARCHAR(30) NOT NULL,
  email_konto VARCHAR(50) NOT NULL,
  login_konto VARCHAR(30) NOT NULL,
  haslo_konto VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_konto),
  FOREIGN KEY (rola_id) REFERENCES rola(id_rola)
) ENGINE=INNODB;

CREATE TABLE uprawnienia
(
  id_uprawnienia INT NOT NULL AUTO_INCREMENT,
  konto_id INT NOT NULL,
  podkategoria_id INT NOT NULL,
  PRIMARY KEY (id_uprawnienia),
  FOREIGN KEY (konto_id) REFERENCES konto(id_konto),
  FOREIGN KEY (podkategoria_id) REFERENCES podkategoria(id_podkategoria)
) ENGINE=INNODB;

CREATE TABLE zestaw
(
  id_zestaw INT NOT NULL AUTO_INCREMENT,
  konto_id INT NOT NULL,
  jezyk_id_one INT NOT NULL,
  jezyk_id_two INT NOT NULL,
  podkategoria_id INT NOT NULL,
  nazwa_zestaw VARCHAR(30) NOT NULL,
  ilosc_slowek_zestaw INT NOT NULL DEFAULT '0',
  data_edycji_zestaw TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  prywatny_zestaw BOOLEAN NOT NULL,
  PRIMARY KEY (id_zestaw),
  FOREIGN KEY (konto_id) REFERENCES konto(id_konto),
  FOREIGN KEY (jezyk_id_one) REFERENCES jezyk(id_jezyk),
  FOREIGN KEY (jezyk_id_two) REFERENCES jezyk(id_jezyk),
  FOREIGN KEY (podkategoria_id) REFERENCES podkategoria(id_podkategoria)
) ENGINE=INNODB;

CREATE TABLE wynik
(
  id_wynik INT NOT NULL AUTO_INCREMENT,
  konto_id INT NOT NULL,
  zestaw_id INT NOT NULL,
  data_wynik DATE NOT NULL,
  wynik_wynik INT NOT NULL,
  PRIMARY KEY (id_wynik),
  FOREIGN KEY (konto_id) REFERENCES konto(id_konto),
  FOREIGN KEY (zestaw_id) REFERENCES zestaw(id_zestaw)
) ENGINE=INNODB;

CREATE TABLE zestawienie
(
  id_zestawienie INT NOT NULL AUTO_INCREMENT,
  slowo_id INT NOT NULL,
  zestaw_id INT NOT NULL,
  PRIMARY KEY (id_zestawienie),
  FOREIGN KEY (slowo_id) REFERENCES slowo(id_slowo),
  FOREIGN KEY (zestaw_id) REFERENCES zestaw(id_zestaw)
) ENGINE=INNODB;

CREATE TRIGGER slowo_count AFTER
	INSERT ON zestawienie
	FOR EACH ROW
		UPDATE zestaw SET ilosc_slowek_zestaw = ilosc_slowek_zestaw + 1, data_edycji_zestaw=CURRENT_TIMESTAMP WHERE id_zestaw = NEW.zestaw_id;