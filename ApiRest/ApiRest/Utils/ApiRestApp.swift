//
//  ApiRestApp.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//

import Foundation
import SwiftUI

@main
struct ApiRestApp: App {
    @StateObject var authController = AuthController()
    
    var body: some Scene {
        WindowGroup {
            if let user = authController.currentUser {
                if user.role == "administrateur" {
                    AdminView()
                } else {
                    UserView()
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(authController)
    }
}
