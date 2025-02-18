//
//  ContentView.swift
//  ApiRest
//
//  Created by de CHADIRAC-LARA Tyron on 09/02/2025.
//


import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        VStack {
            Text("Connexion")
                .font(.largeTitle)
                .padding()

            TextField("Nom d'utilisateur", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Mot de passe", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                loginUser()
            }) {
                Text("Se connecter")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text(message)
                .foregroundColor(isLoggedIn ? .green : .red)
                .padding()

            Spacer()
        }
        .padding()
    }

    func loginUser() {
        guard let url = URL(string: "http://localhost:8888/api.php?username=\(username)&password=\(password)") else {
            message = "URL invalide"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    message = "Erreur : \(error.localizedDescription)"
                }
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let success = json?["success"] as? Bool, let msg = json?["message"] as? String {
                        DispatchQueue.main.async {
                            isLoggedIn = success
                            message = msg
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        message = "Erreur JSON : \(error.localizedDescription)"
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
