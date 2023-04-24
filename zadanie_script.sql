CREATE DATABASE pracownicy CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci;

-- 1.Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE pracownik (
	id BIGINT primary key auto_increment UNIQUE,
    imie VARCHAR(30) , 
    nazwisko VARCHAR(30) NOT NULL, 
    wyplata DECIMAL, 
    data_urodzenia DATE NOT NULL,
    stanowisko VARCHAR(30) 
    ); 
    
-- 2.Wstawia do tabeli co najmniej 6 pracowników    
INSERT INTO pracownik (imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES 
('Tomasz', 'Janiszewski', 7400, '1995-12-12', 'programista'),
('Marcin', 'Kowal', 5800, '1995-12-12', 'tester'),
('Marta', 'Adamska', 7500, '1976-08-12', 'programista'),
('Ola', 'Pietruszka', 7200, '1995-11-12', 'tester'),
('Ignacy', 'Jan', 9100, '1987-05-12', 'malarz'),
('Zbigniew', 'Zero', 5100, '1991-06-12', 'marketingowiec');

-- 3.Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM pracownik ORDER BY nazwisko DESC;

-- 4.Pobiera pracowników na wybranym stanowisku
SELECT * FROM pracownik where (stanowisko = 'tester');

-- 5.Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM pracownik where (SELECT DATEDIFF(data_urodzenia, NOW())/ 365.25) > 30;
SELECT * FROM pracownik WHERE data_urodzenia <= CURRENT_DATE()-INTERVAL 30 YEAR; 

-- 5.Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
UPDATE pracownik SET wyplata = (wyplata*1.1) where id >0;

-- 6.Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM pracownik where (data_urodzenia) = (select MAX(data_urodzenia) from pracownik);

-- 7.Usuwa tabelę pracownik
DROP TABLE IF EXISTS pracownik ;

-- 9.Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
	id INT primary key auto_increment,
    nazwa VARCHAR(30) , 
    opis VARCHAR(30) NOT NULL, 
    wypłata DECIMAL
    ); 
    
-- 10. Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)   
    CREATE TABLE adres (
	id INT primary key auto_increment,
    ulica VARCHAR(30) NOT NULL,
    numer_domu VARCHAR(10) NOT NULL, 
    kod_pocztowy VARCHAR(6) NOT NULL,
    miejscowość VARCHAR(30) NOT NULL
    ); 
    
    -- 11. Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
    CREATE TABLE pracownik (
	id INT primary key auto_increment UNIQUE,
    imie VARCHAR(30) , 
    nazwisko VARCHAR(30) NOT NULL,
    adres_id INT NOT NULL,
    stanowisko_id INT NOT NULL,
    FOREIGN KEY (adres_id) REFERENCES adres (id),
    FOREIGN KEY (stanowisko_id) REFERENCES stanowisko (id)
    );
    
    
    -- 12. Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
    INSERT INTO pracownik (imie, nazwisko, stanowisko_id, adres_id)
VALUES 
('Tomasz', 'Janiszewski', 1, 1),
('Marcin', 'Kowal', 1, 1),
('Marta', 'Adamska', 3, 3),
('Ola', 'Pietruszka', 4, 4),
('Ignacy', 'Jan', 4, 2),
('Zbigniew', 'Zero', 2, 3);

INSERT INTO adres
    (ulica, numer_domu, kod_pocztowy, miejscowość)
VALUES
    ('Poznańska', '25', '66-500', 'Poznań'),
    ('Wrocławska', '26', '66-555', 'Wrocław'),
    ('Krakowska', '27', '66-566', 'Kraków'),
    ('Gdańsk', '28', '66-599', 'Gdańsk');
    
    INSERT INTO stanowisko
    (nazwa, opis, wypłata)
VALUES
    ('Programista', 'Szybko googla', 7400),
    ('Malarz', 'Kryje brudy zarządu', 10500),
    ('Marketing', 'Chodzi ładnie ubrany', 6900),
    ('Tester', 'Wkurza innych', 7800);

-- 13. Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT
	imie, nazwisko, ulica, numer_domu, kod_pocztowy, miejscowość, nazwa
FROM
	pracownik, adres, stanowisko 
WHERE
	stanowisko_id = stanowisko.id
    and
	adres_id = adres.id
;

-- 14. Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT SUM(wypłata) FROM stanowisko;

-- 15. Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT * FROM pracownik, adres where pracownik.adres_id = adres.id AND kod_pocztowy = '66-566';