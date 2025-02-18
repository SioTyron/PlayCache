//
//  AddGameView.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation
import SwiftUI

struct AddGameView: View {
    @Binding var isPresented: Bool
    var refreshGames: () -> Void

    @State private var name = ""
    @State private var description = ""
    @State private var type = ""
    @State private var editor = ""
    @State private var nbPlayer = ""
    @State private var nbCards = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations du jeu")) {
                    TextField("Nom", text: $name)
                    TextField("Description", text: $description)
                    TextField("Nombre de Joueurs", text: $nbPlayer)
                    TextField("Nombre de Cartes", text: $nbCards)
                    TextField("Type", text: $type)
                    TextField("Éditeur", text: $editor)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }

                Section {
                    Button(action: {
                        addGame()
                    }) {
                        Text("Ajouter").font(.headline).foregroundColor(.white).padding().frame(maxWidth: .infinity).background(Color.blue).cornerRadius(10).shadow(radius: 5)
                    }
                    .disabled(name.isEmpty || description.isEmpty || type.isEmpty || editor.isEmpty)
                }
            }
            .navigationTitle("Ajouter un jeu")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private func addGame() {
        guard let url = URL(string: "http://localhost:8888/add_game.php") else {
            errorMessage = "URL invalide"
            return
        }

        let newGame = [
            "name": name,
            "description": description,
            "nb_player": nbPlayer,
            "nb_cards": nbCards,
            "type": type,
            "editor": editor
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: newGame) else {
            errorMessage = "Erreur d'encodage JSON"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    isPresented = false
                    refreshGames()
                } else {
                    self.errorMessage = "Erreur lors de l'ajout du jeu"
                }
            }
        }.resume()
    }
}
