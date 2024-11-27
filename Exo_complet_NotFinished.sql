-- Drop the schema if it exists and create a new one
DROP SCHEMA IF EXISTS gestion_evenements CASCADE;
CREATE SCHEMA gestion_evenements;

-- Switch to the new schema
SET search_path TO gestion_evenements;

CREATE TABLE gestion_evenements.salles(
	id_salle SERIAL PRIMARY KEY,
	nom VARCHAR(50) NOT NULL CHECK (trim(nom) <> ''),
	ville VARCHAR(30) NOT NULL CHECK (trim(ville) <> ''),
	capacite INTEGER NOT NULL CHECK (capacite > 0)
);

CREATE TABLE gestion_evenements.festivals (
	id_festival SERIAL PRIMARY KEY,
	nom VARCHAR(100) NOT NULL CHECK (trim(nom) <> '')
);

CREATE TABLE gestion_evenements.evenements (
	salle INTEGER NOT NULL REFERENCES gestion_evenements.salles(id_salle),
	date_evenement DATE NOT NULL,
	nom VARCHAR(100) NOT NULL CHECK (trim(nom) <> ''),
	prix MONEY NOT NULL CHECK (prix >= 0 :: MONEY),
	nb_places_restantes INTEGER NOT NULL CHECK (nb_places_restantes >= 0),
	festival INTEGER REFERENCES gestion_evenements.festivals(id_festival),
	PRIMARY KEY (salle,date_evenement)
);

CREATE TABLE gestion_evenements.artistes(
	id_artiste SERIAL PRIMARY KEY,
	nom VARCHAR(100) NOT NULL CHECK (trim(nom) <> ''),
	nationalite CHAR(3) NULL CHECK (trim(nationalite) SIMILAR TO '[A-Z]{3}')
);

CREATE TABLE gestion_evenements.concerts(
	artiste INTEGER NOT NULL REFERENCES gestion_evenements.artistes(id_artiste),
	salle INTEGER NOT NULL,
	date_evenement DATE NOT NULL,
	heure_debut TIME NOT NULL,
	PRIMARY KEY(artiste,date_evenement),
	UNIQUE(salle,date_evenement,heure_debut),
	FOREIGN KEY (salle,date_evenement) REFERENCES gestion_evenements.evenements(salle,date_evenement)
);

CREATE TABLE gestion_evenements.clients (
	id_client SERIAL PRIMARY KEY,
	nom_utilisateur VARCHAR(25) NOT NULL UNIQUE CHECK (trim(nom_utilisateur) <> '' ),
	email VARCHAR(50) NOT NULL CHECK (email SIMILAR TO '%@([[:alnum:]]+[.-])*[[:alnum:]]+.[a-zA-Z]{2,4}' AND trim(email) NOT LIKE '@%'),
	mot_de_passe CHAR(60) NOT NULL
);

CREATE TABLE gestion_evenements.reservations(
	salle INTEGER NOT NULL,
	date_evenement DATE NOT NULL,
	num_reservation INTEGER NOT NULL, --pas de check car sera géré automatiquement
	nb_tickets INTEGER CHECK (nb_tickets BETWEEN 1 AND 4),
	client INTEGER NOT NULL REFERENCES gestion_evenements.clients(id_client),
	PRIMARY KEY(salle,date_evenement,num_reservation),
	FOREIGN KEY (salle,date_evenement) REFERENCES gestion_evenements.evenements(salle,date_evenement)
);


--Stored Procedures
-- Procedure to add a new salle (venue) in PostgreSQL
CREATE OR REPLACE FUNCTION gestion_evenements.add_salle(
    _nom_salle VARCHAR(50),
    _ville_salle VARCHAR(30),
    _capacite_salle INT
) RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO gestion_evenements.salles (nom, ville, capacite)
    VALUES (_nom_salle, _ville_salle, _capacite_salle)
    RETURNING id_salle INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure to add a new festival in PostgreSQL
CREATE OR REPLACE FUNCTION gestion_evenements.add_festival(
    _nom_festival VARCHAR(100)
) RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO gestion_evenements.festivals (nom)
    VALUES (_nom_festival)
    RETURNING id_festival INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure to add a new artist in PostgreSQL
CREATE OR REPLACE FUNCTION gestion_evenements.add_artiste(
    _nom_artiste VARCHAR(100),
    _nationalite_artiste CHAR(3)
) RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO gestion_evenements.artistes (nom, nationalite)
    VALUES (_nom_artiste, _nationalite_artiste)
    RETURNING id_artiste INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure to add a new client in PostgreSQL
CREATE OR REPLACE FUNCTION gestion_evenements.add_client(
    _nom_utilisateur_client VARCHAR(25),
    _email_client VARCHAR(50),
    _mot_de_passe_client CHAR(60)
) RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO gestion_evenements.clients (nom_utilisateur, email, mot_de_passe)
    VALUES (_nom_utilisateur_client, _email_client, _mot_de_passe_client)
    RETURNING id_client INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure to add a new event in PostgreSQL
-- CREATE OR REPLACE FUNCTION gestion_evenements.add_evenement(
--     _salle_evenement INT,
--     _date DATE,
--     _nom_evenement VARCHAR(100),
--     _prix_evenement MONEY,
--     _festival_evenement INT
-- ) RETURNS VOID AS $$
-- DECLARE
--     nb_places_restantes_evenement INT;
-- BEGIN
--     IF _date <= CURRENT_DATE THEN
--         RAISE EXCEPTION 'La date de l''evenement doit etre dans le futur';
--     END IF;
--     INSERT INTO gestion_evenements.evenements (salle, date_evenement, nom, prix, nb_places_restantes, festival)
--     VALUES (_salle_evenement, _date, _nom_evenement, _prix_evenement::MONEY, (SELECT s.capacite FROM gestion_evenements.salles s WHERE s.id_salle = _salle_evenement), _festival_evenement);
-- END;
-- $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION gestion_evenements.tg_bf_insert_evenement()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.date_evenement <= CURRENT_DATE) THEN
        RAISE EXCEPTION 'La date d''un événement ajouté doit être ultérieure à la date actuelle';
    END IF;

    NEW.nb_places_restantes = (SELECT s.capacite FROM gestion_evenements.salles s
                        WHERE NEW.salle = s.id_salle);
    RETURN NEW;
END
$$LANGUAGE plpgsql;

CREATE TRIGGER tg_bf_insert_evenement BEFORE INSERT ON gestion_evenements.evenements
FOR EACH ROW EXECUTE PROCEDURE gestion_evenements.tg_bf_insert_evenement();

-- Procedure to book a festival
CREATE OR REPLACE FUNCTION gestion_evenements.reserver_festival(
    _id_festival INTEGER,
    _id_client INTEGER,
    _nb_places INTEGER
) RETURNS VOID AS $$
DECLARE
    _evenement RECORD;
BEGIN
    FOR _evenement IN
            SELECT e.date_evenement, e.salle FROM gestion_evenements.evenements e
            WHERE e.festival = _id_festival
    LOOP
            PERFORM gestion_evenements.ajouter_reservation(_evenement.salle,
                            _evenement.date_evenement , _nb_places, _id_client);
    END LOOP;
END
$$LANGUAGE plpgsql;
