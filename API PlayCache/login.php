<?php
header("Content-Type: application/json");

// Lire le contenu brut de la requête
$jsonData = file_get_contents("php://input");

// Vérifier si des données ont été reçues
if (!$jsonData) {
    echo json_encode(["success" => false, "message" => "Aucune donnée reçue"]);
    exit();
}

// Décoder les données JSON
$data = json_decode($jsonData, true);

// Vérifier que le décodage a fonctionné
if (!$data) {
    echo json_encode(["success" => false, "message" => "Format JSON invalide"]);
    exit();
}

// Vérification des champs requis
if (!isset($data["username"]) || !isset($data["password"])) {
    echo json_encode(["success" => false, "message" => "Champs manquants"]);
    exit();
}

$username = $data["username"];
$password = $data["password"];

try {
    // Connexion à la base de données avec PDO
    $pdo = new PDO("mysql:host=localhost;dbname=PlayCache;charset=utf8", "root", "root", [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur de connexion DB"]);
    exit();
}

try {
    // Préparer la requête pour récupérer le rôle et le mot de passe hashé de l'utilisateur
    $stmt = $pdo->prepare("SELECT role, password FROM users WHERE username = ?");
    $stmt->execute([$username]);
    $user = $stmt->fetch();

    if ($user) {
        // Vérifier le mot de passe avec password_verify()
        if (password_verify($password, $user["password"])) {
            echo json_encode(["success" => true, "role" => $user["role"]]);
        } else {
            echo json_encode(["success" => false, "message" => "Identifiants incorrects"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Identifiants incorrects"]);
    }
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Erreur lors de l'exécution de la requête"]);
}
?>
