//
//  Game.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation

struct Game: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let nbPlayer: String
    let nbCards: Int
    let type: String
    let editor: String

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
