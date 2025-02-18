//
//  AdminView.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//

import Foundation
import SwiftUI

struct AdminView: View {
    @EnvironmentObject var authController: AuthController
    @State private var games: [Game] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedGame: Game?
    @State private var searchText = ""
    @State private var isAddingGame = false // ✅ Ajout d'un état pour afficher le formulaire

    var filteredGames: [Game] {
        guard !searchText.isEmpty else { return games }
        return games.filter { game in
            game.name.localizedCaseInsensitiveContains(searchText) ||
            game.description.localizedCaseInsensitiveContains(searchText) ||
            game.type.localizedCaseInsensitiveContains(searchText) ||
            game.editor.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                        ForEach(filteredGames) { game in
                            GameCard(game: game)
                                .onTapGesture {
                                    selectedGame = game
                                }
                        }
                    }
                    .padding()
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Gestion des Jeux")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isAddingGame = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        if let user = authController.currentUser {
                            Section {
                                Text("Utilisateur : \(user.username)")
                                Text("Rôle : \(user.role)")
                            }
                        }
                        Button(action: {
                            authController.logout()
                        }) {
                            Label("Déconnexion", systemImage: "power")
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                fetchGames()
            }
            .sheet(item: $selectedGame) { game in
                GameDetailView(game: game, selectedGame: $selectedGame, isAdmin: true, refreshGames: fetchGames)
            }
            .sheet(isPresented: $isAddingGame) {
                AddGameView(isPresented: $isAddingGame, refreshGames: fetchGames)
            }
        }
    }

    private func fetchGames() {
        isLoading = true
        guard let url = URL(string: "http://localhost:8888/jeux.php") else {
            errorMessage = "URL invalide"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }
                
                if let data = data {
                    do {
                        let games = try JSONDecoder().decode([Game].self, from: data)
                        self.games = games
                    } catch {
                        self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                        print("Erreur détaillée : \(error)")
                    }
                }
            }
        }.resume()
    }
}

// Vue pour ajouter un jeu
struct AddGameView: View {
    @Binding var isPresented: Bool
    var refreshGames: () -> Void

    @State private var name = ""
    @State private var description = ""
    @State private var type = ""
    @State private var editor = ""
    @State private var nb_player = ""
    @State private var nb_cards = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations du jeu")) {
                    TextField("Nom", text: $name)
                    TextField("Description", text: $description)
                    TextField("Nombre de Joueurs", text: $nb_player)
                    TextField("Nombre de Cartes", text: $nb_cards)
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
                        Text("Ajouter")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
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
            "nb_player": nb_player,
            "nb_cards": nb_cards,
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
#Preview {
    AdminView()
        .environmentObject(AuthController())
}
