//
//  SavedRecipesView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//
import SwiftUI

struct SavedRecipesView: View {
    @State private var savedRecipes: [String] = [] // savedRecipes

    var body: some View {
        List(savedRecipes, id: \.self) { recipeTitle in
            Text(recipeTitle)
                .font(.headline)
        }
        .onAppear { // fetch the saved recipes onAppear
            FirebaseManager.shared.fetchSavedRecipes { savedRecipes in
                self.savedRecipes = savedRecipes
            }
        }
    }
}




