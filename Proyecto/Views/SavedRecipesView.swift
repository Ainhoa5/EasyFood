//
//  SavedRecipesView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//
import SwiftUI
import URLImage

struct SavedRecipesView: View {
    @EnvironmentObject var appState: AppState
    @State private var savedRecipes: [String] = [] // savedRecipes
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(appState.savedRecipes), id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
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
                            
                            Text(recipe.label)
                        }
                    }
                    
                }
            }
            .navigationTitle("Saved Recipes")
        }
    }
}
