//
//  GameCard.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation
import SwiftUI

struct GameCard: View {
    let game: Game

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(game.name).font(.headline).foregroundColor(.primary)
            Text(game.description).font(.subheadline).foregroundColor(.gray).lineLimit(2)

            HStack {
                Text("👥 \(game.nbPlayer)").font(.caption)
                Spacer()
                Text("🃏 \(game.nbCards) cartes").font(.caption)
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
