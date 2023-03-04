//
//  AuthManager.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import Foundation
import Firebase

class AuthManager: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isLoggedIn = user != nil
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Signed in successfully")
                completion(true)
            }
        }
    }

    func signup(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                completion(false)
            } else if let user = authResult?.user {
                print("Signed up successfully with user ID: \(user.uid)")
                completion(true)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

