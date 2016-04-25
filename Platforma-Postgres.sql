CREATE TABLE jezyk (
  id_jezyk SERIAL PRIMARY KEY,
  nazwa_jezyk varchar(30) NOT NULL
)  ;

INSERT INTO jezyk (id_jezyk, nazwa_jezyk) VALUES
(1, 'Angielski'),
(2, 'Polski'),
(3, 'Niemiecki');

CREATE TABLE kategoria (
  id_kategoria SERIAL PRIMARY KEY,
  nazwa_kategoria varchar(30) NOT NULL,
  opis_kategoria text NOT NULL,
  dir_kategoria text,
  img_kategoria varchar(100) NOT NULL DEFAULT 'default.png'
)  ;

INSERT INTO kategoria (id_kategoria, nazwa_kategoria, opis_kategoria, dir_kategoria, img_kategoria) VALUES
(7, 'Podstawy', 'Podstawowe słówka.', '1eca15f2-ec39-4067-8977-30759a5ac923', 'icon-blue-m-easy-circle.png'),
(8, 'Człowiek', 'Słówka związane z ludźmi.', 'afae073a-d21b-40b7-a18d-c919db6da7a1', 'people.png'),
(9, 'Zwierzęta', 'Wszystko o zwierzętach.', 'f5c38024-44d3-42e9-a4fb-8aace725808e', 'Turtle.png'),
(10, 'Szkoła', 'Życie szkolne.', '1cccbc58-a516-4f69-9064-00891a06ad05', 'Categories-applications-education-school-icon.png');

CREATE TABLE konto (
  id_konto SERIAL PRIMARY KEY,
  rola_id int DEFAULT '1',
  imie_konto varchar(20) NOT NULL,
  nazwisko_konto varchar(30) NOT NULL,
  email_konto varchar(50) NOT NULL,
  login_konto varchar(30) NOT NULL,
  haslo_konto varchar(100) NOT NULL
)  ;

INSERT INTO konto (id_konto, rola_id, imie_konto, nazwisko_konto, email_konto, login_konto, haslo_konto) VALUES
(1, 1, 'Jan', 'Kowalski', 'user@user.com', 'Użytkownik', 'uzytkownik'),
(2, 3, 'Bartek', 'Kowalski', 'user@user.com', 'SuperRedaktor', 'superredaktor'),
(3, 4, 'Kacper', 'Kowalski', 'user@user.com', 'Administrator', 'administrator'),
(4, 2, 'Andrzej', 'Kowalski', 'user@user.com', 'Redaktor', 'redaktor');

CREATE TABLE podkategoria (
  id_podkategoria SERIAL PRIMARY KEY,
  kategoria_id int NOT NULL,
  nazwa_podkategoria varchar(30) NOT NULL,
  opis_podkategoria text NOT NULL,
  img_podkategoria varchar(100) DEFAULT 'default.png',
  dir_podkategoria text NOT NULL
)  ;

INSERT INTO podkategoria (id_podkategoria, kategoria_id, nazwa_podkategoria, opis_podkategoria, img_podkategoria, dir_podkategoria) VALUES
(8, 7, 'Dni Tygodnia', 'Słówka z dni tygodnia.', 'calendar.png', 'ea3de8a7-2c3f-4b92-bf0c-5cb5c663e654'),
(9, 7, 'Kolory', 'Nazwy kolorów.', 'color_icon.png', '876592b2-3672-4fcd-baff-cfbcee75322d'),
(10, 7, 'Liczby', 'Słówka z liczb.', 'number_phone_numbers_stroke-512.png', '5b6fe57b-8823-4cb5-b354-8a9c0af0a452'),
(11, 8, 'Charakter', 'Cechy charakteru.', 'bf5_0.png', '880e5f02-a065-4b03-8b40-a56994890954'),
(12, 8, 'Części ciała', 'Słówka z części ciała.', 'body-512.png', 'c23c0885-f12c-434a-bd7d-22edaf646b2f'),
(13, 8, 'Ubrania', 'Słówka z ubrań.', 'Clothes_Rack_furniture_icon_ID_633.png', '70b7aef8-cc44-4dae-9ea6-ec8c6d882517'),
(14, 8, 'Członkowie Rodziny', 'Rodzina.', 'grandmother2_freealluses.png', 'bdf86745-e2d1-42e3-93b2-3041c750f67a'),
(15, 9, 'Domowe', 'Zwierzęta w domu.', 'd311eb7f9e927ea7ba604387f6278558.jpg', '77f53af7-bc52-46f3-b5a1-ced1304e7785'),
(16, 9, 'Ptaki', 'Wszystko co lata.', 'bird-icon.png', '3e16c732-e9b3-4f04-99a7-41a6cd53ea2c'),
(17, 9, 'Ryby', 'Wodny świat.', 'dolphin_256.png', '5a82d08d-9ada-4ffe-87c9-7b146e2d0c9f'),
(18, 9, 'Dzikie', 'Dzikie zwierzęta.', 'lion-icon.png', 'af2a1993-0dcd-4424-8396-8fc5c00048e6'),
(19, 10, 'Biologia', 'Słówka z biologii.', 'biology_icon.jpg', '3f7b6f3f-042a-4e2f-8a3d-f3262a17f8af'),
(20, 10, 'Informatyka', 'Słówka z informatyki.', 'Computer.png', 'd5d261a9-1997-42e1-9afa-bfe11a4317fc'),
(21, 10, 'Chemia', 'Słówka z chemii.', '1280px-Alizarin_chemical_structure.png', '3f175142-85c0-4f48-94d8-f6ea3991aa76'),
(22, 10, 'Matematyka', 'Słówka z matematyki.', 'basic3-105_calculator-512.png', '6e15cb0d-dcbc-4fd7-83f9-81d4d8beb49f');

