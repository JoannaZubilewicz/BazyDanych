CREATE DATABASE [Projekt_11213]
GO

USE [Projekt_11213]
GO

CREATE TABLE [Marki] (
ID_marki INT IDENTITY(1,1) PRIMARY KEY,  
nazwa_marki VARCHAR(30),
rok_zalozenia DATE, 
kraj VARCHAR(20)
) 
GO

CREATE TABLE [Modele] (
ID_modelu INT IDENTITY(1,1) PRIMARY KEY,
ID_marki INT ,
nazwa_modelu VARCHAR (30),
moc_silnika INT,
FOREIGN KEY (ID_marki) REFERENCES [Marki] (ID_marki) ON UPDATE SET NULL ON DELETE SET NULL
 ) 
 GO

 CREATE TABLE [Cennik] (
 ID_ceny INT IDENTITY (1,1) PRIMARY KEY,
 ID_modelu INT ,
 cena INT,
 data_OD DATE,
 data_DO DATE
 FOREIGN KEY (ID_modelu) REFERENCES [Modele] (ID_modelu) ON UPDATE SET NULL ON DELETE SET NULL

 ) 
 GO 

 CREATE TABLE [Pracownicy] (
 ID_pracownika INT IDENTITY (1,1) PRIMARY KEY,
 PESEL CHAR (11) UNIQUE,
 imie_pracownika VARCHAR (20),
 nazwisko_pracownika VARCHAR (30),
 stanowisko_pracy VARCHAR (40)
 )
  GO

 CREATE TABLE [Klienci] (
 ID_klienta INT IDENTITY (1,1) PRIMARY KEY,
 nr_dowodu CHAR (9) UNIQUE,
 imie_klienta VARCHAR(20),
 nazwisko_klienta VARCHAR (30) 
 )
 GO

 CREATE TABLE [Zamowienia] (
 ID_zamowienia INT IDENTITY (1,1) PRIMARY KEY ,
 ID_klienta INT,
 ID_pracownika INT,
 ID_modelu INT , 
 kwota_zamowienia INT,
 data_zamowienia DATE ,
 data_odbioru DATE,
 zrealizowano BIT,
 niezrealizowano BIT,
 FOREIGN KEY (ID_klienta) REFERENCES [Klienci] (ID_klienta) ON UPDATE SET NULL ON DELETE SET NULL,
 FOREIGN KEY (ID_pracownika) REFERENCES [Pracownicy] (ID_pracownika) ON UPDATE SET NULL ON DELETE SET NULL,
 FOREIGN KEY (ID_modelu) REFERENCES [Modele] (ID_modelu) ON UPDATE SET NULL ON DELETE SET NULL

 ) 
 GO

 INSERT INTO Marki (nazwa_marki , rok_zalozenia , kraj )
 VALUES 
 ('Jeep','1941-01-01', 'USA'),
 ('Bugatti','1909-06-06','Francja'),
 ('Mercedes-Benz','1881-05-05','Niemcy')

 GO 

 INSERT INTO Modele (ID_marki,nazwa_modelu,moc_silnika)
 VALUES
 (1,'Cherokee',260),
 (1,'Compass',260),
 (1,'Grand Cherokee',600),
 (2,'Veyron',1001),
 (2,'Chiron',1500 ),
 (3,'Actros',550),
 (3,'Klasa A', 150),
 (3,'Klasa B', 200)
  GO

  INSERT INTO Cennik (ID_modelu,cena,data_OD ,data_DO )
  VALUES 

  (1,100000,'2008-01-01','2013-01-01'),
  (1,90000,'2013-01-01','2018-01-01'),
  (2,99800,'2013-01-01','2014-01-01'),
  (2,80800,'2014-01-01','2018-01-01'),
  (3,110000,'2015-01-01','2018-01-01'),
  (4,6700000,'2016-01-01','2018-01-01'),
  (5,6000000,'2016-01-01','2020-01-01'),
  (6,190000,'2015-01-01','2017-01-01'),
  (7,300000,'2017-01-01','2018-01-01'),
  (8,350000,'2015-01-01','2018-01-01')
  GO

  INSERT INTO Pracownicy (PESEL,imie_pracownika,nazwisko_pracownika,stanowisko_pracy)
  VALUES
  ('87304286985','Andrzej','Chruściel','sprzedawca'),
  ('78937419923','Aleksander','Kowal','doradca'),
  ('72653675932','Łukasz','Zagórski','dyrektor do spraw marketingu'),
  ('29475616356','Robert','Rożek','sprzedawca'),
  ('96572522447','Kinga','Małek','doradca'),
  ('76264647690','Patrycja','Wirkowska','sprzedawca')
  GO

  INSERT INTO Klienci (nr_dowodu,imie_klienta,nazwisko_klienta)
  VALUES
  ('DAC465726','Patrycja','Gałuszka'),
  ('GAK683026','Jagoda','Nowak'),
  ('CAD742345','Agnieszka','Frysak'),
  ('KUG728459','Jakub','Syk'),
  ('GYS347592','Wiktor','Kukułka')
  GO

  INSERT INTO Zamowienia (ID_klienta,ID_pracownika ,ID_modelu,kwota_zamowienia,data_zamowienia, data_odbioru,zrealizowano, niezrealizowano)
  VALUES
  (1,1,8,300000,'2017-05-05','2017-06-05',1,0),
  (4,4,4,6700000,'2016-08-08','2016-09-08',1,0),
  (2,6,7,280000,'2017-09-01','2017-09-10',0,1),
  (3,1,6,180000,'2015-12-06','2015-12-06',1,0),
  (5,6,3,110000,'2017-10-10','2017-10-27',1,0),
  (1,4,1,100000,'2014-09-09','2014-09-18',1,0),
  (3,6,2,99000,'2017-06-17','2017-06-27',1,0),
  (5,4,2,99000,'2017-02-12','2017-02-16',1,0)
  GO


  CREATE SCHEMA [Raporty]
  GO

 CREATE VIEW Raporty.view1 AS
 SELECT Marki.nazwa_marki , COUNT (*) AS ilosc_sprzedanych_modeli , SUM (Zamowienia.kwota_zamowienia) AS laczna_kwota_zamowien
 FROM Zamowienia
 INNER JOIN Modele ON Zamowienia.ID_modelu=Modele.ID_modelu
 INNER JOIN Marki ON Modele.ID_marki=Marki.ID_marki
 GROUP BY Marki.nazwa_marki
 GO 

CREATE VIEW Raporty.view2 AS 
SELECT Zamowienia.ID_zamowienia, cast((cena-kwota_zamowienia)/cena AS DECIMAL(9,2)) AS rabat
FROM Zamowienia
INNER JOIN Cennik ON Zamowienia.ID_modelu = Cennik.ID_modelu AND Zamowienia.data_zamowienia >= Cennik.data_OD AND Zamowienia.data_zamowienia < Cennik.data_DO
GO

 CREATE VIEW Raporty.view3 AS
 SELECT Modele.nazwa_modelu
 FROM Zamowienia
 RIGHT JOIN Modele ON Modele.ID_modelu=Zamowienia.ID_modelu
 WHERE ID_zamowienia IS NULL

 CREATE VIEW Raporty.view4 AS
 SELECT Pracownicy.imie_pracownika+' ' +nazwisko_pracownika AS lista_pracownikow , COUNT (*), SUM (kwota_zamowienia) AS laczna_suma_zamowien
 FROM Pracownicy
 INNER JOIN Zamowienia ON Zamowienia.ID_pracownika=Pracownicy.ID_pracownika
 GROUP BY imie_pracownika, nazwisko_pracownika
