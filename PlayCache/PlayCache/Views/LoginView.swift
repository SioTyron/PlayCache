//
//  LoginView.swift
//  PlayCache
//
//  Created by de CHADIRAC-LARA Tyron on 18/02/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authController: AuthController
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)

                VStack(spacing: 20) {
                    Image("logo").resizable().scaledToFit().frame(width: 120, height: 120).clipShape(Circle()).shadow(radius: 5).padding(.bottom, 20)
                    Text("PlayCache\nConnexion").font(.title).fontWeight(.bold).multilineTextAlignment(.center).foregroundColor(.black).padding(.bottom, 20)

                    VStack(spacing: 15) {
                        TextField("Nom d'utilisateur", text: $username).padding().frame(width: 280).background(Color.white.opacity(0.9)).cornerRadius(10).shadow(radius: 3).autocapitalization(.none).disableAutocorrection(true)
                        SecureField("Mot de passe", text: $password).padding().frame(width: 280).background(Color.white.opacity(0.9)).cornerRadius(10).shadow(radius: 3)
                    }

                    Button(action: {
                        authController.login(username: username, password: password)
                    }) {
                        Text("Connexion").font(.headline).foregroundColor(.white).padding().frame(width: 280).background(Color.blue.opacity(0.9)).cornerRadius(10).shadow(radius: 5)
                    }

                    if !authController.errorMessage.isEmpty {
                        Text(authController.errorMessage).foregroundColor(.red).font(.subheadline).padding()
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