CREATE TABLE rola (
  id_rola SERIAL PRIMARY KEY,
  nazwa_rola varchar(30) NOT NULL,
  opis_rola text NOT NULL
)  ;

INSERT INTO rola (id_rola, nazwa_rola, opis_rola) VALUES
(1, 'Użytkownik', 'Zwykły użytkownik.'),
(2, 'Redaktor', 'Redaktor'),
(3, 'SuperRedaktor', 'SuperRedaktor'),
(4, 'Administrator', 'Administrator serwisu.');

CREATE TABLE slowo (
  id_slowo SERIAL PRIMARY KEY,
  jezyk_id int DEFAULT '0',
  nazwa_slowo varchar(30) NOT NULL
)  ;

INSERT INTO slowo (id_slowo, jezyk_id, nazwa_slowo) VALUES
(1, 2, 'czarny'),
(2, 1, 'black'),
(3, 2, 'szary'),
(4, 1, 'grey'),
(5, 2, 'biały'),
(6, 1, 'white'),
(7, 2, 'żółty'),
(8, 1, 'yellow'),
(9, 2, 'pomarańczowy'),
(10, 1, 'orange'),
(11, 2, 'zielony'),
(12, 1, 'green'),
(13, 2, 'brązowy'),
(14, 1, 'brown'),
(15, 2, 'różowy'),
(16, 1, 'pink'),
(17, 2, 'czerwony'),
(18, 1, 'red'),
(19, 2, 'złoty'),
(20, 1, 'golden'),
(21, 2, 'fioletowy'),
(22, 1, 'purple'),
(23, 2, 'niebieski'),
(24, 1, 'blue'),
(25, 2, 'jasnoniebieski'),
(26, 1, 'light blue'),
(27, 2, 'srebrny'),
(28, 1, 'silver'),
(29, 2, 'poniedziałek'),
(30, 1, 'Monday'),
(31, 2, 'wtorek'),
(32, 1, 'Tuesday'),
(33, 2, 'środa'),
(34, 1, 'Wednesday'),
(35, 2, 'czwartek'),
(36, 1, 'Thursday'),
(37, 2, 'piątek'),
(38, 1, 'Friday'),
(39, 2, 'sobota'),
(40, 1, 'Saturday'),
(41, 2, 'niedziela'),
(42, 1, 'Sunday'),
(43, 2, 'jeden'),
(44, 1, 'one'),
(45, 2, 'dwa'),
(46, 1, 'two'),
(47, 2, 'trzy'),
(48, 1, 'three'),
(49, 2, 'cztery'),
(50, 1, 'four'),
(51, 2, 'pięć'),
(52, 1, 'five'),
(53, 2, 'sześć'),
(54, 1, 'six'),
(55, 2, 'siedem'),
(56, 1, 'seven'),
(57, 2, 'osiem'),
(58, 1, 'eight'),
(59, 2, 'dziewięć'),
(60, 1, 'nine'),
(61, 2, 'dziesięć'),
(62, 1, 'ten'),
(63, 2, 'jedenaście'),
(64, 1, 'eleven'),
(65, 2, 'dwanaście'),
(66, 1, 'twelve'),
(67, 2, 'trzynaście'),
(68, 1, 'thirteen'),
(69, 2, 'czternaście'),
(70, 1, 'fourteen'),
(71, 2, 'piętnaście'),
(72, 1, 'fifteen'),
(73, 2, 'szesnaście'),
(74, 1, 'sixteen'),
(75, 2, 'siedemnaście'),
(76, 1, 'seventeen'),
(77, 2, 'osiemnaście'),
(78, 1, 'eighteen'),
(79, 2, 'dziewiętnaście'),
(80, 1, 'nineteen'),
(81, 2, 'dwadzieścia'),
(82, 1, 'twenty'),
(83, 2, 'agresywny'),
(84, 1, 'aggressive'),
(85, 2, 'ambitny'),
(86, 1, 'ambitious'),
(87, 2, 'arogancki'),
(88, 1, 'arrogant'),
(89, 2, 'chełpliwy'),
(90, 1, 'boastful'),
(91, 2, 'dominujący'),
(92, 1, 'bossy'),
(93, 2, 'dzielny'),
(94, 1, 'brave'),
(95, 2, 'bystry'),
(96, 1, 'bright'),
(97, 2, 'tolerancyjny'),
(98, 1, 'tolerant'),
(99, 2, 'opanowany'),
(100, 1, 'calm'),
(101, 2, 'szczery'),
(102, 1, 'candid'),
(103, 2, 'beztroski'),
(104, 1, 'carefree'),
(105, 2, 'niedbały'),
(106, 1, 'careless'),
(107, 2, 'cecha'),
(108, 1, 'characteristic'),
(109, 2, 'czarujacy'),
(110, 1, 'charming'),
(111, 2, 'bezczelny'),
(112, 1, 'insolent'),
(113, 2, 'nierozsądny'),
(114, 1, 'unwise'),
(115, 2, 'ciekawy'),
(116, 1, 'curious'),
(117, 2, 'cierpliwy'),
(118, 1, 'patient'),
(119, 2, 'czarujący'),
(120, 2, 'despotyczny'),
(121, 1, 'overbearing'),
(122, 2, 'dobrze wychowany'),
(123, 1, 'well-behaved'),
(124, 2, 'dumny'),
(125, 1, 'proud'),
(126, 2, 'dyskretny'),
(127, 1, 'discreet'),
(128, 2, 'egoistyczny'),
(129, 1, 'selfish'),
(130, 2, 'gadatliwy'),
(131, 1, 'talkative'),
(132, 2, 'chamski'),
(133, 1, 'rude'),
(134, 2, 'prostoduszny'),
(135, 1, 'naive'),
(136, 2, 'przebiegły'),
(137, 1, 'cunning'),
(138, 2, 'przezorny'),
(139, 1, 'prudent'),
(140, 2, 'przyjacielski'),
(141, 1, 'friendly'),
(142, 2, 'przyjemny'),
(143, 1, 'pleasant'),
(144, 2, 'rozsądny'),
(145, 1, 'reasonable'),
(146, 2, 'skromny'),
(147, 1, 'modest'),
(148, 2, 'spokojny'),
(149, 1, 'quiet'),
(150, 2, 'otwarty'),
(151, 1, 'open');

