//
//  AuthController.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation
import Combine

class AuthController: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage = ""

    func login(username: String, password: String) {
        guard let url = URL(string: "http://localhost:8888/api.php") else {
            errorMessage = "URL invalide"
            return
        }

        let parameters = ["username": username, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            errorMessage = "Erreur de paramètres"
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }

                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                        if response.success {
                            guard let username = response.username, let role = response.role else {
                                self.errorMessage = "Données invalides"
                                return
                            }
                            self.currentUser = User(username: username, role: role)
                            self.errorMessage = ""
                        } else {
                            self.errorMessage = response.message ?? "Identifiants incorrects"
                        }
                    } catch {
                        self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                    }
                }
            }
        }.resume()
    }

    func logout() {
        currentUser = nil
    }
}
