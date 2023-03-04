//
//  SavedIngredientsView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var isSaved: Bool = false
}

struct SavedIngredientsView: View {
    @State private var ingredients: [Ingredient] = [
        Ingredient(name: "Pasta", image: "cheese"),
        Ingredient(name: "Chicken", image: "cheese"),
        Ingredient(name: "Tomatoes", image: "cheese"),
        Ingredient(name: "Garlic", image: "cheese"),
        Ingredient(name: "Cheese", image: "cheese"),
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Ingredients")) {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Image(ingredient.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text(ingredient.name)
                            Spacer()
                            if ingredient.isSaved {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "bookmark")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                ingredients[index].isSaved.toggle()
                            }
                        }
                    }
                }
                Section(header: Text("Saved Ingredients")) {
                    ForEach(ingredients.filter({ $0.isSaved })) { ingredient in
                        HStack {
                            Image(ingredient.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text(ingredient.name)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .onTapGesture {
                            if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                ingredients[index].isSaved.toggle()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Saved Ingredients")
        }
    }
}

struct SavedIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedIngredientsView()
    }
}

