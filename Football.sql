USE football;

CREATE TABLE Adresse (
  Num_adresse        INT          NOT NULL,
  Num_rue            INT          NOT NULL,
  Nom_rue            VARCHAR(50)  NOT NULL,
  Nom_ville          VARCHAR(50)  NOT NULL,
  CONSTRAINT PK_Adresse PRIMARY KEY (Num_adresse)
) ;

CREATE TABLE Championnat (
  ID_championnat     INT          NOT NULL,
  Nom_championnat    VARCHAR(50)  NOT NULL,
  Pays               VARCHAR(50)  NOT NULL,
  CONSTRAINT PK_Championnat PRIMARY KEY (ID_championnat)
) ;

CREATE TABLE Saison (
  ID_saison          INT          NOT NULL,
  Annee_saison       VARCHAR(50)  NOT NULL,
  CONSTRAINT PK_Saison PRIMARY KEY (ID_saison)
) ;

CREATE TABLE Agent (
  ID_agent               INT          NOT NULL,
  Nom_agent              VARCHAR(50)  NOT NULL,
  Prenom_agent           VARCHAR(50)  NOT NULL,
  Nationalite_agent      VARCHAR(50)  NOT NULL,
  Date_naissance_agent   DATE         NOT NULL,
  Num_adresse            INT          NULL,
  CONSTRAINT PK_Agent PRIMARY KEY (ID_agent),
  CONSTRAINT FK_Agent_Adresse
  FOREIGN KEY (Num_adresse) REFERENCES Adresse(Num_adresse) ON UPDATE CASCADE ON DELETE SET NULL
) ;

CREATE TABLE Stade (
  ID_stade           INT          NOT NULL,
  Nom_stade          VARCHAR(50)  NOT NULL,
  Nombre_places      INT          NOT NULL,
  Num_adresse        INT          NULL,
  CONSTRAINT PK_Stade PRIMARY KEY (ID_stade),
  CONSTRAINT FK_Stade_Adresse
  FOREIGN KEY (Num_adresse) REFERENCES Adresse(Num_adresse) ON UPDATE CASCADE ON DELETE SET NULL
) ;

CREATE TABLE Equipe (
  ID_equipe            INT          NOT NULL,
  Nom_equipe           VARCHAR(50)  NOT NULL,
  ID_championnat       INT          NULL,
  ID_saison            INT          NULL,
  ID_championnat_1     INT          NULL,
  ID_equipe_Parent     INT          NULL,
  ID_stade             INT          NULL,
  CONSTRAINT PK_Equipe PRIMARY KEY (ID_equipe),
  CONSTRAINT FK_Equipe_Championnat
  FOREIGN KEY (ID_championnat) REFERENCES Championnat(ID_championnat) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT FK_Equipe_Saison
  FOREIGN KEY (ID_saison) REFERENCES Saison(ID_saison) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT FK_Equipe_Championnat_1
  FOREIGN KEY (ID_championnat_1) REFERENCES Championnat(ID_championnat) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT FK_Equipe_Parent
  FOREIGN KEY (ID_equipe_Parent) REFERENCES Equipe(ID_equipe) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT FK_Equipe_Stade
  FOREIGN KEY (ID_stade) REFERENCES Stade(ID_stade) ON UPDATE CASCADE ON DELETE SET NULL
) ;

CREATE INDEX IX_Equipe_Championnat      ON Equipe (ID_championnat);
CREATE INDEX IX_Equipe_Championnat_1    ON Equipe (ID_championnat_1);
CREATE INDEX IX_Equipe_Saison           ON Equipe (ID_saison);
CREATE INDEX IX_Equipe_Stade            ON Equipe (ID_stade);

CREATE TABLE Joueur (
  ID_joueur                 INT          NOT NULL,
  Nom_joueur                VARCHAR(50)  NOT NULL,
  Prenom_joueur             VARCHAR(50)  NOT NULL,
  Nationalite_footballistique VARCHAR(50) NOT NULL,
  Date_naissance_joueur     DATE         NOT NULL,
  Num_adresse               INT          NULL,
  ID_agent                  INT          NULL,
  CONSTRAINT PK_Joueur PRIMARY KEY (ID_joueur),
  CONSTRAINT FK_Joueur_Adresse
  FOREIGN KEY (Num_adresse) REFERENCES Adresse(Num_adresse) ON UPDATE CASCADE ON DELETE SET NULL, 
  CONSTRAINT FK_Joueur_Agent
  FOREIGN KEY (ID_agent) REFERENCES Agent(ID_agent) ON UPDATE CASCADE ON DELETE SET NULL
) ;

CREATE INDEX IX_Joueur_Agent   ON Joueur (ID_agent);

CREATE TABLE Jouer (
  ID_joueur        INT NOT NULL,
  ID_equipe        INT NOT NULL,
  ID_saison        INT NOT NULL,
  Buts             INT NOT NULL DEFAULT 0,
  Passes_decisives INT NOT NULL DEFAULT 0,
  Matchs           INT NOT NULL DEFAULT 0,
  CONSTRAINT PK_Jouer PRIMARY KEY (ID_joueur, ID_equipe, ID_saison),
  CONSTRAINT FK_Jouer_Joueur FOREIGN KEY (ID_joueur)
  REFERENCES Joueur(ID_joueur) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_Jouer_Equipe FOREIGN KEY (ID_equipe)
  REFERENCES Equipe(ID_equipe) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_Jouer_Saison FOREIGN KEY (ID_saison)
  REFERENCES Saison(ID_saison) ON UPDATE CASCADE ON DELETE CASCADE
) ;

CREATE TABLE recompenser (
  ID_joueur        INT         NOT NULL,
  ID_championnat   INT         NOT NULL,
  distinction      VARCHAR(50) NOT NULL,
  CONSTRAINT PK_recompenser PRIMARY KEY (ID_joueur, ID_championnat, distinction),
  CONSTRAINT FK_recomp_Joueur FOREIGN KEY (ID_joueur)
  REFERENCES Joueur(ID_joueur) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_recomp_Championnat FOREIGN KEY (ID_championnat)
  REFERENCES Championnat(ID_championnat) ON UPDATE CASCADE ON DELETE CASCADE
) ;

CREATE INDEX IX_Agent_Adresse     ON Agent (Num_adresse);
CREATE INDEX IX_Stade_Adresse     ON Stade (Num_adresse);
CREATE INDEX IX_Joueur_Adresse    ON Joueur (Num_adresse);
