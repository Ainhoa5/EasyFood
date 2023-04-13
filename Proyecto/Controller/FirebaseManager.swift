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
    
    // MARK: - User Authentication
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
    
    
    // MARK: - Document management
    // This function adds a recipe to the current user's saved recipes in the Firestore database.
    // It first checks if the user is logged in.
    // If there is an error, it prints the error message.
//    func saveRecipe(_ recipe: Recipe) {
//        if let uid = Auth.auth().currentUser?.uid {
//            db.collection("users").document(uid).setData(["savedRecipes": FieldValue.arrayUnion([recipe.label])], merge: true) { error in
//                if let error = error {
//                    print("Error adding recipe: \(error)")
//                } else {
//                    print("Recipe added successfully")
//                }
//            }
//        } else {
//            print("User not logged in")
//        }
//    }
    // Removes a recipe from the user's saved recipes list in Firestore
//    func removeRecipe(_ recipe: Recipe) {
//        // Check if the user is logged in and has a UID
//        if let uid = Auth.auth().currentUser?.uid {
//            // Access the user's document in the "users" collection and remove the recipe title from the "savedRecipes" array field
//            db.collection("users").document(uid).updateData(["savedRecipes": FieldValue.arrayRemove([recipe.label])]) { error in
//                // If there's an error, print the error message. Otherwise, print a success message.
//                if let error = error {
//                    print("Error removing recipe: \(error)")
//                } else {
//                    print("Recipe removed successfully")
//                }
//            }
//        } else {
//            // If the user is not logged in, print a message.
//            print("User not logged in")
//        }
//    }
    // Fetches the user's saved recipes list from Firestore
//    func fetchSavedRecipes(completion: @escaping ([String]) -> ()) {
//        // Check if the user is logged in and has a UID
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        // Access the user's document in the "users" collection
//        db.collection("users").document(uid).getDocument { document, error in
//            // If there's an error or the document doesn't exist, print an error message and return an empty array.
//            guard let document = document, document.exists else {
//                print("Document does not exist")
//                return
//            }
//
//            // If the document exists, extract the "savedRecipes" array field from the data and pass it to the completion handler.
//            if let data = document.data(), let savedRecipes = data["savedRecipes"] as? [String] {
//                completion(savedRecipes)
//            } else {
//                // If the "savedRecipes" field doesn't exist or is not an array of strings, print an error message and return an empty array.
//                print("Saved recipes not found")
//                completion([])
//            }
//        }
//    }
    
    // RECIPES
    func saveRecipe(_ recipe: Recipe) {
        if let uid = Auth.auth().currentUser?.uid {
            // Convert the recipe struct to a dictionary
            let recipeDict: [String: Any] = [
                "label": recipe.label,
                "image": recipe.image,
                "source": recipe.source,
                "url": recipe.url,
                "yield": recipe.yield,
                "dietLabels": recipe.dietLabels,
                "healthLabels": recipe.healthLabels,
                "cautions": recipe.cautions,
                "ingredientLines": recipe.ingredientLines,
                "cuisineType": recipe.cuisineType,
                "mealType": recipe.mealType,
                "dishType": recipe.dishType
            ]

            // Save the recipe to the "userRecipes" collection
            db.collection("userRecipes").document(uid).updateData(["recipes": FieldValue.arrayUnion([recipeDict])]) { error in
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
    func removeRecipe(_ recipe: Recipe) {
        if let uid = Auth.auth().currentUser?.uid {
            let recipeDict: [String: Any] = [
                "label": recipe.label,
                "image": recipe.image,
                "source": recipe.source,
                "url": recipe.url,
                "yield": recipe.yield,
                "dietLabels": recipe.dietLabels,
                "healthLabels": recipe.healthLabels,
                "cautions": recipe.cautions,
                "ingredientLines": recipe.ingredientLines,
                "cuisineType": recipe.cuisineType,
                "mealType": recipe.mealType,
                "dishType": recipe.dishType
            ]

            db.collection("userRecipes").document(uid).updateData(["recipes": FieldValue.arrayRemove([recipeDict])]) { error in
                if let error = error {
                    print("Error removing recipe: \(error)")
                } else {
                    print("Recipe removed successfully")
                }
            }
        } else {
            print("User not logged in")
        }
    }
    func createRecipesDocument() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("userRecipes").document(uid).setData(["recipes": []]) { error in
                if let error = error {
                    print("Error creating document: \(error)")
                } else {
                    print("Document created successfully")
                }
            }
        } else {
            print("User not logged in")
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
                            source: recipeDict["source"] as? String ?? "",
                            url: recipeDict["url"] as? String ?? "",
                            yield: recipeDict["yield"] as? Int ?? 0,
                            dietLabels: recipeDict["dietLabels"] as? [String] ?? [],
                            healthLabels: recipeDict["healthLabels"] as? [String] ?? [],
                            cautions: recipeDict["cautions"] as? [String] ?? [],
                            ingredientLines: recipeDict["ingredientLines"] as? [String] ?? [],
                            cuisineType: recipeDict["cuisineType"] as? [String] ?? [],
                            mealType: recipeDict["mealType"] as? [String] ?? [],
                            dishType: recipeDict["dishType"] as? [String] ?? []
                        )
                        recipes.append(recipe)
                    }

                    completion(recipes)
                } else {
                    print("Error fetching recipes: \(error?.localizedDescription ?? "No error description")")
                    completion([])
                }
            }
        } else {
            print("User not logged in")
            completion([])
        }
    }

    
    // PRUEBAS
    
    
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
    
    
    // MEAL TYPES
    func saveMealType(_ mealTypeName: String, _ type: String) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData([type: FieldValue.arrayUnion([mealTypeName])], merge: true) { error in
                if let error = error {
                    print("Error adding meal type: \(error)")
                } else {
                    print("Meal type added successfully")
                }
            }
        } else {
            print("User not logged in")
        }
    }
    func removeMealType(_ mealTypeName: String, _ type: String) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).updateData([type: FieldValue.arrayRemove([mealTypeName])]) { error in
                if let error = error {
                    print("Error removing meal type: \(error)")
                } else {
                    print("Meal type removed successfully")
                }
            }
        } else {
            print("User not logged in")
        }
    }
    func fetchSavedMealTypes(_ type: String, completion: @escaping ([String]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("users").document(uid).getDocument { document, error in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }

            if let data = document.data(), let savedMealTypes = data[type] as? [String] {
                completion(savedMealTypes)
            } else {
                print("Saved meal types not found")
                completion([])
            }
        }
    }
    
    

    
}
