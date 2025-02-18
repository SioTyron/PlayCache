//
//  AdminUserManagement.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//

import Foundation
import SwiftUI

struct AdminUserManagement: View {
    @EnvironmentObject var authController: AuthController
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Espace Administrateur 👑")
                    .font(.title)
                
                Text("Bienvenue, \(authController.currentUser?.username ?? "")")
                    .padding()
                
                Button("Déconnexion") {
                    authController.logout()
                }
                .padding()
            }
        }
    }
}
#Preview {
    AdminUserManagement().environmentObject(AuthController())
}
