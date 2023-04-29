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
        
        VStack(alignment: .leading) {
            // Form
            Text("Your account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top)
            
            Text("Please, create an account with us to continue.")
                .foregroundColor(Color.gray)
                .padding(.bottom)
            Spacer()
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                TextField("Email", text: $email)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.top)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            // Sign up button
            VStack(alignment: .center) {
                Button("Sign up") {
                    authManager.signup(email: email, password: password) { success, error in // Sign up into firebase
                        if let error = error {
                            print("Error signing up: \(error.localizedDescription)")
                        } else if success {
                            authManager.createUserDocument(email: email, password: password) { success in // create a documento for the user in firestore
                                if success {
                                    authManager.createRecipesDocument()
                                    presentationMode.wrappedValue.dismiss() // dismiss view
                                    self.onSuccess() // Call the onSuccess closure to ContentView
                                }
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            // Log in button
            Spacer()
            HStack(alignment: .center) {
                Text("You already have an account?")
                    .foregroundColor(Color.black)
                Button("Log in") {
                    authManager.login(email: email, password: password) { success in // log into firebase
                        if success {
                            presentationMode.wrappedValue.dismiss() // dismiss view
                            self.onSuccess() // Call the onSuccess closure
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(Color.green)
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .padding()
    }
}
