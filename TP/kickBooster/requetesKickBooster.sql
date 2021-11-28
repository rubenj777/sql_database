/////// KICK BOOSTER /////////



-- Insérez, en une seule requête, toutes les catégories de projet mentionnées dans l’énoncé

INSERT INTO categorie(libelle)
VALUES ('documentaire'), ('film'), ('serie'), ('jeu de société'), ('jeu vidéo'), ('gadget technologique');



-- Créez une procédure stockée qui ajoute aléatoirement entre 250 et 500 utilisateurs répondant aux critères ci-dessous, et exécutez-là :
-- ▪ Le nom, le prénom et l’adresse e-mail seront une suite de caractères aléatoires
-- ▪ La date de naissance sera aléatoirement comprise entre le 1er janvier 1920 et le 1er janvier 2010
-- ▪ Le mot de passe sera une suite de caractères aléatoires hachée en SHA-256 Utilisez la fonction SHA2() pour réaliser un hachage : SHA2('motDePasse', 256)

BEGIN
SET @maxi = 250 + RAND() * 250;
SET @i = 0;
WHILE @i < @maxi DO 
	SET @nomTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
	SET @prenomTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
	SET @mailTemp = CONCAT(CONV(FLOOR(RAND() * 99999999999999), 20, 36), '@gmail.com');
	SET @dateNaissanceTemp = '1920-01-01' + INTERVAL (RAND() * 32870) DAY;
	SET @motDePasseTemp = SHA2(CONV(FLOOR(RAND() * 99999999999999), 20, 36), 256);
INSERT INTO utilisateur(nom, prenom, adresseMail, dateNaissance, motDePasse)
VALUES (@nomTemp, @prenomTemp, @mailTemp, @dateNaissanceTemp, @motDePasseTemp);
SET @i = @i + 1;
END WHILE;
SELECT CONCAT(@i, 'utilisateurs ajoutés') AS resultat;
END

-- Obtenez la liste des catégories triée dans l’ordre alphabétique.

SELECT *
FROM categorie 
ORDER BY libelle ASC

-- Comptez le nombre total d’utilisateurs inscrit.

SELECT COUNT(*) 'nombreUtilisateur'
FROM utilisateur

-- Obtenez la liste des utilisateurs (prénom & nom concaténés et adresse e-mail) triée par nom.

SELECT CONCAT(utilisateur.nom, utilisateur.prenom) 'nomPrenom', utilisateur.adresseMail
FROM utilisateur
ORDER BY 'nomPrenom', utilisateur.adresseMail

-- Mettez en place un déclencheur empêchant l'insertion et la mise à jour d'un utilisateur si l'adresse e-mail est invalide.

BEGIN
IF (new.adresseMail NOT LIKE '_%@_%._%')
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'L''adresse email n''est pas valide';
END IF;
END

UPDATE utilisateur
SET adresseMail = 'ruben.jallifier@gmail.com'
WHERE idUtilisateur = 1000

-- Obtenez la liste des utilisateurs (prénom & nom concaténés, date de naissance et âge) triée du plus jeune au plus âgé.

SELECT CONCAT(utilisateur.nom, utilisateur.prenom) 'nomPrenom', utilisateur.dateNaissance, TIMESTAMPDIFF(YEAR, utilisateur.dateNaissance, CURDATE()) AS age
FROM utilisateur
ORDER BY `age` ASC 

-- Mettez en place un déclencheur empêchant l'insertion et la mise à jour d'un utilisateur âgé de moins de 16 ans.

BEGIN
SET @age = TIMESTAMPDIFF(YEAR, new.dateNaissance, CURDATE());
IF @age < 16
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'L''utilisateur doit avoir 16 ans ou plus';
END IF;
END

-- Créez une procédure stockée qui ajoute aléatoirement entre 150 et 300 projets répondant aux critères ci-dessous, et exécutez-là :
-- ▪ Le titre et la description seront une suite de caractères aléatoires.
-- ▪ L’objectif financier sera aléatoirement compris entre 1 000 € et 5 000 €.
-- ▪ La catégorie sera choisie au hasard parmi la liste des catégories.
-- ▪ L’utilisateur sera choisi au hasard parmi la liste des utilisateurs.

BEGIN
SET @maxi = 150 + RAND() * 150;
SET @i = 0;
WHILE @i < @maxi DO 
	SET @titreTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
	SET @descriptionTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
	SET @objectifTemp = (1000 + RAND() * 4000);
	SET @categorieTemp = (SELECT idCategorie FROM categorie ORDER BY RAND() LIMIT 1);
	SET @utilisateurTemp = (SELECT idUtilisateur FROM utilisateur ORDER BY RAND() LIMIT 1);
