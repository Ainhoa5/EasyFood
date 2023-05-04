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
    
    
    
    let firebaseManager = FirebaseManager() // Firebase manager
    @EnvironmentObject var appState: AppState
    
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
                        ForEach(appState.ingredients.filter({ $0.isSaved })) { ingredient in
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
                                if let index = appState.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    appState.ingredients[index].isSaved.toggle()
                                    firebaseManager.removeIngredient(appState.ingredients[index])
                                    appState.shouldUpdateRecipes = true
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
                        ForEach(appState.ingredients) { ingredient in
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
                            .onTapGesture {
                                // Find the index of the tapped ingredient in the appState's ingredients array
                                if let index = appState.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    // Toggle the isSaved property of the ingredient
                                    appState.ingredients[index].isSaved.toggle()
                                    appState.shouldUpdateRecipes = true
                                    
                                    // Save or remove the ingredient based on its isSaved status
                                    if appState.ingredients[index].isSaved {
                                        firebaseManager.saveIngredient(appState.ingredients[index])
                                        appState.shouldUpdateRecipes = true
                                    } else {
                                        firebaseManager.removeIngredient(appState.ingredients[index])
                                        appState.shouldUpdateRecipes = true
                                    }
                                }
                            }

                        }
                    }
                }
            }
            .navigationBarTitle("Saved Ingredients")
            .onAppear {
//                if !appState.ingredientsFetched {
//                    updateIngredientsWithSaved()
//                }
            }
        }
    
}

