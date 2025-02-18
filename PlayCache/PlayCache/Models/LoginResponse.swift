//
//  LoginResponse.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let username: String?
    let role: String?
    let message: String?
}

