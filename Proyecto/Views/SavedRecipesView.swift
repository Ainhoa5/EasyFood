//
//  SavedRecipesView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//
import SwiftUI

struct SavedRecipesView: View {
    @State private var savedRecipes: [String] = []

    var body: some View {
        List(savedRecipes, id: \.self) { recipeTitle in
            Text(recipeTitle)
                .font(.headline)
        }
        .onAppear {
            FirebaseManager.shared.getSavedRecipes { savedRecipes in
                self.savedRecipes = savedRecipes
            }
        }
    }
}




