//
//  HomeView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI

struct HomeView: View {
    let recipes: [Recipe]
    @State private var savedRecipes: Set<Recipe> = []
    let firebaseManager = FirebaseManager()
    
    var body: some View {
        List(recipes) { recipe in
            VStack(alignment: .leading) {
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                    .clipped()
                    .cornerRadius(10)
                
                    Button(action: {
                        if !savedRecipes.contains(recipe) {
                            savedRecipes.insert(recipe)
                            firebaseManager.saveRecipe(recipe)
                        }
                    }) {
                        Image(systemName: savedRecipes.contains(recipe) ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                
                
                Text(recipe.title)
                    .font(.headline)
                
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .listStyle(.plain)
    }
}


