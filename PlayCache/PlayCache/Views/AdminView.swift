//
//  AdminView.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var authController: AuthController
    @State private var games: [Game] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedGame: Game?
    @State private var searchText = ""
    @State private var isAddingGame = false

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
                            GameCard(game: game).onTapGesture { selectedGame = game }
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
                        Image(systemName: "plus").foregroundColor(.blue)
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
    AdminView().environmentObject(AuthController())
}
