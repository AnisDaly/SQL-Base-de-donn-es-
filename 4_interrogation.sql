/*
------------------------------------------------------------
Projet : Base de Données Football
Étape 5 : Interrogation de la BD
Fichier : 4_interrogation.sql
------------------------------------------------------------

Scénario d’utilisation : Direction sportive d’un club de football

La base de données est utilisée par le département sportif d’un grand club européen
pour analyser les performances des joueurs, suivre leurs carrières et préparer le marché
des transferts. Les données proviennent de plusieurs championnats, agents et saisons.

L’objectif est d’extraire des informations utiles pour :
- analyser les performances (buts, passes, matchs)
- identifier les meilleurs joueurs par championnat ou saison
- connaître les statistiques globales d’un club
- préparer le recrutement en fonction des performances
- observer les récompenses attribuées
------------------------------------------------------------
*/

------------------------------------------------------------
-- 1. Projections et Sélections
------------------------------------------------------------

-- 1️⃣ Liste des joueurs français triés par nom
SELECT Nom_joueur, Prenom_joueur, Nationalite_footballistique
FROM Joueur
WHERE Nationalite_footballistique = 'Française'
ORDER BY Nom_joueur;

-- 2️⃣ Joueurs nés entre 1995 et 2000
SELECT Nom_joueur, Prenom_joueur, Date_naissance_joueur
FROM Joueur
WHERE Date_naissance_joueur BETWEEN '1995-01-01' AND '2000-12-31';

-- 3️⃣ Noms et pays des championnats se jouant en Europe de l’Ouest
SELECT Nom_championnat, Pays
FROM Championnat
WHERE Pays IN ('France', 'Espagne', 'Allemagne', 'Angleterre', 'Italie');

-- 4️⃣ Sélection des stades ayant plus de 50 000 places
SELECT Nom_stade, Nombre_places
FROM Stade
WHERE Nombre_places > 50000
ORDER BY Nombre_places DESC;

-- 5️⃣ Joueurs dont le nom commence par 'M' et jouant au moins un match
SELECT DISTINCT Nom_joueur, Prenom_joueur
FROM Jouer
JOIN Joueur USING (ID_joueur)
WHERE Nom_joueur LIKE 'M%' AND Matchs > 0;


------------------------------------------------------------
-- 2. Fonctions d’Agrégation avec GROUP BY et HAVING
------------------------------------------------------------

-- 6️⃣ Moyenne de buts par joueur
SELECT ID_joueur, AVG(Buts) AS Moyenne_buts
FROM Jouer
GROUP BY ID_joueur
ORDER BY Moyenne_buts DESC;

-- 7️⃣ Total de buts par équipe
SELECT ID_equipe, SUM(Buts) AS Total_buts
FROM Jouer
GROUP BY ID_equipe
HAVING SUM(Buts) > 10;

-- 8️⃣ Nombre moyen de passes décisives par championnat
SELECT ID_championnat, AVG(Passes_decisives) AS Moyenne_passes
FROM Jouer
JOIN Equipe USING (ID_equipe)
GROUP BY ID_championnat;

-- 9️⃣ Nombre de joueurs par nationalité
SELECT Nationalite_footballistique, COUNT(*) AS Nb_joueurs
FROM Joueur
GROUP BY Nationalite_footballistique
ORDER BY Nb_joueurs DESC;

-- 🔟 Joueurs ayant marqué plus de 20 buts en moyenne
SELECT ID_joueur, AVG(Buts) AS MoyButs
FROM Jouer
GROUP BY ID_joueur
HAVING AVG(Buts) > 20;


------------------------------------------------------------
-- 3. Jointures internes, externes, simples, multiples
------------------------------------------------------------

-- 11️⃣ Liste des joueurs et des équipes pour chaque saison
SELECT J.Nom_joueur, J.Prenom_joueur, E.Nom_equipe, S.Annee_saison
FROM Jouer JR
JOIN Joueur J ON J.ID_joueur = JR.ID_joueur
JOIN Equipe E ON E.ID_equipe = JR.ID_equipe
JOIN Saison S ON S.ID_saison = JR.ID_saison;

-- 12️⃣ Joueurs et leurs agents
SELECT J.Nom_joueur, J.Prenom_joueur, A.Nom_agent, A.Prenom_agent
FROM Joueur J
JOIN Agent A ON J.ID_agent = A.ID_agent;

-- 13️⃣ Joueurs sans récompense
SELECT J.Nom_joueur, J.Prenom_joueur
FROM Joueur J
LEFT JOIN Recompenser R ON J.ID_joueur = R.ID_joueur
WHERE R.ID_joueur IS NULL;

-- 14️⃣ Nombre de récompenses par championnat
SELECT C.Nom_championnat, COUNT(R.distinction) AS Nb_recompenses
FROM Championnat C
LEFT JOIN Recompenser R ON C.ID_championnat = R.ID_championnat
GROUP BY C.Nom_championnat;

-- 15️⃣ Liste des joueurs, équipes et pays du championnat
SELECT J.Nom_joueur, E.Nom_equipe, C.Pays
FROM Jouer JR
JOIN Joueur J ON JR.ID_joueur = J.ID_joueur
JOIN Equipe E ON JR.ID_equipe = E.ID_equipe
JOIN Championnat C ON E.ID_championnat = C.ID_championnat;


------------------------------------------------------------
-- 4. Sous-requêtes imbriquées (IN, NOT IN, EXISTS, ANY, ALL)
------------------------------------------------------------

-- 16️⃣ Joueurs ayant reçu une récompense
SELECT Nom_joueur, Prenom_joueur
FROM Joueur
WHERE ID_joueur IN (SELECT ID_joueur FROM Recompenser);

-- 17️⃣ Joueurs n’ayant jamais reçu de récompense
SELECT Nom_joueur, Prenom_joueur
FROM Joueur
WHERE ID_joueur NOT IN (SELECT ID_joueur FROM Recompenser);

-- 18️⃣ Joueurs ayant plus de buts que la moyenne globale
SELECT Nom_joueur, Prenom_joueur
FROM Jouer J1
JOIN Joueur J2 ON J1.ID_joueur = J2.ID_joueur
WHERE Buts > (SELECT AVG(Buts) FROM Jouer);

-- 19️⃣ Joueurs appartenant à des équipes ayant plus de 30 buts marqués
SELECT Nom_joueur, Prenom_joueur
FROM Jouer
WHERE ID_equipe IN (
  SELECT ID_equipe
  FROM Jouer
  GROUP BY ID_equipe
  HAVING SUM(Buts) > 30
);

-- 20️⃣ Joueurs ayant joué dans tous les championnats existants
SELECT Nom_joueur, Prenom_joueur
FROM Joueur J
WHERE NOT EXISTS (
  SELECT *
  FROM Championnat C
  WHERE C.ID_championnat NOT IN (
    SELECT E.ID_championnat
    FROM Jouer JR
    JOIN Equipe E ON JR.ID_equipe = E.ID_equipe
    WHERE JR.ID_joueur = J.ID_joueur
  )
);
