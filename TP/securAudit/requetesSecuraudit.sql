///// REQUETES SECURAUDIT /////

C1 .

SELECT frais.dateRealisation, CONCAT(frais.montant, ' €') frais, categorie.libelle
FROM frais
JOIN categorie ON categorie.idCategorie = frais.idCategorie
WHERE frais.estRembourse = 0
ORDER BY frais.montant DESC;

C2.

SELECT industrie.numeroSiret, industrie.raisonSociale, auditeur.nom, auditeur.prenom, audit.dateDebut, audit.duree
FROM industrie
JOIN audit ON audit.idIndustrie = industrie.idIndustrie
JOIN auditeur ON auditeur.idAuditeur = audit.idAuditeur
WHERE audit.duree = 2 OR audit.duree = 3
ORDER BY audit.dateDebut ASC;

C3.

SELECT ROUND(AVG(montant),2) `Moyenne des frais`
FROM frais

C4.

SELECT categorie.libelle, CONCAT(ROUND(AVG(frais.montant),2), ' €') 'montant moyen'
FROM categorie
JOIN frais on frais.idCategorie = categorie.idCategorie
GROUP BY categorie.libelle

C5.

SELECT COUNT(*) 'nombre de frais', auditeur.nom, auditeur.prenom
FROM frais
JOIN audit ON audit.idAudit = frais.idAudit
JOIN auditeur ON auditeur.idAuditeur = audit.idAuditeur
WHERE YEAR(dateRealisation) = '2021'
GROUP BY auditeur.nom, auditeur.prenom
ORDER BY 'nombre de frais' DESC

C6.

SELECT categorie.libelle, frais.montant, IF(frais.estRembourse = 0, 'non', 'oui') estRembourse
FROM categorie
JOIN frais on frais.idCategorie = categorie.idCategorie
WHERE categorie.libelle = 'Restaurant' AND frais.montant > 80 AND frais.estRembourse = 0

C7.

DELETE frais FROM frais
JOIN categorie on categorie.idCategorie = frais.idCategorie
WHERE categorie.libelle = 'Restaurant' AND frais.montant > 80 AND frais.estRembourse = 0

C8.

SELECT *
FROM industrie
ORDER BY rand() limit 1;

C9.

UPDATE industrie
SET numeroSiret = 45398879200058, raisonSociale = 'Caloon SAS'
WHERE idIndustrie = 125;

C10.

SELECT audit.idAudit, frais.dateRealisation, SUM(montant) `montant total des frais`
FROM frais
JOIN audit ON audit.idAudit = frais.idAudit
JOIN industrie ON industrie.idIndustrie = audit.idIndustrie
WHERE industrie.idIndustrie = 125 AND YEAR(dateRealisation)=2020
GROUP BY frais.dateRealisation, audit.idAudit

/// alternative
SELECT A.idAudit, SUM(F.montant)
FROM Frais F
JOIN Audit A ON F.idAudit = A.idAudit
WHERE A.idIndustrie = 125
AND YEAR(dateDebut) = YEAR(CURDATE()) - 1
GROUP BY A.idAudit;

C11.

SELECT audit.dateDebut, industrie.idIndustrie, audit.coutJournalier*audit.duree `montant rapporté par chaque audit`
FROM audit 
JOIN industrie ON industrie.idIndustrie = audit.idIndustrie
WHERE YEAR(dateDebut) = 2020 AND industrie.idIndustrie = 125

C12.

SELECT Industrie.raisonSociale, SUM(Frais.montant) AS MontantDesFrais, audit.coutJournalier, audit.duree, (((audit.coutJournalier * audit.duree) - Frais.montant ) / 100 ) AS PourcentageRentabilité
FROM  audit
JOIN Industrie ON Audit.idIndustrie = Industrie.idIndustrie
JOIN Frais ON Frais.idAudit = audit.idAudit
GROUP BY Industrie.raisonSociale, audit.coutJournalier, audit.duree, (((audit.coutJournalier * audit.duree) - Frais.montant ) / 100 )