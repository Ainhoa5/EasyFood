//
//  SavedRecipesView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//
import SwiftUI

struct SavedRecipesView: View {
    let firestoreManager: FirebaseManager
        @State var savedRecipes: [Recipe] = []

        init(firestoreManager: FirebaseManager) {
            self.firestoreManager = firestoreManager
        }
    
    var body: some View {
        List(savedRecipes) { recipe in
            VStack(alignment: .leading) {
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                    .clipped()
                    .cornerRadius(10)
                
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
        .onAppear {
            firestoreManager.getSavedRecipes { recipes in
                savedRecipes = recipes
            }
        }
    }
}