CREATE TABLE tlumaczenie (
  id_tlumaczenie SERIAL PRIMARY KEY,
  slowo_id_one int NOT NULL,
  slowo_id_two int NOT NULL
)  ;

INSERT INTO tlumaczenie (id_tlumaczenie, slowo_id_one, slowo_id_two) VALUES
(1, 2, 1),
(2, 4, 3),
(3, 6, 5),
(4, 8, 7),
(5, 10, 9),
(6, 12, 11),
(7, 14, 13),
(8, 16, 15),
(9, 18, 17),
(10, 20, 19),
(11, 22, 21),
(12, 24, 23),
(13, 26, 25),
(14, 28, 27),
(15, 30, 29),
(16, 32, 31),
(17, 34, 33),
(18, 36, 35),
(19, 38, 37),
(20, 40, 39),
(21, 42, 41),
(22, 44, 43),
(23, 46, 45),
(24, 48, 47),
(25, 50, 49),
(26, 52, 51),
(27, 54, 53),
(28, 56, 55),
(29, 58, 57),
(30, 60, 59),
(31, 62, 61),
(32, 64, 63),
(33, 66, 65),
(34, 68, 67),
(35, 70, 69),
(36, 72, 71),
(37, 74, 73),
(38, 76, 75),
(39, 78, 77),
(40, 80, 79),
(41, 82, 81),
(42, 84, 83),
(43, 86, 85),
(44, 88, 87),
(45, 90, 89),
(46, 92, 91),
(47, 94, 93),
(48, 96, 95),
(49, 98, 97),
(50, 100, 99),
(51, 102, 101),
(52, 104, 103),
(53, 106, 105),
(54, 108, 107),
(55, 110, 109),
(56, 112, 111),
(57, 114, 113),
(58, 116, 115),
(59, 118, 117),
(60, 110, 119),
(61, 121, 120),
(62, 123, 122),
(63, 125, 124),
(64, 127, 126),
(65, 129, 128),
(66, 131, 130),
(67, 133, 132),
(68, 135, 134),
(69, 137, 136),
(70, 139, 138),
(71, 141, 140),
(72, 143, 142),
(73, 145, 144),
(74, 147, 146),
(75, 149, 148),
(76, 151, 150);

