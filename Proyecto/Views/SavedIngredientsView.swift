//
//  SavedIngredientsView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI


struct SavedIngredientsView: View {
    // toggle
    @State private var showAllIngredients: Bool = false
    @State private var showSavedIngredients: Bool = true
    
    @State private var ingredients: [Ingredient] = [
        Ingredient(name: "Pasta", image: "cheese"),
        Ingredient(name: "Chicken", image: "cheese"),
        Ingredient(name: "Tomatoes", image: "cheese"),
        Ingredient(name: "Garlic", image: "cheese"),
        Ingredient(name: "Cheese", image: "cheese"),
    ] // dummy data
    
    let firebaseManager = FirebaseManager() // Firebase manager
    @EnvironmentObject var appState: AppState

//    fetch the saved ingredients from firebase and update local ingredients list
    private func updateIngredientsWithSaved() {
        firebaseManager.fetchSavedIngredients { fetchedIngredientNames in
            DispatchQueue.main.async {
                for fetchedIngredientName in fetchedIngredientNames {
                    if let index = ingredients.firstIndex(where: { $0.name == fetchedIngredientName }) {
                        ingredients[index].isSaved = true
                        appState.savedIngredients.append(ingredients[index])
                        appState.shouldUpdateRecipes = true
                    } else {
                        // Add the ingredient if it's not in the existing list
                        let newIngredient = Ingredient(name: fetchedIngredientName, image: "",  isSaved: true)
                        ingredients.append(newIngredient)
                    }
                }
                appState.ingredientsFetched = true
            }
        }
    }


    
    var body: some View {
            List {
                // saved ingredients section
                HStack{
                    Image(systemName: "bookmark.fill")
                        .resizable()
                        .frame(width: 20, height: 30)
                        .foregroundColor(.blue)
                    Text("SAVED INGREDIENTS")
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width)
                .onTapGesture {
                    if showSavedIngredients {
                        showSavedIngredients = false
                    }else {
                        showSavedIngredients = true
                    }
                }
                
                
                if showSavedIngredients{
                    Section(header: Text("Saved Ingredients")) {
                        ForEach(ingredients.filter({ $0.isSaved })) { ingredient in
                            HStack {
                                Image(ingredient.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text(ingredient.name)
                                Spacer()
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .onTapGesture {
                                if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    ingredients[index].isSaved.toggle()
                                    firebaseManager.removeIngredient(ingredients[index])
                                }
                            }
                        }
                    }
                }
                
                // all ingredients section
                HStack{
                    Text("ALL INGREDIENTS")
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width)
                .onTapGesture {
                    if showAllIngredients {
                        showAllIngredients = false
                    }else {
                        showAllIngredients = true
                    }
                }
                
                if showAllIngredients{
                    Section(header: Text("Ingredients")) {
                        ForEach(ingredients) { ingredient in
                            HStack {
                                Image(ingredient.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text(ingredient.name)
                                Spacer()
                                if ingredient.isSaved { // change save icon if the ingredient is already saved
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "bookmark")
                                        .foregroundColor(.gray)
                                }
                            }
                            .onTapGesture { // set ingredient state as saved
                                // change this later to use Firebase
                                if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    ingredients[index].isSaved.toggle()
                                    appState.shouldUpdateRecipes = true
                                    if(ingredients[index].isSaved){
                                        appState.savedIngredients.append(ingredients[index])
                                        firebaseManager.saveIngredient(ingredients[index])
                                    }else{
                                        appState.savedIngredients.removeAll { ingredient in
                                            ingredient.name == ingredients[index].name
                                        }
                                        firebaseManager.removeIngredient(ingredients[index])
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Saved Ingredients")
            .onAppear {
                if !appState.ingredientsFetched {
                    updateIngredientsWithSaved()
                }
            }
        }
    
}

