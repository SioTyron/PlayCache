//
//  GameDetailView.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import SwiftUI

struct GameDetailView: View {
    let game: Game
    @Binding var selectedGame: Game?
    var isAdmin: Bool = false
    var refreshGames: (() -> Void)?

    @State private var name: String
    @State private var description: String
    @State private var nbPlayer: String
    @State private var nbCards: String
    @State private var type: String
    @State private var editor: String

    @State private var showDeleteConfirmation = false

    init(game: Game, selectedGame: Binding<Game?>, isAdmin: Bool = false, refreshGames: (() -> Void)? = nil) {
        self.game = game
        self._selectedGame = selectedGame
        self.isAdmin = isAdmin
        self.refreshGames = refreshGames

        _name = State(initialValue: game.name)
        _description = State(initialValue: game.description)
        _nbPlayer = State(initialValue: game.nbPlayer)
        _nbCards = State(initialValue: String(game.nbCards))
        _type = State(initialValue: game.type)
        _editor = State(initialValue: game.editor)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Infomations du jeu").font(.largeTitle).bold().padding()

            if isAdmin {
                Form {
                    Section(header: Text("Caractéristiques du jeu")) {
                        TextField("Nom", text: $name)
                        TextField("Description", text: $description)
                        TextField("Nombre de joueurs", text: $nbPlayer)
                        TextField("Nombre de cartes", text: $nbCards)
                        TextField("Type", text: $type)
                        TextField("Éditeur", text: $editor)
                    }
                }
                .padding()
            } else {
                Text(game.description)
                Text("👥 Nombre de joueurs **\(game.nbPlayer)**")
                Text("🃏 Nombre de cartes **\(game.nbCards)**")
                Text("🎲 Type **\(game.type)**")
                Text("🏢 Éditeur **\(game.editor)**")
                    .font(.body)
                    .padding()
            }

            Spacer()

            if isAdmin {
                Button(action: {
                    updateGame()
                }) {
                    Text("Enregistrer les modifications").frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(10).padding(.horizontal, 40)
                }

                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Supprimer le jeu").frame(maxWidth: .infinity).padding().background(Color.red).foregroundColor(.white).cornerRadius(10).padding(.horizontal, 40)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Supprimer ce jeu ?"),
                        message: Text("Cette action est irréversible."),
                        primaryButton: .destructive(Text("Supprimer")) {
                            deleteGame()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }

            Button(action: {
                selectedGame = nil
            }) {
                Text("Fermer").frame(maxWidth: .infinity).padding().background(Color.gray).foregroundColor(.white).cornerRadius(10).padding(.horizontal, 40)
            }
        }
        .padding()
    }

    private func updateGame() {
        guard let url = URL(string: "http://localhost:8888/update_game.php") else {
            print("URL d'update invalide")
            return
        }

        let updatedGame: [String: Any] = [
            "id": game.id,
            "name": name,
            "description": description,
            "nb_player": nbPlayer,
            "nb_cards": Int(nbCards) ?? 0,
            "type": type,
            "editor": editor
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updatedGame, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de la conversion des données en JSON : \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur réseau lors de la mise à jour du jeu: \(error.localizedDescription)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Réponse du serveur: \(responseString)")
            }

            DispatchQueue.main.async {
                selectedGame = nil
                refreshGames?()
            }
        }.resume()
    }

    private func deleteGame() {
        guard let url = URL(string: "http://localhost:8888/delete_game.php") else {
            print("URL de suppression invalide")
            return
        }

        let gameToDelete: [String: Any] = ["id": game.id]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: gameToDelete, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de la conversion des données en JSON : \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur réseau lors de la suppression du jeu: \(error.localizedDescription)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Réponse du serveur (suppression): \(responseString)")
            }

            DispatchQueue.main.async {
                selectedGame = nil
                refreshGames?()
            }
        }.resume()
    }
}

