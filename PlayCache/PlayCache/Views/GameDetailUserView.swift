//
//  GameDetailUserView.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation
import SwiftUI

struct GameDetailUserView: View {
    let game: Game
    @Binding var selectedGame: Game?

    var body: some View {
        VStack(spacing: 20) {
            Text(game.name).font(.largeTitle).bold()
            Text(game.description).font(.body).multilineTextAlignment(.center).padding()

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
                Text("Fermer").frame(maxWidth: .infinity).padding().background(Color.red).foregroundColor(.white).cornerRadius(10).padding(.horizontal, 40)
            }
        }
        .padding()
    }
}

