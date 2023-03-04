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
    
    func saveRecipe(_ recipe: Recipe) {
        // create a new document for the recipe
        var ref: DocumentReference? = nil
        ref = db.collection("recipes").addDocument(data: [
            "title": recipe.title,
            "image": recipe.image,
            "summary": recipe.summary
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getSavedRecipes(completion: @escaping ([Recipe]) -> Void) {
        // retrieve all saved recipes from Firestore
        db.collection("recipes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var recipes: [Recipe] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let title = data["title"] as! String
                    let image = data["image"] as! String
                    let summary = data["summary"] as! String
                    let recipe = Recipe(title: title, image: image, summary: summary)
                    recipes.append(recipe)
                }
                completion(recipes)
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
