--Obtenez le nombre de spécialistes pour chaque métier, triés du plus grand nombre au plus petit :

SELECT metier.intitule, COUNT(*) `Nombre de Spécialistes`
FROM metier
JOIN specialiste ON specialiste.idMetier = metier.idMetier
GROUP BY metier.intitule
ORDER BY `Nombre de Spécialistes` DESC;



--Listez les factures, avec pour chacune d’elle leur spécialiste, en calculant le montant TTC selon les règles fixées par l’énoncé, triées du plus grand montant HT au plus petit :

SELECT numero, raisonSociale, estAutoentrepreneur, montantHt, IF(estAutoentrepreneur=0, ROUND((montantHt*1.1),2), montantHt) AS montantTTC
FROM facture
JOIN specialiste ON facture.idSpecialiste = specialiste.idSpecialiste
ORDER BY facture.montantHt DESC;



--Listez les factures, avec pour chacune d’elle leur monument historique et leur spécialiste, triées de la date la plus ancienne à la date la plus récente :

SELECT numeroSiret, raisonSociale, estAutoentrepreneur, metier.intitule 'libellé du métier'
FROM specialiste
JOIN metier ON specialiste.idMetier = metier.idMetier
ORDER BY specialiste.raisonSociale;



--Listez les factures d’un montant HT de plus de 500 € dont le règlement est en espèces :

SELECT facture.numero, facture.montantHt
FROM facture
JOIN moyenpaiement ON facture.idMoyenPaiement = moyenpaiement.idMoyenPaiement
WHERE montantHT >= 500 AND moyenpaiement.designation = 'Espèces';



--Supprimez ces factures :
 
DELETE facture 
FROM facture
JOIN moyenpaiement ON facture.idMoyenPaiement = moyenpaiement.idMoyenPaiement
WHERE facture.montantHT >= 500 AND moyenpaiement.designation = 'Espèces';



---À l’aide de requêtes SQL, choisissez un spécialiste au hasard dans votre base de données, et  notez son id : _______, puis choisissez un monument historique au hasard
--dans votre base de données, et notez son id : _______

SELECT *
FROM specialiste
ORDER BY rand()
LIMIT 1; 



--Mettez à jour les infos spécialiste qui a l’id 99.

UPDATE specialiste
SET numeroSiret = 56450254000037, raisonSociale = 'Beaufils SAS', anneeFondation = 1956, estAutoentrepreneur = 0
WHERE idSpecialiste = 99;


--Obtenez le montant HT total des factures émises en 2020 par le spécialiste ci-dessus.

SELECT  SUM(montantHt) `montant total HT`
FROM facture
WHERE idSpecialiste = 99 AND YEAR(dateEmission)=2020;



--Obtenez le pourcentage de consommation du budget sur l’année 2021 pour ce  monument historique (par exemple : si pour le monument « Château Alpha »,
--ayant  un budget annuel de « 5 000 € », on constate « 6 000 € » de facture au total, le budget a été consommé à « 120 % » (dépassement du budget de 20 %).

SELECT ROUND(SUM(facture.montantHt)/monument.budget * 100) `Consommation du budget en % sur 2021`
FROM monument
JOIN facture ON facture.idMonument = monument.idMonument
WHERE monument.idMonument = 11 AND YEAR(dateEmission)=2021;


--Listez les 5 monuments historiques ayant le pourcentage de consommation de budget sur 2021 le plus élevé.

SELECT monument.nom, ROUND(SUM(facture.montantHt)/monument.budget * 100) `Consommation du budget en % sur 2021` 
FROM monument
JOIN facture ON facture.idMonument = monument.idMonument 
WHERE YEAR(dateEmission)=2021 
GROUP BY monument.idMonument 
ORDER BY `Consommation du budget en % sur 2021` DESC 
LIMIT 5;