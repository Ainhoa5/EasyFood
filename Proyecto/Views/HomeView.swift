//
//  HomeView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI
import URLImage

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var recipes: [Recipe] = [] // Initialize as an empty list
    @State private var savedRecipes: Set<Recipe> = [] // list of saved recipes on this view
    @State private var ingredients: [String] = [] // saved ingredients
    let firebaseManager = FirebaseManager() // Firebase manager
    
    
    
    
    var body: some View {
        
        List(recipes) { recipe in // list of recipes to show on View
            VStack(alignment: .leading) {
                
                if let imageURL = URL(string: recipe.image) {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width: 100, height: 100)
                    .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                }
                
                Button(action: { // Save recipe button
                    if savedRecipes.contains(recipe) { // if the recipe is already on the list
                        savedRecipes.remove(recipe) // remove from local list
                        firebaseManager.removeRecipe(recipe) // remove from firebase document
                    } else {
                        savedRecipes.insert(recipe) // save in local list
                        firebaseManager.saveRecipe(recipe) // save in firebase document
                    }
                    
                }) {
                    Image(systemName: savedRecipes.contains(recipe) ? "bookmark.fill" : "bookmark") // change icon depending if the recipe is saved or not
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Text(recipe.label)
                    .font(.headline)
            }
        }
        .listStyle(.plain)
        .onAppear {
            if appState.shouldUpdateRecipes {
                fetchRecipesAndDisplay()
                appState.shouldUpdateRecipes = false
            }
            
        }
    }
    
    
    func fetchRecipesAndDisplay() {
        
        self.ingredients = appState.savedIngredients.map { $0.name }
        print(self.ingredients)
        
        EdamamManager.shared.fetchRecipes(appState, ingredients: ingredients) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    // Update your UI with the fetched recipes
                    self.recipes = fetchedRecipes
                case .failure(let error):
                    // Handle the error
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
        }
    }
}



