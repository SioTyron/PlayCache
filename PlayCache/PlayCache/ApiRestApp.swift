//
//  ApiRestApp.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
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
                    AdminView().environmentObject(authController)
                } else {
                    UserView().environmentObject(authController)
                }
            } else {
                LoginView().environmentObject(authController)
            }
        }
    }
}
