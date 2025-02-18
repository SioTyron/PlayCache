//
//  UserView.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import SwiftUI

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
                    Text("Aucun jeu disponible").foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                            ForEach(displayedGames) { game in
                                GameCard(game: game).onTapGesture { selectedGame = game }
                            }
                        }
                        .padding()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un jeu...")
            .navigationTitle("Liste des Jeux")
            .toolbar {
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
                        Image(systemName: "gearshape.fill").foregroundColor(.blue)
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
        GameController.shared.fetchGames { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let games):
                    self.games = games
                case .failure(let error):
                    self.errorMessage = "Erreur de chargement : \(error.localizedDescription)"
                }
            }
        }
    }
}


#Preview {
    UserView().environmentObject(AuthController())
}


