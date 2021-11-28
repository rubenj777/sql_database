-- C2
INSERT INTO materiau(nom, montantParKilogramme)
VALUES ('Bois aggloméré', 0.06),
('Bois massif', 0.05),
('Mélaminé', 0.07),
('Métal', 0.05),
('Plastique', 0.09),
('Céramique', 0.06),
('Cuir', 0.08),
('Tissu', 0.06);

-- C3
BEGIN

 SET @maxi = 200 + RAND() * 300; 
 SET @i = 0;
 
 WHILE @i < @maxi DO
  SET @nomTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
  SET @referenceTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
  SET @descriptionTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
  SET @photoTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
  SET @largeurTemp = 300 + RAND() * 170;
  SET @hauteurTemp = 35 + RAND() * 145;
  SET @profondeurTemp = 30 + RAND() * 35;
  SET @poidsTemp = 2 + RAND() * 100;
  SET @prixTemp = 150 + RAND() * 2850;
  SET @idCollectionTemp = (SELECT idCollection FROM collection ORDER BY RAND() LIMIT 1);
  SET @idTypeTemp = (SELECT idType FROM type ORDER BY RAND() LIMIT 1);
  SET @idMateriauTemp = (SELECT idMateriau FROM materiau ORDER BY RAND() LIMIT 1);
  
  INSERT INTO meuble(nom, reference, description, cheminPhoto, largeur, hauteur, profondeur, poids, prix, idCollection, idType, idMateriau)
  VALUES(@nomTemp, @referenceTemp, @descriptionTemp, @photoTemp, @largeurTemp, @hauteurTemp, @profondeurTemp, @poidsTemp, @prixTemp, @idCollectionTemp, @idTypeTemp, @idMateriauTemp);
  
  SET @i = @i + 1;
 END WHILE;
 
 SELECT CONCAT(@i, 'meubles ajoutés') AS Resultat;
  
END

-- D
-- 1
BEGIN
	IF (new.reference IS NULL)
    THEN
    	SIGNAL SQLSTATE '45023'
 		SET MESSAGE_TEXT = 'Le meuble doit avoir une référence';
    END IF;
END

-- 2
BEGIN
	IF (new.reference != old.reference)
    THEN
    	SIGNAL SQLSTATE '45023'
 		SET MESSAGE_TEXT = 'La référence du meuble ne peut pas exister en doublon';
    END IF;
END

-- 3
BEGIN
	IF (new.largeur * new.hauteur * new.profondeur <= 1000)
    THEN
    	SIGNAL SQLSTATE '45023'
 		SET MESSAGE_TEXT = 'Le volume du meuble doit être supérieur ou égal à 1000cm3';
    END IF;
END

-- 4
BEGIN
	IF (new.poids < 2 AND new.poids > 100)
    THEN
    	SIGNAL SQLSTATE '45023'
 		SET MESSAGE_TEXT = 'Le poids du meuble doit être compris entre 2kg et 100kg';
    END IF;
END

-- 5
BEGIN
	IF (LENGHT(new.nom) < 3)
    THEN
    	SIGNAL SQLSTATE '45023'
 		SET MESSAGE_TEXT = 'Le nom du meuble doit avoir plus de trois caractères';
    END IF;
END

-- 6

-- E
-- 1
SELECT *
FROM meuble
WHERE nom = ' '

-- F
-- 1
SELECT *
FROM meuble
JOIN type ON type.idType = meuble.idType
WHERE type.nom = 'Table'

-- 2
SELECT meuble.nom AS 'Nom du meuble', type.nom AS 'Type', famille.libelle AS 'Famille', materiau.nom AS 'Materiau', CONCAT(meuble.prix, ' €') AS 'prix'
FROM meuble
JOIN type ON type.idType = meuble.idType
JOIN famille ON famille.idFamille = type.idFamille
JOIN materiau ON materiau.idMateriau = meuble.idMateriau
ORDER BY famille.libelle, meuble.prix DESC

-- 3
SELECT idMeuble
FROM meuble
ORDER BY RAND()
LIMIT 1;

-- 4
UPDATE meuble
SET nom = 'Lakolk', description = 'Ceci est un meuble', largeur = 136, hauteur = 50, profondeur = 49
WHERE idMeuble = 207;

-- 5
SELECT *
FROM meuble
JOIN type ON type.idType = meuble.idType
JOIN materiau ON materiau.idMateriau = meuble.idMateriau
WHERE type.nom = 'Canapé' AND NOT materiau.nom = 'Cuir' AND NOT materiau.nom = 'Tissu' AND meuble.largeur < 165;

-- 6
DELETE meuble FROM meuble
JOIN type ON type.idType = meuble.idType
JOIN materiau ON materiau.idMateriau = meuble.idMateriau
WHERE type.nom = 'Matelas' AND materiau.nom = 'Métal';

-- 7
SELECT famille.libelle AS 'Famille', CONCAT(ROUND(AVG(meuble.prix), 2), ' €') AS 'Prix moyen'
FROM famille
JOIN type ON type.idFamille = famille.idFamille
JOIN meuble ON meuble.idType = type.idType
GROUP BY famille.libelle

-- 8
-- tentative de résolution grâce à une variable - n'a pas abouti
SET @majoration = 0;

SELECT meuble.nom, type.montantForfaitaire, materiau.montantParKilogramme, type.montantForfaitaire + (materiau.montantParKilogramme * meuble.poids) AS 'Montant calculé selon le poids et le matériau du meuble', ROUND(((meuble.hauteur * meuble.largeur * meuble.profondeur) * 0.000001), 2) AS 'Volume en m3',
IF((meuble.hauteur * meuble.largeur * meuble.profondeur) > 1000000, 'Supérieur à 1m3', 'Inférieur à 1m3') AS 'Inférieur ou supérieur', IF((meuble.hauteur * meuble.largeur * meuble.profondeur) > 1000000, 'majoration de 0.50 €', 'pas de majoration') AS 'Majoration à appliquer', 
IF(meuble.hauteur * meuble.largeur * meuble.profondeur) > 1000000, @majoration = 0.50, @majoration = 0,
ROUND(type.montantForfaitaire + (materiau.montantParKilogramme * meuble.poids + @majoration)), 2 AS 'Montant de la majoration'
FROM meuble
JOIN type ON type.idType = meuble.idType
JOIN materiau ON materiau.idMateriau = meuble.idMateriau; 

-- 10
SELECT meubleavececopart, MAX(ecopart), MIN(ecopart), AVG(ecopart)
FROM meubleavececopart
GROUP BY ecopart




