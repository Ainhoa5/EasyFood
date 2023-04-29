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
    //@State private var savedRecipes: Set<Recipe> = [] // list of saved recipes on this view
    //@State private var ingredients: [String] = [] // saved ingredients
    let firebaseManager = FirebaseManager() // Firebase manager
    
    
    
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                VStack{
                    if let imageURL = URL(string: recipe.image) {
                        URLImage(imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .clipped()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 8)) // Add this line to apply rounded corners
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)
                            .frame(width: 300, height: 300)
                    }
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack{
                            Button(action: { // Save recipe button
                                if appState.savedRecipes.contains(recipe) { // if the recipe is already on the list
                                    appState.savedRecipes.remove(recipe) // remove from local list
                                    firebaseManager.removeRecipe(recipe) // remove from firebase document
                                } else {
                                    appState.savedRecipes.insert(recipe) // save in local list
                                    firebaseManager.saveRecipe(recipe) // save in firebase document
                                }
                                
                            }) {
                                Image(systemName: appState.savedRecipes.contains(recipe) ? "bookmark.fill" : "bookmark") // change icon depending if the recipe is saved or not
                                    .foregroundColor(.blue)
                                    .imageScale(.large) // Increase the size of the image
                                    .padding() // Add padding around the image to increase the touch area of the button
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Text(recipe.label)
                                .font(.headline)
                        }
                    }
                    .padding(.bottom)
                    .padding(.bottom)
                    Spacer()
                }
                
            }
            .onAppear {
                if !appState.fetchedRecipes {
                    print("hehe")
                    appState.fetchAndStoreRecipes()
                    appState.fetchedRecipes = true
                }
                
                
                if appState.shouldUpdateRecipes {
                    fetchRecipesAndDisplay()
                    appState.shouldUpdateRecipes = false
                }
                
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(PlainListStyle()) // Add this line to remove the white background color
        }
        
        .padding() // Add padding around the content
        
    }
    func fetchRecipesAndDisplay() {
        EdamamManager.shared.fetchRecipes(appState) { result in
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




