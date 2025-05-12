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

// Récupérer les données JSON envoyées en POST
$input = file_get_contents("php://input");
$data = json_decode($input, true);

// Vérifier que l'identifiant du jeu est présent
if (!isset($data['id'])) {
    echo json_encode(["success" => false, "message" => "ID du jeu manquant"]);
    exit;
}

try {
    $stmt = $pdo->prepare("DELETE FROM jeux WHERE id = :id");
    $stmt->bindParam(':id', $data['id'], PDO::PARAM_INT);
    $stmt->execute();
    
    echo json_encode(["success" => true, "message" => "Jeu supprimé avec succès"]);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur lors de la suppression : " . $e->getMessage()]);
}
?>
