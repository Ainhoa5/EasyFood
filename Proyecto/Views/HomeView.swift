//
//  HomeView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var recipes: [Recipe] = [] // Initialize as an empty list
    //@State private var savedRecipes: Set<Recipe> = [] // list of saved recipes on this view
    //@State private var ingredients: [String] = [] // saved ingredients
    let firebaseManager = FirebaseManager() // Firebase manager
    @State private var isLoading = false // Add this line to track the loading status
    
    
    
    
    var body: some View {
        NavigationView {
            if isLoading {
                VStack {
                    ProgressView() // Show a loading indicator
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .frame(width: 50, height: 50) // Customize the ProgressView style
                    Text("Loading recipes...")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                }
            }else if recipes.isEmpty {
                VStack{
                    Image(systemName: "xmark.octagon") // Add an error icon
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)
                    Text("No recipes available.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.pink)
                    Text("We are sorry, we couldn't find any recipes matching your filters, maybe try some new ingredient if you haven't yet!")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                }.padding()
                
            }else{
                List(recipes) { recipe in
                    RecipeCell(recipe: recipe, firebaseManager: firebaseManager)
                }
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle()) // Add this line to remove the white background color
            }
        }
        .onAppear {
            let group = DispatchGroup()

            // Fetch users saved ingredients from db
            if !appState.ingredientsFetched {
                appState.updateSavedIngredients(group: group)
            }

            // Fetch users saved recipes from db
            if !appState.fetchedRecipes {
                appState.updateSavedRecipes(group: group) {
                    print("Completion handler called after updating saved recipes")
                }
            }

            group.notify(queue: .main) {
                // Update the fetched status
                appState.ingredientsFetched = true
                appState.fetchedRecipes = true

                // Checks if there has been changes on the filters and does a new API request if so
                if appState.shouldUpdateRecipes {
                    fetchRecipesAndDisplay()
                    appState.shouldUpdateRecipes = false
                }
            }
        }
        .padding() // Add padding around the content
        
    }
    func fetchRecipesAndDisplay() {
        isLoading = true // Set isLoading to true before fetching recipes
        print(isLoading)
        EdamamManager.shared.fetchRecipesFromApi(appState) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    // Update your UI with the fetched recipes
                    self.recipes = fetchedRecipes
                    isLoading = false // Set isLoading to false after fetching recipes
                case .failure(let error):
                    // Handle the error
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
        }
    }
}