INSERT INTO projet(titre, description, objectifFinancier, idCategorie, idUtilisateur)
VALUES (@titreTemp, @descriptionTemp, @objectifTemp, @categorieTemp, @utilisateurTemp);
SET @i = @i + 1;
END WHILE;
SELECT CONCAT(@i, 'projets ajoutés') AS resultat;
END

-- Obtenez la liste des projets, avec leur utilisateur et leur catégorie (titre, objectif financier, prénom & nom concaténés et libellé de la catégorie),
-- triée du plus grand objectif financier au plus petit.

SELECT projet.titre, projet.objectifFinancier, CONCAT(utilisateur.prenom, utilisateur.nom) 'nomPrenom', categorie.libelle
FROM projet
JOIN utilisateur ON utilisateur.idUtilisateur = projet.idUtilisateur
JOIN categorie on categorie.idCategorie = projet.idCategorie
GROUP BY projet.titre, projet.objectifFinancier, `nomPrenom`, categorie.libelle
ORDER BY objectifFinancier DESC

-- Obtenez la liste des catégories, avec le nombre de projets existants pour chacune d'elle.

SELECT categorie.libelle, COUNT(projet.idProjet)
FROM categorie
JOIN projet ON projet.idCategorie = categorie.idCategorie
GROUP BY categorie.libelle

-- À l’aide d’une requête SQL, choisissez un projet au hasard, puis notez son id : 115
-- a. Mettez-le à jour en lui donnant un titre et une description de votre choix, et un objectif financier de 2 500 €.
-- b. Notez l’id de l’utilisateur correspondant : 344
-- c. Mettez à jour l'utilisateur correspondant pour qu'il porte votre nom et prénom.

SELECT *
FROM projet
ORDER BY RAND()
LIMIT 1;

UPDATE projet
SET titre = 'Le mystère de boule de gomme',
	description = 'La boule de gomme frappe encore, un coup dur pour le commissaire bonbon',
    objectifFinancier = 2500
WHERE idProjet = 115

UPDATE utilisateur
SET prenom = 'ruben',
	nom = 'jallifier-talmat'
WHERE idUtilisateur = 344

-- Créez une procédure stockée qui ajoute aléatoirement entre 500 et 3000 dons répondant aux critères ci-dessous, et exécutez-là :
-- ▪ La date sera aléatoirement comprise entre le 1er juillet 2021 et aujourd'hui.
-- ▪ Le montant sera aléatoirement compris entre 5 € et 100 €.
-- ▪ L’utilisateur sera choisi au hasard parmi la liste des utilisateurs.
-- ▪ Le projet sera choisi au hasard parmi la liste des projets.

BEGIN
SET @maxi = 500 + RAND() * 2500;
SET @i = 0;
WHILE @i < @maxi DO 
	SET @dateTemp = '2021-07-01' + INTERVAL RAND()*TIMESTAMPDIFF(MINUTE, '2021-07-01', CURDATE()) MINUTE;
	SET @montantTemp = (5 + RAND() * 95);
	SET @utilisateurTemp = (SELECT idUtilisateur FROM utilisateur ORDER BY RAND() LIMIT 1);
	SET @projetTemp = (SELECT idPRojet FROM projet ORDER BY RAND() LIMIT 1);	
INSERT INTO don(dateDon, montant, idUtilisateur, idProjet)
VALUES (@dateTemp, @montantTemp, @utilisateurTemp, @projetTemp);
SET @i = @i + 1;
END WHILE;
SELECT CONCAT(@i, 'dons ajoutés') AS resultat;
END

-- Écrivez les requêtes qui répondent à ces questions :
-- a. Quel est le montant total des dons fait sur votre projet ?
-- b. L'objectif financier de votre projet est-il atteint ?
-- c. À quel pourcentage l'objectif de votre projet est-il atteint ? Pour aller plus loin, n’hésitez pas à tester le fonctionnement de votre requête sur un projet sans don.

SELECT SUM(montant)
FROM don
WHERE idProjet = 115

SELECT SUM(montant), projet.objectifFinancier
FROM don
JOIN projet ON projet.idProjet = don.idProjet
WHERE projet.idProjet = 115

SELECT CONCAT(SUM(montant), ' €') AS montantReçu, CONCAT(projet.objectifFinancier, ' €') AS objectif, CONCAT(ROUND((100 * SUM(montant) / projet.objectifFinancier), 2), ' %') AS pourcentageObjectif
FROM don
JOIN projet ON projet.idProjet = don.idProjet
WHERE projet.idProjet = 115

-- Obtenez la liste des projets, avec le montant total des dons réalisés, leur utilisateur et leur catégorie, triée du plus grand montant total des dons au plus petit.

