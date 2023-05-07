//
//  RecipeCell.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 6/5/23.
//

import SwiftUI
import URLImage

struct RecipeCell: View {
    let recipe: Recipe
    @EnvironmentObject var appState: AppState
    let firebaseManager: FirebaseManager
    
    var body: some View {
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
                    
                    // Add dark overlay
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.4))
                        .frame(width: 350, height: 350)
                    
                    HStack{
                        Button(action: {
                            if appState.isRecipeSaved(recipe) {
                                if let existingRecipe = appState.savedRecipes.first(where: { $0.label == recipe.label }) {
                                    appState.savedRecipes.remove(existingRecipe)
                                    firebaseManager.removeRecipe(existingRecipe)
                                }
                            } else {
                                appState.savedRecipes.insert(recipe)
                                firebaseManager.saveRecipe(recipe)
                            }
                        }) {
                            Image(systemName: appState.isRecipeSaved(recipe) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.pink)
                                .font(.system(size: 30))
                                .padding()
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
}