CREATE TABLE uprawnienia (
  id_uprawnienia SERIAL PRIMARY KEY,
  konto_id int NOT NULL,
  podkategoria_id int NOT NULL
)  ;

INSERT INTO uprawnienia (id_uprawnienia, konto_id, podkategoria_id) VALUES
(1, 4, 10),
(2, 2, 12);

CREATE TABLE wynik (
  id_wynik SERIAL PRIMARY KEY,
  konto_id int NOT NULL,
  zestaw_id int NOT NULL,
  data_wynik timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  wynik_wynik int NOT NULL,
  komentarz_wynik varchar(100) NOT NULL
)  ;

INSERT INTO wynik (id_wynik, konto_id, zestaw_id, data_wynik, wynik_wynik, komentarz_wynik) VALUES
(1, 1, 6, '2016-04-24 12:25:01', 0, 'Polski - Angielski'),
(2, 1, 6, '2016-04-24 12:32:43', 45, 'Angielski - Polski'),
(3, 1, 2, '2016-04-24 12:32:43', 65, 'Angielski - Polski'),
(4, 1, 2, '2016-04-24 12:32:43', 85, 'Polski - Polski'),
(5, 1, 3, '2016-04-24 12:32:43', 95, 'Angielski - Polski'),
(6, 1, 4, '2016-04-24 12:32:43', 25, 'Polski - Polski'),
(7, 1, 5, '2016-04-24 12:32:43', 62, 'Angielski - Polski'),
(8, 1, 6, '2016-04-24 12:32:43', 64, 'Polski - Polski');

CREATE TABLE zestaw (
  id_zestaw SERIAL PRIMARY KEY,
  konto_id int DEFAULT '0',
  jezyk_id_one int DEFAULT '0',
  jezyk_id_two int DEFAULT '0',
  podkategoria_id int NOT NULL,
  nazwa_zestaw varchar(30) NOT NULL,
  ilosc_slowek_zestaw int NOT NULL DEFAULT '0',
  data_edycji_zestaw timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  prywatny_zestaw smallint NOT NULL
)  ;

INSERT INTO zestaw (id_zestaw, konto_id, jezyk_id_one, jezyk_id_two, podkategoria_id, nazwa_zestaw, ilosc_slowek_zestaw, data_edycji_zestaw, prywatny_zestaw) VALUES
(1, 3, 1, 2, 9, 'Kolory', 14, '2016-04-24 12:01:37', 0),
(2, 3, 1, 2, 8, 'Dni Tygodnia', 7, '2016-04-24 12:02:46', 0),
(3, 3, 1, 2, 10, 'Liczebniki', 20, '2016-04-24 12:04:00', 0),
(4, 3, 1, 2, 11, 'Cechy Charakteru', 14, '2016-04-24 12:06:09', 0),
(5, 3, 1, 2, 11, 'Cechy Indywidualne', 11, '2016-04-24 12:07:04', 0),
(6, 3, 1, 2, 11, 'Osobowość', 10, '2016-04-24 12:08:03', 0);

CREATE TABLE zestawienie (
  id_zestawienie SERIAL PRIMARY KEY,
  tlumaczenie_id int NOT NULL,
  zestaw_id int NOT NULL
)  ;