SELECT projet.titre, projet.description, projet.objectifFinancier, SUM(don.montant) AS montantTotal, CONCAT(utilisateur.prenom, utilisateur.nom) `nomPrenom`, categorie.libelle
FROM projet
JOIN don ON don.idProjet = projet.idProjet
JOIN utilisateur ON utilisateur.idUtilisateur = projet.idUtilisateur
JOIN categorie on categorie.idCategorie = projet.idCategorie
GROUP BY projet.titre, projet.description, projet.objectifFinancier, categorie.libelle, `nomPrenom`
ORDER BY `montantTotal` DESC

-- Obtenez la liste des projets, avec le montant total des dons réalisés, le pourcentage de l'objectif, leur utilisateur et leur catégorie, triée du plus grand pourcentage au plus petit.

SELECT categorie.idCategorie, projet.titre, projet.description, projet.objectifFinancier, SUM(don.montant) AS montantTotal, ROUND((100 * SUM(don.montant) / projet.objectifFinancier), 2) AS pourcentageObjectif, CONCAT(utilisateur.prenom, utilisateur.nom) `nomPrenom`, categorie.libelle
FROM projet
JOIN don ON don.idProjet = projet.idProjet
JOIN utilisateur ON utilisateur.idUtilisateur = projet.idUtilisateurx
JOIN categorie on categorie.idCategorie = projet.idCategorie
GROUP BY projet.titre, projet.description, projet.objectifFinancier, categorie.libelle, `nomPrenom`
ORDER BY `pourcentageObjectif` DESC

-- Depuis cette vue, sélectionnez tous les projets dont le pourcentage est inférieur à 90 %.

SELECT *
FROM `projvue`
WHERE `pourcentageObjectif` < 90

-- ALTERNATIVE 

SELECT *
FROM `projvue`
JOIN categorie ON projvue.idCategorie = categorie.idCategorie
WHERE `pourcentageObjectif` < 200

-- Faites-en sorte que votre projet contienne un don fait à vous-même.

INSERT INTO don(montant, idProjet, idUtilisateur, dateDon)
VALUES (150, '115', '344', '2021-09-15')

-- Obtenez la liste des dons sous cette forme :

SELECT projet.titre, don.montant, CONCAT(donneur.prenom, donneur.nom) AS donneur,  CONCAT(receveur.prenom, receveur.nom) AS receveur
FROM projet
JOIN utilisateur receveur ON receveur.idUtilisateur = projet.idUtilisateur
JOIN don ON don.idProjet = projet.idProjet 
JOIN utilisateur donneur ON don.idUtilisateur = donneur.idUtilisateur

-- Obtenez la liste des dons que des utilisateurs se sont fait à eux-mêmes.

SELECT projet.titre, don.montant, CONCAT(donneur.prenom, donneur.nom) AS donneur, CONCAT(receveur.prenom, receveur.nom) AS receveur
FROM projet
JOIN utilisateur receveur ON receveur.idUtilisateur = projet.idUtilisateur
JOIN don ON don.idProjet = projet.idProjet
JOIN utilisateur donneur ON don.idUtilisateur = donneur.idUtilisateur
WHERE donneur.idUtilisateur = receveur.idUtilisateur;

-- Supprimez les dons ainsi obtenus.

DELETE don FROM don
JOIN projet ON projet.idProjet = don.idProjet
WHERE don.idUtilisateur = projet.idUtilisateur;

-- Mettez en place un déclencheur empêchant ce type de don d’exister.

BEGIN 
SET @idUtilisateurRecevant = (SELECT idUtilisateur FROM projet WHERE idProjet = new.idProjet);
    IF (new.idUtilisateur = @idUtilisateurRecevant)
       THEN
        signal SQLSTATE '45300'
        SET Message_text = 'Impossible de se faire un don à soi-même';
    END IF;
END

-- Faites-en sorte que deux utilisateurs ne puissent pas avoir la même adresse e-mail.

BEGIN 
SET @nouvelleAdresse = (SELECT adresseMail FROM utilisateur WHERE adresseMail = new.adresseMail);
    IF (new.adresseMail = @nouvelleAdresse)
       THEN
        signal SQLSTATE '45300'
        SET Message_text = 'Cette adresse mail existe déjà';
    END IF;
END

-- IL EST RECOMMANDE DE RENTRE UN INDEX UNIQUE : ICI LA CREATION D'UN DECLENCHEUR N'EST PAS UTILE

-- Ajoutez les colonnes requises dans votre base de données, puis :
-- a. À tous les projets : indiquez une date de création aléatoirement comprise entre le 1er septembre 2021 et aujourd'hui et une durée aléatoirement comprise entre 15 et 75 J.
-- b. À tous les dons : indiquez qu'ils ne sont pas annulés.




















