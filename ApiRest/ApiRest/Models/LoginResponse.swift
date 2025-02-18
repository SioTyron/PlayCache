//
//  LoginResponse.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let username: String?
    let role: String?
    let message: String? // Optionnel : pour un message d'erreur détaillé
}