INSERT INTO zestawienie (id_zestawienie, tlumaczenie_id, zestaw_id) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1),
(11, 11, 1),
(12, 12, 1),
(13, 13, 1),
(14, 14, 1),
(15, 15, 2),
(16, 16, 2),
(17, 17, 2),
(18, 18, 2),
(19, 19, 2),
(20, 20, 2),
(21, 21, 2),
(22, 22, 3),
(23, 23, 3),
(24, 24, 3),
(25, 25, 3),
(26, 26, 3),
(27, 27, 3),
(28, 28, 3),
(29, 29, 3),
(30, 30, 3),
(31, 31, 3),
(32, 32, 3),
(33, 33, 3),
(34, 34, 3),
(35, 35, 3),
(36, 36, 3),
(37, 37, 3),
(38, 38, 3),
(39, 39, 3),
(40, 40, 3),
(41, 41, 3),
(42, 42, 4),
(43, 43, 4),
(44, 44, 4),
(45, 45, 4),
(46, 46, 4),
(47, 47, 4),
(48, 48, 4),
(49, 49, 4),
(50, 50, 4),
(51, 51, 4),
(52, 52, 4),
(53, 53, 4),
(54, 54, 4),
(55, 55, 4),
(56, 56, 5),
(57, 57, 5),
(58, 58, 5),
(59, 59, 5),
(60, 60, 5),
(61, 61, 5),
(62, 62, 5),
(63, 63, 5),
(64, 64, 5),
(65, 65, 5),
(66, 66, 5),
(67, 67, 6),
(68, 68, 6),
(69, 69, 6),
(70, 70, 6),
(71, 71, 6),
(72, 72, 6),
(73, 73, 6),
(74, 74, 6),
(75, 75, 6),
(76, 76, 6);

CREATE OR REPLACE FUNCTION slowo_change()
RETURNS TRIGGER 
AS
$$
BEGIN
	UPDATE zestaw SET ilosc_slowek_zestaw = ilosc_slowek_zestaw + 1, data_edycji_zestaw=CURRENT_TIMESTAMP WHERE id_zestaw = NEW.zestaw_id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER slowo_insert AFTER INSERT
ON zestawienie
FOR EACH ROW
EXECUTE PROCEDURE slowo_change();

CREATE TRIGGER slowo_delete AFTER DELETE
ON zestawienie
FOR EACH ROW
EXECUTE PROCEDURE slowo_change();

ALTER TABLE konto
  ADD CONSTRAINT login_konto UNIQUE (login_konto);

ALTER TABLE konto
  ADD CONSTRAINT konto_ibfk_1 FOREIGN KEY (rola_id) REFERENCES rola (id_rola) ON DELETE SET NULL;

ALTER TABLE podkategoria
  ADD CONSTRAINT podkategoria_ibfk_1 FOREIGN KEY (kategoria_id) REFERENCES kategoria (id_kategoria) ON DELETE CASCADE;

ALTER TABLE slowo
  ADD CONSTRAINT slowo_ibfk_1 FOREIGN KEY (jezyk_id) REFERENCES jezyk (id_jezyk) ON DELETE SET NULL;

ALTER TABLE tlumaczenie
  ADD CONSTRAINT tlumaczenie_ibfk_1 FOREIGN KEY (slowo_id_one) REFERENCES slowo (id_slowo) ON DELETE CASCADE,
  ADD CONSTRAINT tlumaczenie_ibfk_2 FOREIGN KEY (slowo_id_two) REFERENCES slowo (id_slowo) ON DELETE CASCADE;

ALTER TABLE uprawnienia
  ADD CONSTRAINT uprawnienia_ibfk_1 FOREIGN KEY (konto_id) REFERENCES konto (id_konto) ON DELETE CASCADE,
  ADD CONSTRAINT uprawnienia_ibfk_2 FOREIGN KEY (podkategoria_id) REFERENCES podkategoria (id_podkategoria) ON DELETE CASCADE;

ALTER TABLE wynik
  ADD CONSTRAINT wynik_ibfk_1 FOREIGN KEY (konto_id) REFERENCES konto (id_konto) ON DELETE CASCADE,
  ADD CONSTRAINT wynik_ibfk_2 FOREIGN KEY (zestaw_id) REFERENCES zestaw (id_zestaw) ON DELETE CASCADE;

ALTER TABLE zestaw
  ADD CONSTRAINT zestaw_ibfk_1 FOREIGN KEY (konto_id) REFERENCES konto (id_konto) ON DELETE SET NULL,
  ADD CONSTRAINT zestaw_ibfk_2 FOREIGN KEY (jezyk_id_one) REFERENCES jezyk (id_jezyk) ON DELETE SET NULL,
  ADD CONSTRAINT zestaw_ibfk_3 FOREIGN KEY (jezyk_id_two) REFERENCES jezyk (id_jezyk) ON DELETE SET NULL,
  ADD CONSTRAINT zestaw_ibfk_4 FOREIGN KEY (podkategoria_id) REFERENCES podkategoria (id_podkategoria) ON DELETE CASCADE;

ALTER TABLE zestawienie
  ADD CONSTRAINT tlumaczenie_ibfk_3 FOREIGN KEY (tlumaczenie_id) REFERENCES tlumaczenie (id_tlumaczenie) ON DELETE CASCADE,
  ADD CONSTRAINT zestawienie_ibfk_2 FOREIGN KEY (zestaw_id) REFERENCES zestaw (id_zestaw) ON DELETE CASCADE;