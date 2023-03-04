//
//  LoginSigninView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI

struct LoginSignupView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authManager: FirebaseManager
    
    
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
                authManager.signup(email: email, password: password) { success in
                    if success {
                        authManager.createUserDocument(email: email, password: password){ succes in
                            if success{
                                // travel to RootView
                                
                            }
                        }
                    }
                }
            }

            .buttonStyle(.borderedProminent)
            Button("You already have an account? Log in") {
                            // handle login logic
                        }
            
            Spacer()
        }
        .padding()
    }
}

struct LoginSigninView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
    }
}
