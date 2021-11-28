-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : jeu. 07 oct. 2021 à 10:21
-- Version du serveur : 8.0.26
-- Version de PHP : 7.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `veteco`
--

-- --------------------------------------------------------

--
-- Structure de la table `adresse`
--

CREATE TABLE `adresse` (
  `idAdresse` int NOT NULL,
  `ligne1` varchar(38) NOT NULL,
  `ligne2` varchar(38) DEFAULT NULL,
  `ligne3` varchar(38) DEFAULT NULL,
  `codePostal` varchar(5) NOT NULL,
  `commune` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `adresse`
--

INSERT INTO `adresse` (`idAdresse`, `ligne1`, `ligne2`, `ligne3`, `codePostal`, `commune`) VALUES
(1, '1 rue lemot', NULL, NULL, '69001', 'Lyon'),
(2, '3 rue des fleurs', NULL, NULL, '34990', 'Ponterez'),
(3, '54 chemin des champs', NULL, NULL, '56770', 'Retrouvier');

-- --------------------------------------------------------

--
-- Structure de la table `categorie`
--

CREATE TABLE `categorie` (
  `idCategorie` int NOT NULL,
  `nom` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `categorie`
--

INSERT INTO `categorie` (`idCategorie`, `nom`) VALUES
(1, 'Pantalon'),
(2, 'T-shirt'),
(3, 'Chemise'),
(4, 'Short'),
(5, 'Jupe'),
(6, 'Chapeau'),
(7, 'Chaussure'),
(8, 'Chaussette');

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE `client` (
  `idClient` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `estHomme` tinyint(1) NOT NULL,
  `numTel` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `adrMail` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `idAdresse` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`idClient`, `nom`, `prenom`, `estHomme`, `numTel`, `adrMail`, `idAdresse`) VALUES
(1, 'Jallifier', 'Ruben', 1, '0613563917', 'ruben@gmail.com', 1),
(2, 'Majax', 'Abdel', 1, '0623568946', 'abdel@gmail.com', 2),
(3, 'Chap', 'Marie', 0, '0613569562', 'marie@gmail.com', 3),
(4, 'San', 'Sakura', 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

CREATE TABLE `commande` (
  `numero` varchar(10) NOT NULL,
  `dateRealisation` date NOT NULL,
  `idClient` int NOT NULL,
  `idMoyenPaiement` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `contenir`
--

CREATE TABLE `contenir` (
  `idVetement` int NOT NULL,
  `numero` varchar(10) NOT NULL,
  `quantite` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `mention`
--

CREATE TABLE `mention` (
  `idMention` int NOT NULL,
  `libelle` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `mention`
--

INSERT INTO `mention` (`idMention`, `libelle`) VALUES
(1, 'Issu du commerce équitable'),
(2, 'fabriqué en France'),
(3, 'coton bio'),
(4, 'Fibre recyclé');

-- --------------------------------------------------------

--
-- Structure de la table `moyenpaiement`
--

CREATE TABLE `moyenpaiement` (
  `idMoyenPaiement` int NOT NULL,
  `designation` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `moyenpaiement`
--

INSERT INTO `moyenpaiement` (`idMoyenPaiement`, `designation`) VALUES
(1, 'CB'),
(2, 'Chèque'),
(3, 'Virement'),
(4, 'Paypal');

-- --------------------------------------------------------

--
-- Structure de la table `rattacher`
--

CREATE TABLE `rattacher` (
  `idVetement` int NOT NULL,
  `idMention` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `vetement`
--

CREATE TABLE `vetement` (
  `idVetement` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `prix` decimal(10,2) NOT NULL,
  `pourHomme` tinyint(1) NOT NULL,
  `idCategorie` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `adresse`
--
ALTER TABLE `adresse`
  ADD PRIMARY KEY (`idAdresse`);

--
-- Index pour la table `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`idCategorie`);

--
-- Index pour la table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`idClient`),
  ADD KEY `Client_Adresse_FK` (`idAdresse`);

--
-- Index pour la table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`numero`),
  ADD KEY `Commande_Client_FK` (`idClient`),
  ADD KEY `Commande_MoyenPaiement_FK` (`idMoyenPaiement`);

--
-- Index pour la table `contenir`
--
ALTER TABLE `contenir`
  ADD PRIMARY KEY (`idVetement`,`numero`),
  ADD KEY `Contenir_Commande_FK` (`numero`);

--
-- Index pour la table `mention`
--
ALTER TABLE `mention`
  ADD PRIMARY KEY (`idMention`);

--
-- Index pour la table `moyenpaiement`
--
ALTER TABLE `moyenpaiement`
  ADD PRIMARY KEY (`idMoyenPaiement`);

--
-- Index pour la table `rattacher`
--
ALTER TABLE `rattacher`
  ADD PRIMARY KEY (`idVetement`,`idMention`),
  ADD KEY `Rattacher_Mention_FK` (`idMention`);

--
-- Index pour la table `vetement`
--
ALTER TABLE `vetement`
  ADD PRIMARY KEY (`idVetement`),
  ADD KEY `Vetement_Categorie_FK` (`idCategorie`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `categorie`
--
ALTER TABLE `categorie`
  MODIFY `idCategorie` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `client`
--
ALTER TABLE `client`
  MODIFY `idClient` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `mention`
--
ALTER TABLE `mention`
  MODIFY `idMention` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `moyenpaiement`
--
ALTER TABLE `moyenpaiement`
  MODIFY `idMoyenPaiement` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `vetement`
--
ALTER TABLE `vetement`
  MODIFY `idVetement` int NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `Client_Adresse_FK` FOREIGN KEY (`idAdresse`) REFERENCES `adresse` (`idAdresse`);

--
-- Contraintes pour la table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `Commande_Client_FK` FOREIGN KEY (`idClient`) REFERENCES `client` (`idClient`),
  ADD CONSTRAINT `Commande_MoyenPaiement_FK` FOREIGN KEY (`idMoyenPaiement`) REFERENCES `moyenpaiement` (`idMoyenPaiement`);

--
-- Contraintes pour la table `contenir`
--
ALTER TABLE `contenir`
  ADD CONSTRAINT `Contenir_Commande_FK` FOREIGN KEY (`numero`) REFERENCES `commande` (`numero`),
  ADD CONSTRAINT `Contenir_Vetement_FK` FOREIGN KEY (`idVetement`) REFERENCES `vetement` (`idVetement`);

--
-- Contraintes pour la table `rattacher`
--
ALTER TABLE `rattacher`
  ADD CONSTRAINT `Rattacher_Mention_FK` FOREIGN KEY (`idMention`) REFERENCES `mention` (`idMention`),
  ADD CONSTRAINT `Rattacher_Vetement_FK` FOREIGN KEY (`idVetement`) REFERENCES `vetement` (`idVetement`);

--
-- Contraintes pour la table `vetement`
--
ALTER TABLE `vetement`
  ADD CONSTRAINT `Vetement_Categorie_FK` FOREIGN KEY (`idCategorie`) REFERENCES `categorie` (`idCategorie`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
