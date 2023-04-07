//
//  RecipeDetailView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 7/4/23.
//

import SwiftUI
import URLImage

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageURL = URL(string: recipe.image) {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }

                Text(recipe.label)
                    .font(.largeTitle)
                    .bold()

                // Add other recipe details as needed, e.g., source, dietLabels, etc.

                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.headline)
                        .bold()

                    ForEach(recipe.ingredientLines, id: \.self) { line in
                        Text("• \(line)")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
