--Progettare un database per tenere traccia delle Opere d’arte presenti nei vari Musei.
--Ogni Museo è caratterizzato da un codice, un nome univoco, la Città in cui si trova.
--Di ogni museo è necessario tenere traccia delle Opere d’arte lì esposte.
--In particolare per ogni Opera d’arte le informazioni da salvare sono: 
--codice (che la identifica univocamente), Titolo, l’artista che l’ha realizzata e i personaggi eventualmente raffigurati.
--Dell’artista interessa tenere traccia del Nome (univoco) e della Nazionalità, 
--del Personaggio/i raffigurato/i invece del Nome.

CREATE database Museo;

CREATE TABLE Museo (
	IdMuseo INT IDENTITY(1,1),
	Nome NVARCHAR(50) NOT NULL unique,
	Città NVARCHAR(30) NOT NULL,
	CONSTRAINT PK_Museo PRIMARY KEY (IdMuseo)	
);

CREATE TABLE Artista (
	IdArtista INT IDENTITY(1,1),
	Nome NVARCHAR(30) NOT NULL unique,
	Nazionalità NVARCHAR(10) NOT NULL,
	CONSTRAINT PK_Artista PRIMARY KEY (IdArtista)	
);

CREATE TABLE Opera (
	IdOpera INT IDENTITY(1,1),
	Codice NVARCHAR(5) NOT NULL unique,
	Titolo NVARCHAR(50) NOT NULL,
	IdMuseo INT NOT NULL,
	IdArtista INT NOT NULL
	CONSTRAINT PK_Opera PRIMARY KEY (IdOpera)
	CONSTRAINT FK_Museo FOREIGN KEY (IdMuseo)	REFERENCES Museo (IdMuseo),
	CONSTRAINT FK_Artista FOREIGN KEY (IdArtista) REFERENCES Artista (IdArtista)
);

CREATE TABLE Personaggio (
	IdPersonaggio INT IDENTITY(1,1),
	Nome NVARCHAR(30) NOT NULL unique,	
	CONSTRAINT PK_Personaggio PRIMARY KEY (IdPersonaggio)	
);

CREATE TABLE PersonaggioOpera (
	IdOpera INT NOT NULL,
	IdPersonaggio INT NOT NULL	
	CONSTRAINT PK_OperaPersonaggio PRIMARY KEY (IdOpera,IdPersonaggio)
	CONSTRAINT FK_Opera FOREIGN KEY (IdOpera)	REFERENCES Opera (IdOpera),
	CONSTRAINT FK_Personaggio FOREIGN KEY (IdPersonaggio) REFERENCES Personaggio (IdPersonaggio)
);



INSERT INTO Museo VALUES ('MOMA', 'New York');
INSERT INTO Museo VALUES ('Louvre', 'Parigi');
INSERT INTO Museo VALUES ('Ermitage', 'San Pietroburgo');
INSERT INTO Museo VALUES ('National Gallery', 'Londra');
INSERT INTO Museo VALUES ('Galleria degli Uffizi', 'Firenze');
INSERT INTO Museo VALUES ('Museo del Prado', 'Madrid');
INSERT INTO Museo VALUES ('Museo e Galleria Borghese', 'Roma');
INSERT INTO Museo VALUES ('Tate Britain', 'Londra');
INSERT INTO Museo VALUES ('Musei Vaticani', 'Città del Vaticano');


INSERT INTO Artista VALUES ('Leonardo Da Vinci', 'Italiana');
INSERT INTO Artista VALUES ('Michelangelo', 'Italiana');
INSERT INTO Artista VALUES ('Caravaggio', 'Italiana');
INSERT INTO Artista VALUES ('Vincent Van Goghh', 'Olandese');
INSERT INTO Artista VALUES ('Claude Monet', 'Francese');
INSERT INTO Artista VALUES ('Salvator Dalì', 'Spagnola');
INSERT INTO Artista VALUES ('Pablo Picasso', 'Spagnola');
INSERT INTO Artista VALUES ('Paul Cezanne', 'Francese');
INSERT INTO Artista VALUES ('Auguste Renoir', 'Francese');
INSERT INTO Artista VALUES ('Raffaello', 'Italiana');
INSERT INTO Artista VALUES ('Alonso Berruguete', 'Spagnola');

INSERT INTO Opera VALUES ('A1234', 'Gioconda', 2, 1);
INSERT INTO Opera VALUES ('A5678', 'L’Annunciazione', 5, 1);
INSERT INTO Opera VALUES ('A9876', 'Tondo Doni', 5, 2);
INSERT INTO Opera VALUES ('B1234', 'Notte stellata', 1, 4);
INSERT INTO Opera VALUES ('B5678', 'Les Demoiselles d’Avignon', 1, 7);
INSERT INTO Opera VALUES ('C9809', 'Lo stagno delle ninfee', 4, 5);
INSERT INTO Opera VALUES ('C1234', 'Madonna del Cardellino', 5, 10);
INSERT INTO Opera VALUES ('D1234', 'Metamorfosi di Narciso', 8, 6);
INSERT INTO Opera VALUES ('E1234', 'La persistenza della memoria', 1, 6);
INSERT INTO Opera VALUES ('H4569', 'Madonna col Bambino', 5, 1002);
INSERT INTO Opera VALUES ('J9834', 'La Madonna Aldobrandini', 4, 10); 
INSERT INTO Opera VALUES ('L9126', 'Madonna dei Garofani', 4, 10); 

