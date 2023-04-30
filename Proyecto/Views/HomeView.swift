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
                    VStack{
                        if let imageURL = URL(string: recipe.image) {
                            ZStack(alignment: .bottomLeading) {
                                URLImage(imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .clipped()
                                .frame(width: 350, height: 350)
                                .cornerRadius(8)
                                //.clipShape(RoundedRectangle(cornerRadius: 8)) // Add this line to apply rounded corners
                                
                                // Add dark overlay
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.4))
                                    .frame(width: 350, height: 350)
                                
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
                                            .foregroundColor(.pink)
                                            .font(.system(size: 30))
                                            .padding() // Add padding around the image to increase the touch area of the button
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    Text(recipe.label)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Spacer()
                                }
                                .padding(.bottom)
                            }
                            
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray)
                                .frame(width: 300, height: 300)
                        }
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            EmptyView()
                        }
                        .opacity(0) // Hide the NavigationLink
                        
                        Spacer()
                    }
                    
                }
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle()) // Add this line to remove the white background color
            }
        }
        .onAppear {
            if !appState.fetchedRecipes {
                print("hehe")
                appState.fetchAndStoreRecipes()
                appState.fetchedRecipes = true
            }
            
            print(appState.shouldUpdateRecipes)
            if appState.shouldUpdateRecipes {
                fetchRecipesAndDisplay()
                appState.shouldUpdateRecipes = false
            }
            
        }
        .padding() // Add padding around the content
        
    }
    func fetchRecipesAndDisplay() {
        isLoading = true // Set isLoading to true before fetching recipes
        print(isLoading)
        EdamamManager.shared.fetchRecipes(appState) { result in
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




