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
            VStack {
                VStack{
                    Text("Label: \(recipe.label)")
                    if let imageURL = URL(string: recipe.image) {
                        URLImage(imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    // IMAGES
                    Text("Images")
                        .font(.headline)
                        .bold()
                    
                    ForEach(Array(recipe.images.keys), id: \.self) { key in
                        if let imageInfo = recipe.images[key],
                           let imageURL = URL(string: imageInfo.url) {
                            Text("\(key)")
                            URLImage(imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(width: CGFloat(imageInfo.width), height: CGFloat(imageInfo.height))
                        }
                    }
                    
                    // OTHER
                    Text("Source: \(recipe.source)")
                    Text("URL: \(recipe.url)")
                    Text("Yield: \(recipe.yield)")
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Diet Labels")
                            .font(.headline)
                            .bold()
                        
                        ForEach(recipe.dietLabels, id: \.self) { label in
                            Text("• \(label)")
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Health Labels")
                            .font(.headline)
                            .bold()
                        
                        ForEach(recipe.healthLabels, id: \.self) { label in
                            Text("• \(label)")
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cautions")
                            .font(.headline)
                            .bold()

                        ForEach(recipe.cautions, id: \.self) { caution in
                            Text("• \(caution)")
                        }
                    }

                }
                                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.headline)
                        .bold()

                    ForEach(recipe.ingredientLines, id: \.self) { line in
                        Text("• \(line)")
                    }
                }
                Text("Total Time: \(recipe.totalTime) minutes")
                VStack(alignment: .leading, spacing: 10) {
                                    Text("Cuisine Type")
                                        .font(.headline)
                                        .bold()
                                    
                                    ForEach(recipe.cuisineType, id: \.self) { cuisine in
                                        Text("• \(cuisine)")
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Meal Type")
                                        .font(.headline)
                                        .bold()
                                    
                                    ForEach(recipe.mealType, id: \.self) { meal in
                                        Text("• \(meal)")
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Dish Type")
                                        .font(.headline)
                                        .bold()
                                    
                                    ForEach(recipe.dishType, id: \.self) { dish in
                                        Text("• \(dish)")
                                    }
                                }
            }
            .padding()
        }
    }
}
