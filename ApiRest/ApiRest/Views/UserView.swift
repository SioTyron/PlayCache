//  UserView.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//

import Foundation
import SwiftUI

// Structure pour les données du jeu
struct Game: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let nbPlayer: String
    let nbCards: Int
    let type: String
    let editor: String

    // Propriétés calculées pour le tri
    var minPlayers: Int {
        let components = nbPlayer.components(separatedBy: "-")
        return Int(components.first ?? "0") ?? 0
    }
    
    var maxPlayers: Int {
        let components = nbPlayer.components(separatedBy: "-")
        return Int(components.last ?? "0") ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case nbPlayer = "nb_player"
        case nbCards = "nb_cards"
        case type
        case editor
    }
}

// Enumération pour les critères de tri
enum SortCriteria: String, CaseIterable {
    case name = "Nom"
    case maxPlayers = "Joueurs (max)"
    case cards = "Cartes"
}

struct UserView: View {
    @EnvironmentObject var authController: AuthController
    @State private var games: [Game] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedGame: Game?
    @State private var searchText = ""
    @State private var sortCriteria: SortCriteria = .name
    
    // Jeux filtrés ET triés
    var displayedGames: [Game] {
        let filtered = games.filter { game in
            searchText.isEmpty ||
            game.name.localizedCaseInsensitiveContains(searchText) ||
            game.description.localizedCaseInsensitiveContains(searchText)
        }
        
        switch sortCriteria {
        case .name:
            return filtered.sorted { $0.name < $1.name }
        case .maxPlayers:
            return filtered.sorted { $0.maxPlayers < $1.maxPlayers }
        case .cards:
            return filtered.sorted { $0.nbCards < $1.nbCards }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if games.isEmpty && !isLoading {
                    Text("Aucun jeu disponible")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                            ForEach(displayedGames) { game in
                                GameCard(game: game)
                                    .onTapGesture { selectedGame = game }
                            }
                        }
                        .padding()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un jeu...")
            .navigationTitle("Liste des Jeux")
            .toolbar {
                // Menu de tri à gauche
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(SortCriteria.allCases, id: \.self) { criteria in
                            Button { sortCriteria = criteria } label: {
                                HStack {
                                    Text(criteria.rawValue)
                                    if sortCriteria == criteria {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Label("Trier", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                // Menu utilisateur à droite
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
            .onAppear(perform: fetchGames)
            .sheet(item: $selectedGame) { game in
                GameDetailUserView(game: game, selectedGame: $selectedGame)
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

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Erreur réseau: \(error.localizedDescription)"
                    return
                }
                
                if let data = data {
                    do {
                        let decodedGames = try JSONDecoder().decode([Game].self, from: data)
                        self.games = decodedGames.sorted { $0.name < $1.name } // Tri initial par nom
                    } catch {
                        self.errorMessage = "Format de données invalide"
                        print("Erreur décodage:", error)
                    }
                }
            }
        }.resume()
    }
}

// Vue pour afficher une carte de jeu
struct GameCard: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(game.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(game.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Text("👥 \(game.nbPlayer)")
                    .font(.caption)
                Spacer()
                Text("🃏 \(game.nbCards) cartes")
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 160, height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Vue détaillée du jeu
struct GameDetailUserView: View {
    let game: Game
    @Binding var selectedGame: Game?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(game.name)
                .font(.largeTitle)
                .bold()
            
            Text(game.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("👥 Nombre de joueurs : **\(game.nbPlayer)**")
                Text("🃏 Nombre de cartes : **\(game.nbCards)**")
                Text("🎲 Type de jeu : **\(game.type)**")
                Text("🏢 Éditeur : **\(game.editor)**")
            }
            .font(.title3)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.2)))
            .padding()
            
            Spacer()
            
            Button(action: {
                selectedGame = nil
            }) {
                Text("Fermer")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
        }
        .padding()
    }
}

#Preview {
    UserView()
        .environmentObject(AuthController())
}
