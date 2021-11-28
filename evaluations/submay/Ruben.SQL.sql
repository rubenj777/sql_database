C1.

INSERT INTO moyenpaiement(designation)
VALUES ('CB'), ('Espèce'), ('Chèque'), ('Titre restaurant');

C2.

INSERT INTO nature(nom)
VALUES ('Loyer'), ('Salaire'), ('Electricite'), ('Eau'), ('Fournitures'), ('Alimentaires')

D1.

UPDATE franchise
SET numeroSiret = 54457016800023, raisonSociale = 'Submay Mulhouse Centre', dateFondation = '2013-06-19', adresseMailGerant = 'direction@submay-mulhouse.fr'
WHERE idFranchise = 1;

D2.

SELECT *
FROM franchise
WHERE adresseMailGerant IS NULL

D3.

--n'ont pas fonctionné
DELETE FROM franchise
WHERE numeroSiret LIKE '5%'
---------------------------
DELETE FROM franchise, charge, note
WHERE numeroSiret LIKE '5%'
---------------------------------------
DELETE numeroSiret FROM franchise
JOIN charge ON charge.idFranchise = franchise.idFranchise
JOIN note ON note.idFranchise = franchise.idFranchise
WHERE numeroSiret LIKE '5%'
--------------------------------------------------------
DELETE franchise.numeroSiret FROM franchise
INNER JOIN charge
INNER JOIN note
WHERE franchise.numeroSiret LIKE '5%'

D4.

SELECT charge.idCharge, charge.dateApplication, charge.montant, nature.nom
FROM charge JOIN nature ON nature.idNature = charge.idNature
WHERE charge.montant >= 1000 AND charge.montant <= 2000
ORDER BY charge.montant ASC;

D5.

SELECT AVG(charge.montant)
FROM charge
JOIN nature ON nature.idNature = charge.idNature
WHERE nature.nom = 'Loyer'

D6.

SELECT note.idNote, note.dateRealisation, note.montant, IF(note.estEmporte = 1, 'A emporter', 'Sur place') AS Typologie, moyenpaiement.designation, franchise.raisonSociale
FROM note
JOIN moyenpaiement ON moyenpaiement.idMoyenPaiement = note.idMoyenPaiement
JOIN franchise ON franchise.idFranchise = note.idFranchise
WHERE moyenpaiement.designation = 'Espèce' OR moyenpaiement.designation = 'Chèque'
ORDER BY note.montant ASC

D7.

SELECT franchise.raisonSociale, COUNT(note.dateRealisation) AS nombreNotes
FROM franchise
JOIN note ON note.idFranchise = franchise.idFranchise
WHERE YEAR(note.dateRealisation) = 2021 AND MONTH(note.dateRealisation) = 09 AND note.aReductionFidelite = 0
GROUP BY franchise.raisonSociale

D9.






