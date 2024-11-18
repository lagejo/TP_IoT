-- Supprimer les tables existantes
DROP TABLE IF EXISTS Logement;
DROP TABLE IF EXISTS Facture;
DROP TABLE IF EXISTS Piece;
DROP TABLE IF EXISTS Capteur;
DROP TABLE IF EXISTS Mesure;
DROP TABLE IF EXISTS Type_capteur;

-- Création de la table Logement
CREATE TABLE Logement (
    id_loge INTEGER PRIMARY KEY AUTOINCREMENT,  
    adresse TEXT,                               
    numero_tel TEXT,                            
    IP TEXT,                                    
    date_insert TEXT                             
);

-- Création de la table Facture
CREATE TABLE Facture (
    id_fact INTEGER PRIMARY KEY AUTOINCREMENT,   
    type_facture TEXT,                           
    montant REAL,                                
    valeur_conso REAL,                           
    date_fact TEXT,                             
    id_loge INTEGER,                             
    FOREIGN KEY (id_loge) REFERENCES Logement(id_loge) 
);

-- Création de la table Piece
CREATE TABLE Piece (
    id_piece INTEGER PRIMARY KEY AUTOINCREMENT,  
    x REAL,
    y REAL,
    z REAL,
    id_loge INTEGER,                             
    FOREIGN KEY (id_loge) REFERENCES Logement(id_loge)  
);

-- Création de la table Type_capteur
CREATE TABLE Type_capteur (
    id_type INTEGER PRIMARY KEY AUTOINCREMENT, 
    unite_mesure TEXT
);

-- Création de la table Capteur
CREATE TABLE Capteur (
    id_capteur INTEGER PRIMARY KEY AUTOINCREMENT,   
    ref_commerciale TEXT,
    port_communication TEXT,
    date_insert TEXT,
    -- id_piece INTEGER,                             
    -- FOREIGN KEY (id_piece) REFERENCES Piece(id_piece),  
    id_type INTEGER,                             
    FOREIGN KEY (id_type) REFERENCES Type_capteur(id_type)  
);

-- Création de la table Mesure
CREATE TABLE Mesure (
    id_mesure INTEGER PRIMARY KEY AUTOINCREMENT,   
    valeur REAL,
    date_insert TEXT,  -- Correction de 'date_inster' en 'date_insert'
    id_capteur INTEGER,                             
    FOREIGN KEY (id_capteur) REFERENCES Capteur(id_capteur)  
);

-- Activer les clés étrangères si nécessaire (important dans certains environnements SQLite)
PRAGMA foreign_keys = ON;

-- Question 4 : Insertion dans la table Logement
INSERT INTO Logement (adresse, numero_tel, IP, date_insert)
VALUES ('123 Rue Exemple', '+33 1 23 45 67 89', '192.168.1.1', '2024-11-12');

-- Insertion des 4 pièces reliées au même logement via l'id_loge
INSERT INTO Piece (x, y, z,id_loge) --, id_loge
VALUES (1, 2, 3, 1);

INSERT INTO Piece (x, y, z, id_loge)
VALUES (2, 2, 3, 1);

INSERT INTO Piece (x, y, z, id_loge)
VALUES (3, 2, 3, 1);

INSERT INTO Piece (x, y, z, id_loge)
VALUES (4, 2, 3, 1);

-- Question 5 : Insertion dans la table Type_capteur
INSERT INTO Type_capteur (id_type, unite_mesure)
VALUES (1, 'mA');

INSERT INTO Type_capteur (id_type,unite_mesure)
VALUES (2, 'mV');

INSERT INTO Type_capteur (id_type, unite_mesure)
VALUES (3, '°C');

INSERT INTO Type_capteur (id_type,unite_mesure)
VALUES (4, 'm');

--Question 6 : 
INSERT INTO Capteur (ref_commerciale, port_communication,date_insert, id_type) --, id_piece ,
VALUES ('A3DR','12','13/07/2024',1); 

INSERT INTO Capteur (ref_commerciale, port_communication,date_insert,id_type) --id_piece 
VALUES ('A3DR','12','13/07/2024',1); 

--Question 7

--deux mesures pour le premier capteur
INSERT INTO Mesure (valeur, date_insert,id_capteur) --id_capteur
VALUES (23.5, '2024-11-12',1);  

INSERT INTO Mesure (valeur, date_insert,id_capteur)
VALUES (45.2, '2024-11-12',1);  

--deux mesures pour le deuxième capteur
INSERT INTO Mesure (valeur, date_insert, id_capteur)
VALUES (23.5, '2024-11-12', 2);  

INSERT INTO Mesure (valeur, date_insert, id_capteur)
VALUES (45.2, '2024-11-12', 2);  

--Question 8
-- création de 4 factures
INSERT INTO Facture (type_facture, montant, valeur_conso, date_fact, id_loge)
VALUES ('Électricité', 120.50, 350.5, '2024-11-01',1);

INSERT INTO Facture (type_facture, montant, valeur_conso, date_fact, id_loge)
VALUES ('Eau', 45.75, 150.3, '2024-11-05', 1);

INSERT INTO Facture (type_facture, montant, valeur_conso, date_fact, id_loge)
VALUES ('Chauffage', 90.00, 210.0, '2024-11-10', 1);

INSERT INTO Facture (type_facture, montant, valeur_conso, date_fact, id_loge)
VALUES ('Internet', 40.00, 0.0, '2024-11-15', 1);






