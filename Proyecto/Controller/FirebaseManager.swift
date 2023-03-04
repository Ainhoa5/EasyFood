//
//  FirebaseManager.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import Firebase
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var savedRecipes: [Recipe] = []
    private let userCollection = "users"
    
    func checkIfUserExistsAndLogout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
    
    func createUserDocument(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let data: [String: Any] = [
            "email": email,
            "name": "",
        ]
        db.collection(userCollection).document(userUID).setData(data) { error in
            completion(error)
        }
    }
    
    func updateUserDocument(name: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let data: [String: Any] = [
            "name": name,
        ]
        db.collection(userCollection).document(userUID).updateData(data) { error in
            completion(error)
        }
    }
    
    func fetchUserDocument(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }
        db.collection(userCollection).document(userUID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let snapshot = snapshot, let data = snapshot.data() else {
                completion(nil, nil)
                return
            }
            let email = data["email"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let user = User(email: email, name: name)
            completion(user, nil)
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
    
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                if let data = snapshot?.data(), let savedRecipes = data["savedRecipes"] as? [String] {
                    self.savedRecipes = savedRecipes.map { Recipe(title: $0, image: "", summary: "") }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func saveRecipe(_ recipe: Recipe) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData(["savedRecipes": FieldValue.arrayUnion([recipe.title])], merge: true) { error in
                if let error = error {
                    print("Error adding recipe: \(error)")
                } else {
                    print("Recipe added successfully")
                }
            }
        } else {
            print("User not logged in")
        }
    }
    
    func getSavedRecipes(completion: @escaping ([String]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(uid).getDocument { document, error in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            if let data = document.data(), let savedRecipes = data["savedRecipes"] as? [String] {
                completion(savedRecipes)
            } else {
                print("Saved recipes not found")
                completion([])
            }
        }
    }
    
    func createDocument(){
        if let user = Auth.auth().currentUser {
            let docRef = db.collection("Users").document(user.uid)
            docRef.setData([
                "name": user.displayName ?? "",
                "email": user.email ?? "",
                "uid": user.uid
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(docRef.documentID)")
                }
            }
        }
        
    }
    
    func updateDocument(name: String, email: String) {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let docRef = db.collection("Users").document(user.uid)
            docRef.updateData([
                "name": name,
                "email": email
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document updated successfully")
                }
            }
        }
    }
    
    func fetchDocument() {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let docRef = db.collection("Users").document(user.uid)
            docRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["name"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    print("Document data: name=\(name), email=\(email)")
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}
