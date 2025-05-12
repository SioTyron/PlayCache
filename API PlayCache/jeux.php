<?php
header('Content-Type: application/json');

// Configuration de la base de données
$dbHost = 'localhost';
$dbName = 'PlayCache';
$dbUser = 'root';
$dbPass = 'root';

try {
    $pdo = new PDO("mysql:host=$dbHost;dbname=$dbName;charset=utf8", $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur de connexion : " . $e->getMessage()]);
    exit;
}

try {
    $stmt = $pdo->query("SELECT id, name, description, nb_player, nb_cards, type, editor FROM jeux");
    $games = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($games);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur lors de la récupération des jeux : " . $e->getMessage()]);
}
?>
