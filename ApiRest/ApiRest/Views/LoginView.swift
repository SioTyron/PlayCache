//
//  LoginView.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authController: AuthController
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = false
    @State private var wrongPassword = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                /* Fond avec dégradé simple
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()*/
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack(spacing: 20) {
                    // Logo
                    Image("logo") // Remplace par ton image de logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        //.overlay(Circle().stroke(Color.white, lineWidth: 1))
                        .shadow(radius: 5)
                        .padding(.bottom, 20)

                    // Titre
                    Text("PlayCache\nConnexion")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)

                    // Champs de saisie
                    VStack(spacing: 15) {
                        TextField("Nom d'utilisateur", text: $username)
                            .padding()
                            .frame(width: 280)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Mot de passe", text: $password)
                            .padding()
                            .frame(width: 280)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }

                    // Bouton de connexion
                    Button(action: {
                        authController.login(username: username, password: password)
                    }) {
                        Text("Connexion")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280) // Aligné avec les champs de texte
                            .background(Color.blue.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // Message d'erreur
                    if !authController.errorMessage.isEmpty {
                        Text(authController.errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding()
                    }
                }
                .padding(.vertical, 50)
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthController())
}
