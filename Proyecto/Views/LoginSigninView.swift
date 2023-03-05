//
//  LoginSignupView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI

struct LoginSignupView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authManager: FirebaseManager
    let onSuccess: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Log in")
                .font(.title)
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Button("Sign up") {
                authManager.signup(email: email, password: password) { success, error in
                    if let error = error {
                        print("Error signing up: \(error.localizedDescription)")
                    } else if success {
                        authManager.createUserDocument(email: email, password: password) { success in
                            if success {
                                print("it worked")
                                presentationMode.wrappedValue.dismiss()
                                self.onSuccess() // Call the onSuccess closure
                            }
                        }
                    }
                }
            }

            .buttonStyle(.borderedProminent)
            Button("You already have an account? Log in") {
                authManager.login(email: email, password: password) { success in
                    if success {
                        print("loged in")
                        presentationMode.wrappedValue.dismiss()
                        self.onSuccess() // Call the onSuccess closure
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

