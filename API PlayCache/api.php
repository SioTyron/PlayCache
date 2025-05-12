<?php
header("Content-Type: application/json");
$host = 'localhost';
$user = 'root';
$password = 'root';
$dbname = 'PlayCache';
$port = 8889;

$conn = new mysqli($host, $user, $password, $dbname, $port);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Erreur de connexion à la base de données"]));
}

$data = json_decode(file_get_contents('php://input'), true);
$username = $data['username'] ?? '';
$password = $data['password'] ?? '';

$stmt = $conn->prepare("SELECT username, role FROM users WHERE username = ? AND password = ?");
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode([
        "success" => true,
        "username" => $user['username'],
        "role" => $user['role']
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Nom d'utilisateur ou mot de passe incorrect"
    ]);
}

$conn->close();
?>