INSERT INTO Personaggio VALUES ('Donna');
INSERT INTO Personaggio VALUES ('Madonna');
INSERT INTO Personaggio VALUES ('Angelo');
INSERT INTO Personaggio VALUES ('Narciso');
INSERT INTO Personaggio VALUES ('Gesù Bambino');

INSERT INTO PersonaggioOpera VALUES (1,1);
INSERT INTO PersonaggioOpera VALUES (5,1);
INSERT INTO PersonaggioOpera VALUES (2,2);
INSERT INTO PersonaggioOpera VALUES (2,3);
INSERT INTO PersonaggioOpera VALUES (7,2);
INSERT INTO PersonaggioOpera VALUES (8,4);
INSERT INTO PersonaggioOpera VALUES (1002, 2);
INSERT INTO PersonaggioOpera VALUES (1002, 1002);
INSERT INTO PersonaggioOpera VALUES (1003, 2);
INSERT INTO PersonaggioOpera VALUES (1003, 1002);
INSERT INTO PersonaggioOpera VALUES (1004, 2);
INSERT INTO PersonaggioOpera VALUES (1004, 1002);


SELECT *
FROM Artista;

SELECT *
FROM Opera;

SELECT *
FROM Personaggio;

SELECT *
FROM PersonaggioOpera;

SELECT *
FROM Museo;


-- 1) Il nome dell’artista ed il titolo delle opere conservate alla “Galleria degli Uffizi” o alla “National Gallery”.
SELECT a.Nome AS 'Artista', o.Titolo
FROM Artista AS a
JOIN Opera AS o ON o.IdArtista = a.IdArtista
JOIN Museo AS m ON m.IdMuseo = o.IdMuseo
WHERE m.Nome = 'National Gallery' OR m.Nome = 'Galleria degli Uffizi'


-- 2)Il nome dell’artista ed il titolo delle opere di artisti spagnoli conservate nei musei di Firenze
SELECT a.Nome AS 'Artista', o.Titolo
FROM Artista AS a
JOIN Opera AS o ON o.IdArtista = a.IdArtista
JOIN Museo AS m ON m.IdMuseo = o.IdMuseo
WHERE a.Nazionalità = 'Spagnola' AND m.Città = 'Firenze'


--3)Il codice ed il titolo delle opere di artisti italiani conservate nei musei di Londra, in cui è rappresentata la Madonna
SELECT o.Codice, o.Titolo
FROM Opera AS o
JOIN Artista AS a ON a.IdArtista = o.IdArtista
JOIN Museo AS m ON m.IdMuseo = o.IdMuseo
JOIN PersonaggioOpera AS po ON po.IdOpera = o.IdOpera
JOIN Personaggio AS p ON p.IdPersonaggio = po.IdPersonaggio
WHERE m.Città = 'Londra' AND p.Nome = 'Madonna' AND a.Nazionalità = 'Italiana'


--4)Per ciascun museo di Londra, il numero di opere di artisti italiani ivi conservate
SELECT m.Nome, COUNT (*) AS 'Numero di opere'
FROM Museo AS m
JOIN Opera AS o ON o.IdMuseo = m.IdMuseo
JOIN Artista AS a ON o.IdArtista = a.IdArtista
WHERE a.Nazionalità = 'Italiana' AND m.Città = 'Londra'
GROUP BY m.Nome


--5)Il nome dei musei di Londra che non conservano opere di Tiziano
SELECT DISTINCT m.Nome
FROM Museo AS m
JOIN Opera AS o ON o.IdMuseo = m.IdMuseo
WHERE m.Città = 'Londra' AND m.Nome NOT IN
(SELECT m.Nome
FROM Artista AS a
WHERE a.Nome = 'Tiziano');


--6)Il nome dei musei di Londra che conservano solo opere di Tiziano
SELECT DISTINCT m.Nome
FROM Museo AS m
JOIN Opera AS o ON o.IdMuseo = m.IdMuseo
JOIN Artista AS a ON a.IdArtista = o.IdArtista
WHERE m.Città = 'Londra' AND m.Nome NOT IN
(SELECT DISTINCT m.Nome
FROM Museo AS m
JOIN Opera AS o ON o.IdMuseo = m.IdMuseo
JOIN Artista AS a ON a.IdArtista = o.IdArtista
WHERE a.Nome<> 'Tiziano')


--7)I musei che conservano almeno 20 opere di artisti italiani
SELECT DISTINCT m.Nome
FROM Museo AS m
JOIN Opera AS o ON o.IdMuseo = m.IdMuseo
JOIN Artista AS a ON a.IdArtista = o.IdArtista
WHERE a.Nazionalità = 'Italiana' 
GROUP BY m.Nome
HAVING Count (*) >=20


--8)Per ogni museo, il numero di opere divise per la nazionalità dell’artista
SELECT m.Nome AS 'Nome Museo', a.Nazionalità AS 'Nazionalità Artista', COUNT (*) AS 'Numero di Opere'
FROM Museo AS m
JOIN Opera AS o ON o.IdMuseo = m.IdMuseo
JOIN Artista AS a ON a.IdArtista = o.IdArtista
GROUP BY m.Nome, a.Nazionalità
ORDER BY m.Nome