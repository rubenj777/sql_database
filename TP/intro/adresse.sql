-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : jeu. 07 oct. 2021 à 10:20
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

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `adresse`
--
ALTER TABLE `adresse`
  ADD PRIMARY KEY (`idAdresse`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
