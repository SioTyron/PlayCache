<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$dbname = "PlayCache";
$username = "root";
$password = "root";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur de connexion : " . $e->getMessage()]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["name"], $data["description"], $data["nb_player"], $data["nb_cards"], $data["type"], $data["editor"])) {
    echo json_encode(["success" => false, "message" => "Données incomplètes"]);
    exit;
}

$name = htmlspecialchars($data["name"]);
$description = htmlspecialchars($data["description"]);
$nb_player = intval($data["nb_player"]);
$nb_cards = intval($data["nb_cards"]);
$type = htmlspecialchars($data["type"]);
$editor = htmlspecialchars($data["editor"]);

try {
    $sql = "INSERT INTO jeux (name, description, nb_player, nb_cards, type, editor) 
            VALUES (:name, :description, :nb_player, :nb_cards, :type, :editor)";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ":name" => $name,
        ":description" => $description,
        ":nb_player" => $nb_player,
        ":nb_cards" => $nb_cards,
        ":type" => $type,
        ":editor" => $editor
    ]);

    echo json_encode(["success" => true, "message" => "Jeu ajouté avec succès"]);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur lors de l'ajout : " . $e->getMessage()]);
}
?>
