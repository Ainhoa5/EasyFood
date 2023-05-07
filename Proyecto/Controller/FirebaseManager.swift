//
//  FirebaseManager.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import Firebase
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    // Getting Firestore instance
    let db = Firestore.firestore()
    // Helper function to convert a Recipe object to a dictionary
    private func recipeToDictionary(_ recipe: Recipe) -> [String: Any] {
        return [
            "label": recipe.label,
            "image": recipe.image,
            "url": recipe.url,
            "dietLabels": recipe.dietLabels,
            "healthLabels": recipe.healthLabels,
            "cautions": recipe.cautions,
            "ingredientLines": recipe.ingredientLines,
            "cuisineType": recipe.cuisineType,
            "mealType": recipe.mealType,
            "dishType": recipe.dishType
        ]
    }
}
// MARK: - User Authentication
extension FirebaseManager {
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
        db.collection("users").document(userUID).setData(data) { error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    } // Create a new user document with email and name, then call the completion handler with success or failure
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    } // Log a user in with their email and password.

    func signup(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
                return
            } else {
                completion(true, nil)
            }
        }
    } // Create a new user with the given email and password.
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch _ {}
    } // Sign out the current user.
}

// MARK: - Recipe management
extension FirebaseManager {
    func saveRecipe(_ recipe: Recipe) {
        if let uid = Auth.auth().currentUser?.uid {
            // Convert the recipe struct to a dictionary
            let recipeDict: [String: Any] = recipeToDictionary(recipe)
            
            // Save the recipe to the "userRecipes" collection
            db.collection("userRecipes").document(uid).updateData(["recipes": FieldValue.arrayUnion([recipeDict])])
        }
    }
    func removeRecipe(_ recipe: Recipe) {
        if let uid = Auth.auth().currentUser?.uid {
            // Convert the recipe struct to a dictionary
            let recipeDict: [String: Any] = recipeToDictionary(recipe)
            
            db.collection("userRecipes").document(uid).updateData(["recipes": FieldValue.arrayRemove([recipeDict])])
        }
    }
    func createRecipesDocument() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("userRecipes").document(uid).setData(["recipes": [] as [Dictionary<String, Any>]])
        }
    }
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("userRecipes").document(uid).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    let recipeDicts = data?["recipes"] as? [[String: Any]] ?? []
                    
                    var recipes: [Recipe] = []
                    for recipeDict in recipeDicts {
                        let recipe = Recipe(
                            label: recipeDict["label"] as? String ?? "",
                            image: recipeDict["image"] as? String ?? "",
                            url: recipeDict["url"] as? String ?? "",
                            ingredientLines: recipeDict["ingredientLines"] as? [String] ?? [],
                            dietLabels: recipeDict["dietLabels"] as? [String] ?? [],
                            healthLabels: recipeDict["healthLabels"] as? [String] ?? [],
                            cautions: recipeDict["cautions"] as? [String] ?? [],
                            cuisineType: recipeDict["cuisineType"] as? [String] ?? [],
                            mealType: recipeDict["mealType"] as? [String] ?? [],
                            dishType: recipeDict["dishType"] as? [String] ?? []
                        )
                        recipes.append(recipe)
                    }
                    
                    completion(recipes)
                } else {
                    completion([])
                }
            }
        } else {
            completion([])
        }
    }
}

// MARK: - Ingredient management
extension FirebaseManager {
    func removeIngredient(_ ingredient: Ingredient) {
        // Check if the user is logged in and has a UID
        if let uid = Auth.auth().currentUser?.uid {
            // Access the user's document in the "users" collection and remove the recipe title from the "savedRecipes" array field
            db.collection("users").document(uid).updateData(["savedIngredients": FieldValue.arrayRemove([ingredient.name])])
        }
    }
    func saveIngredient(_ ingredient: Ingredient) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData(["savedIngredients": FieldValue.arrayUnion([ingredient.name])], merge: true)
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
                return
            }
            
            // If the document exists, extract the "savedRecipes" array field from the data and pass it to the completion handler.
            if let data = document.data(), let savedRecipes = data["savedIngredients"] as? [String] {
                completion(savedRecipes)
            } else {
                // If the "savedRecipes" field doesn't exist or is not an array of strings, print an error message and return an empty array.
                completion([])
            }
        }
    }
}

// MARK: - Meal Type management
extension FirebaseManager {
    func saveRecipeType(_ mealTypeName: String, _ type: String) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData([type: FieldValue.arrayUnion([mealTypeName])], merge: true)
        }
    }
    func removeMealType(_ mealTypeName: String, _ type: String) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).updateData([type: FieldValue.arrayRemove([mealTypeName])])
        }
    }
    func fetchSavedMealTypes(_ type: String, completion: @escaping ([String]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(uid).getDocument { document, error in
            guard let document = document, document.exists else {
                return
            }
            
            if let data = document.data(), let savedMealTypes = data[type] as? [String] {
                completion(savedMealTypes)
            } else {
                completion([])
            }
        }
    }
}
