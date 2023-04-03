//
//  FirebaseManager.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import Firebase
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    // Creating a singleton of the class
    static let shared = FirebaseManager()
    
    // Getting Firestore instance
    let db = Firestore.firestore()
    
    // Creating a published array of Recipe objects
    @Published var savedRecipes: [Recipe] = []
    
    // String for the name of user collection
    private let userCollection = "users"
    
    // Check if a user is signed in, then sign them out
    func checkIfUserExistsAndLogout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
    
    // Create a new user document with email and password, then call the completion handler with success or failure
    func createUserDocument(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        // Data to be saved in the user document
        let data: [String: Any] = [
            "email": email,
            "name": "",
        ]
        
        // Adding the data to Firestore
        db.collection(userCollection).document(userUID).setData(data) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Update an existing user document with the provided name, then call the completion handler with success or failure
    func updateUserDocument(name: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        // Data to be updated in the user document
        let data: [String: Any] = [
            "name": name,
        ]
        
        // Updating the data in Firestore
        db.collection(userCollection).document(userUID).updateData(data) { error in
            completion(error)
        }
    }
    
    // Fetch the user document and call the completion handler with a User object and an error, if any
    func fetchUserDocument(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }
        
        // Getting the user document from Firestore
        db.collection(userCollection).document(userUID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let snapshot = snapshot, let data = snapshot.data() else {
                completion(nil, nil)
                return
            }
            
            // Creating a User object from the data in the user document
            let email = data["email"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let user = User(email: email, name: name)
            completion(user, nil)
        }
    }
    
    // This function logs a user in with their email and password.
    // If there is an error, it prints the error message and calls the completion handler with false.
    // If there is no error, it prints a success message and calls the completion handler with true.
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

    // This function creates a new user with the given email and password.
    // If there is an error, it prints the error message and calls the completion handler with false and the error.
    // If there is no error, it prints a success message and calls the completion handler with true and no error.
    func signup(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                completion(false, error)
                return
            } else {
                print("Signed up successfully")
                completion(true, nil)
            }
        }
    }

    // This function signs out the current user.
    // If there is an error, it prints the error message.
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // This function adds a recipe to the current user's saved recipes in the Firestore database.
    // It first checks if the user is logged in.
    // If there is an error, it prints the error message.
    func saveRecipe(_ recipe: Recipe) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData(["savedRecipes": FieldValue.arrayUnion([recipe.label])], merge: true) { error in
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
    
    // Removes a recipe from the user's saved recipes list in Firestore
    func removeRecipe(_ recipe: Recipe) {
        // Check if the user is logged in and has a UID
        if let uid = Auth.auth().currentUser?.uid {
            // Access the user's document in the "users" collection and remove the recipe title from the "savedRecipes" array field
            db.collection("users").document(uid).updateData(["savedRecipes": FieldValue.arrayRemove([recipe.label])]) { error in
                // If there's an error, print the error message. Otherwise, print a success message.
                if let error = error {
                    print("Error removing recipe: \(error)")
                } else {
                    print("Recipe removed successfully")
                }
            }
        } else {
            // If the user is not logged in, print a message.
            print("User not logged in")
        }
    }

    func removeIngredient(_ ingredient: Ingredient) {
        // Check if the user is logged in and has a UID
        if let uid = Auth.auth().currentUser?.uid {
            // Access the user's document in the "users" collection and remove the recipe title from the "savedRecipes" array field
            db.collection("users").document(uid).updateData(["savedIngredients": FieldValue.arrayRemove([ingredient.name])]) { error in
                // If there's an error, print the error message. Otherwise, print a success message.
                if let error = error {
                    print("Error removing recipe: \(error)")
                } else {
                    print("Ingredient removed successfully")
                }
            }
        } else {
            // If the user is not logged in, print a message.
            print("User not logged in")
        }
    }
    
    func saveIngredient(_ ingredient: Ingredient) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData(["savedIngredients": FieldValue.arrayUnion([ingredient.name])], merge: true) { error in
                if let error = error {
                    print("Error adding recipe: \(error)")
                } else {
                    print("Ingredient added successfully")
                }
            }
        } else {
            print("User not logged in")
        }
    }
    
    func fetchSavedIngredients(completion: @escaping ([String]) -> ()){
        // Check if the user is logged in and has a UID
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Access the user's document in the "users" collection
        db.collection("users").document(uid).getDocument { document, error in
            // If there's an error or the document doesn't exist, print an error message and return an empty array.
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            // If the document exists, extract the "savedRecipes" array field from the data and pass it to the completion handler.
            if let data = document.data(), let savedRecipes = data["savedIngredients"] as? [String] {
                completion(savedRecipes)
            } else {
                // If the "savedRecipes" field doesn't exist or is not an array of strings, print an error message and return an empty array.
                print("Saved ingredients not found")
                completion([])
            }
        }
    }
    // Fetches the user's saved recipes list from Firestore
    func fetchSavedRecipes(completion: @escaping ([String]) -> ()) {
        // Check if the user is logged in and has a UID
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Access the user's document in the "users" collection
        db.collection("users").document(uid).getDocument { document, error in
            // If there's an error or the document doesn't exist, print an error message and return an empty array.
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            // If the document exists, extract the "savedRecipes" array field from the data and pass it to the completion handler.
            if let data = document.data(), let savedRecipes = data["savedRecipes"] as? [String] {
                completion(savedRecipes)
            } else {
                // If the "savedRecipes" field doesn't exist or is not an array of strings, print an error message and return an empty array.
                print("Saved recipes not found")
                completion([])
            }
        }
    }

    // Creates a document for the logged in user in the "Users" collection in Firestore
    func createDocument(){
        // Check if the user is logged in
        if let user = Auth.auth().currentUser {
            // Access the user's document in the "Users" collection and set the "name", "email", and "uid" fields.
            let docRef = db.collection("Users").document(user.uid)
            docRef.setData([
                "name": user.displayName ?? "",
                "email": user.email ?? "",
                "uid": user.uid
            ]) { error in
                // If there's an error, print the error message. Otherwise, print a success message.
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(docRef.documentID)")
                }
            }
        }
    }
    
    // Update a document in Firestore
    func updateDocument(name: String, email: String) {
        // Check if user is signed in
        if let user = Auth.auth().currentUser {
            // Get a reference to the Firestore database
            let db = Firestore.firestore()
            // Get a reference to the document we want to update
            let docRef = db.collection("Users").document(user.uid)
            // Update the document with the new name and email
            docRef.updateData([
                "name": name,
                "email": email
            ]) { error in
                // Check if there was an error updating the document
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document updated successfully")
                }
            }
        }
    }

    // Fetch a document from Firestore
    func fetchDocument() {
        // Check if user is signed in
        if let user = Auth.auth().currentUser {
            // Get a reference to the Firestore database
            let db = Firestore.firestore()
            // Get a reference to the document we want to fetch
            let docRef = db.collection("Users").document(user.uid)
            // Fetch the document
            docRef.getDocument { document, error in
                // Check if there was an error fetching the document or if the document doesn't exist
                if let document = document, document.exists {
                    // Extract the data from the document
                    let data = document.data()
                    let name = data?["name"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    // Print the data to the console
                    print("Document data: name=\(name), email=\(email)")
                } else {
                    // If there was an error fetching the document or if the document doesn't exist, print an error message to the console
                    print("Document does not exist")
                }
            }
        }
    }
}
