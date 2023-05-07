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
    @State private var errorMessage = "" // State variable to hold the error message
    
    // Enviroment object to handle authentication with Firebase
    @EnvironmentObject var authManager: FirebaseManager
    
    // dismiss view when the user logs in or signs up
    let onSuccess: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            // Form header
            VStack(alignment: .leading){
                Text("Your account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.top)
                
                Text("Please, create an account with us to continue.")
                    .foregroundColor(Color.gray)
                    .padding(.bottom)
            }
            
            Spacer()
            
            // Fields
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
            
            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom)
            }
            
            // Log in button
            VStack(alignment: .center) {
                Button("Log in") {
                    authManager.login(email: email, password: password) { success in // log into firebase
                        if success {
                            presentationMode.wrappedValue.dismiss() // dismiss view
                            self.onSuccess() // Call the onSuccess closure
                        } else {
                            print("ntl")
                            errorMessage = "Incorrect email or password"
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
        
            Spacer()
            
            // Sign up button
            HStack(alignment: .center) {
                Text("You don't have an account yet?")
                    .foregroundColor(Color.black)
                Button("Sign up") {
                    authManager.signup(email: email, password: password) { success, error in // Sign up into firebase
                        if let error = error {
                            errorMessage = error.localizedDescription
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
                .foregroundColor(Color.green)
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .padding()
    }
}
