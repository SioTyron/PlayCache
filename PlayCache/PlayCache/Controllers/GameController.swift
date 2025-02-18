//
//  GameController.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation

class GameController {
    static let shared = GameController()
    private let baseURL = "http://localhost:8888"

    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/jeux.php") else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            do {
                let games = try JSONDecoder().decode([Game].self, from: data)
                DispatchQueue.main.async { completion(.success(games)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    func updateGame(game: Game, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/update_game.php") else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])
            completion(.failure(error))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dict: [String: Any] = [
            "id": game.id,
            "name": game.name,
            "description": game.description,
            "nb_player": game.nbPlayer,
            "nb_cards": game.nbCards,
            "type": game.type,
            "editor": game.editor
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            if let data = data, let responseStr = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async { completion(.success(responseStr)) }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide"])
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    func deleteGame(gameID: Int, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/delete_game.php") else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])
            completion(.failure(error))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dict: [String: Any] = ["id": gameID]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            if let data = data, let responseStr = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async { completion(.success(responseStr)) }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide"])
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
