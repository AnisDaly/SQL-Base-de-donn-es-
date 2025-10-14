USE football;

ALTER TABLE Adresse ADD CONSTRAINT CHK_Num_rue_Positive CHECK (Num_rue > 0);

ALTER TABLE Championnat MODIFY Nom_championnat VARCHAR(50) NOT NULL;
ALTER TABLE Championnat MODIFY Pays VARCHAR(50) NOT NULL;

ALTER TABLE Saison MODIFY Annee_saison VARCHAR(50) NOT NULL;
ALTER TABLE Saison ADD CONSTRAINT CHK_Annee_saison_Format CHECK (Annee_saison BETWEEN '1900' AND '2025');

ALTER TABLE Agent MODIFY Nom_agent VARCHAR(50) NOT NULL;
ALTER TABLE Agent MODIFY Prenom_agent VARCHAR(50) NOT NULL;
ALTER TABLE Agent MODIFY Nationalite_agent VARCHAR(50) NOT NULL;
ALTER TABLE Agent ADD CONSTRAINT CHK_Date_naissance_Agent CHECK (Date_naissance_agent <= '2007-01-01');

ALTER TABLE Stade MODIFY Nom_stade VARCHAR(50) NOT NULL;
ALTER TABLE Stade ADD CONSTRAINT CHK_Nombre_places_Positive CHECK (Nombre_places > 0);

ALTER TABLE Equipe MODIFY Nom_equipe VARCHAR(50) NOT NULL;

ALTER TABLE Joueur MODIFY Nom_joueur VARCHAR(50) NOT NULL;
ALTER TABLE Joueur MODIFY Prenom_joueur VARCHAR(50) NOT NULL;
ALTER TABLE Joueur MODIFY Nationalite_footballistique VARCHAR(50) NOT NULL;
ALTER TABLE Joueur ADD CONSTRAINT CHK_Date_naissance_Joueur CHECK (Date_naissance_joueur <= '2009-01-01');

ALTER TABLE Jouer ADD CONSTRAINT CHK_Buts_NonNegatif CHECK (Buts >= 0),
ADD CONSTRAINT CHK_Passes_NonNegatif CHECK (Passes_decisives >= 0),
ADD CONSTRAINT CHK_Matchs_NonNegatif CHECK (Matchs >= 0);
