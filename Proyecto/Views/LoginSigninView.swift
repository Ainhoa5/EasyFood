//
//  LoginSigninView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI

struct LoginSigninView: View {
    @State private var email = ""
    @State private var password = ""
    
    
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
            Button("Sign in") {
                // handle login logic
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
        LoginSigninView()
    }
}
