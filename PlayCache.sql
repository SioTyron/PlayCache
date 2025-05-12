-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:8889
-- Généré le : lun. 12 mai 2025 à 21:10
-- Version du serveur : 5.7.39
-- Version de PHP : 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `PlayCache`
--

-- --------------------------------------------------------

--
-- Structure de la table `jeux`
--

CREATE TABLE `jeux` (
  `id` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `nb_player` varchar(255) NOT NULL,
  `nb_cards` int(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `editor` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `jeux`
--

INSERT INTO `jeux` (`id`, `name`, `description`, `nb_player`, `nb_cards`, `type`, `editor`) VALUES
(1, 'Catan', 'Un jeu de stratégie où les joueurs collectent des ressources pour construire des colonies et des routes.', '3-4', 0, 'Stratégie', 'Kosmos'),
(3, 'Carcassonne', 'Un jeu de tuiles où les joueurs construisent des villes, des routes et des monastères.', '2-5', 72, 'Familial', 'Hans im Glück'),
(4, 'Ticket to Ride', 'Un jeu où les joueurs construisent des routes ferroviaires à travers l\'Amérique du Nord.', '2-5', 110, 'Familial', 'Days of Wonder'),
(5, 'Dominion', 'Un jeu de deck-building où les joueurs achètent des cartes pour construire leur deck.', '2-4', 500, 'Stratégie', 'Rio Grande Games'),
(6, 'Splendor', 'Un jeu de développement où les joueurs collectent des gemmes pour acheter des cartes de développement.', '2-4', 90, 'Familial', 'Space Cowboys'),
(7, 'Pandemic', 'Un jeu coopératif où les joueurs travaillent ensemble pour arrêter la propagation de maladies.', '2-4', 59, 'Coopératif', 'Z-Man Games'),
(8, 'Azul', 'Un jeu de placement de tuiles où les joueurs créent des motifs colorés.', '2-4', 100, 'Familial', 'Plan B Games'),
(9, 'Terraforming Mars', 'Un jeu de stratégie où les joueurs terraforment la planète Mars.', '1-5', 208, 'Stratégie', 'FryxGames'),
(10, 'Wingspan', 'Un jeu où les joueurs construisent un habitat pour les oiseaux.', '1-5', 5, 'Familial', 'Stonemaier Games'),
(11, 'Monopoly', 'Un jeu classique où les joueurs achètent, échangent et développent des propriétés pour gagner.', '2-8', 0, 'Familial', 'Hasbro'),
(12, 'Uno', 'Un jeu de cartes où les joueurs doivent se débarrasser de leurs cartes en suivant des règles simples.', '2-10', 108, 'Familial', 'Mattel'),
(13, 'Mille Bornes', 'Un jeu de cartes où les joueurs parcourent une distance de 1000 kilomètres en évitant les obstacles.', '2-6', 110, 'Familial', 'Dujardin'),
(14, 'Cluedo', 'Un jeu de déduction où les joueurs doivent découvrir qui a commis un meurtre, avec quelle arme et dans quelle pièce.', '2-6', 0, 'Familial', 'Hasbro'),
(15, 'Scrabble', 'Un jeu de lettres où les joueurs créent des mots sur un plateau pour marquer des points.', '2-4', 0, 'Familial', 'Mattel'),
(16, 'Risk', 'Un jeu de stratégie où les joueurs conquièrent des territoires et combattent pour dominer le monde.', '2-6', 0, 'Stratégie', 'Hasbro'),
(17, 'Trivial Pursuit', 'Un jeu de questions-réponses où les joueurs testent leurs connaissances générales.', '2-6', 0, 'Familial', 'Hasbro'),
(18, 'Dixit', 'Un jeu de devinettes où les joueurs utilisent des cartes illustrées pour faire deviner des histoires.', '3-6', 84, 'Familial', 'Libellud'),
(19, 'Les Aventuriers du Rail', 'Un jeu où les joueurs construisent des routes ferroviaires à travers le monde.', '2-5', 110, 'Familial', 'Days of Wonder'),
(20, 'Puerto Rico', 'Un jeu de stratégie où les joueurs développent des plantations à Porto Rico.', '2-5', 0, 'Stratégie', 'Rio Grande Games'),
(23, 'Jeu de la vie', 'Jeu simulant la vie', '1', 0, 'Simulation', 'Unity'),
(25, 'Test local', 'Bonjour', '0', 0, 'Bluff', 'Local');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'admin', 'admin', 'administrateur'),
(2, 'userPC', 'playcache', 'utilisateur');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `jeux`
--
ALTER TABLE `jeux`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `jeux`
--
ALTER TABLE `jeux`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
