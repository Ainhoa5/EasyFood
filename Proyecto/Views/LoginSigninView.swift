//
//  LoginSignupView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI

struct LoginSignupView: View {
    // State variables to hold the data entered by the user
    @State private var email = ""
    @State private var password = ""
    
    // Enviroment object to handle authentication with Firebase
    @EnvironmentObject var authManager: FirebaseManager
    
    // dismiss view when the user logs in or signs up
    let onSuccess: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Form
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
            
            // Sign up button
            Button("Sign up") {
                authManager.signup(email: email, password: password) { success, error in // Sign up into firebase
                    if let error = error {
                        print("Error signing up: \(error.localizedDescription)")
                    } else if success {
                        authManager.createUserDocument(email: email, password: password) { success in // create a documento for the user in firestore
                            if success {
                                presentationMode.wrappedValue.dismiss() // dismiss view
                                self.onSuccess() // Call the onSuccess closure to ContentView
                            }
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Log in button
            Button("You already have an account? Log in") {
                authManager.login(email: email, password: password) { success in // log into firebase
                    if success {
                        presentationMode.wrappedValue.dismiss() // dismiss view
                        self.onSuccess() // Call the onSuccess closure
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

