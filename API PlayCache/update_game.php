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

// Vérifier que tous les paramètres nécessaires sont présents
if (!isset($data['id']) ||
    !isset($data['name']) ||
    !isset($data['description']) ||
    !isset($data['nb_player']) ||
    !isset($data['nb_cards']) ||
    !isset($data['type']) ||
    !isset($data['editor'])) {
    echo json_encode(["success" => false, "message" => "Paramètres manquants"]);
    exit;
}

try {
    $stmt = $pdo->prepare("UPDATE jeux SET name = :name, description = :description, nb_player = :nb_player, nb_cards = :nb_cards, type = :type, editor = :editor WHERE id = :id");
    $stmt->bindParam(':id', $data['id'], PDO::PARAM_INT);
    $stmt->bindParam(':name', $data['name'], PDO::PARAM_STR);
    $stmt->bindParam(':description', $data['description'], PDO::PARAM_STR);
    $stmt->bindParam(':nb_player', $data['nb_player'], PDO::PARAM_STR);
    $stmt->bindParam(':nb_cards', $data['nb_cards'], PDO::PARAM_INT);
    $stmt->bindParam(':type', $data['type'], PDO::PARAM_STR);
    $stmt->bindParam(':editor', $data['editor'], PDO::PARAM_STR);
    
    $stmt->execute();
    
    echo json_encode(["success" => true, "message" => "Jeu mis à jour avec succès"]);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur lors de la mise à jour : " . $e->getMessage()]);
}
?>
