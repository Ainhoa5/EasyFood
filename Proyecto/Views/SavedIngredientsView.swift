//
//  SavedIngredientsView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 2/3/23.
//

import SwiftUI


struct SavedIngredientsView: View {
    @State private var ingredients: [Ingredient] = [
        Ingredient(name: "Pasta", image: "cheese"),
        Ingredient(name: "Chicken", image: "cheese"),
        Ingredient(name: "Tomatoes", image: "cheese"),
        Ingredient(name: "Garlic", image: "cheese"),
        Ingredient(name: "Cheese", image: "cheese"),
    ] // dummy data
    let firebaseManager = FirebaseManager() // Firebase manager
    
    var body: some View {
        NavigationView {
            List {
                // all ingredients section
                Section(header: Text("Ingredients")) {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Image(ingredient.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text(ingredient.name)
                            Spacer()
                            if ingredient.isSaved { // change save icon if the ingredient is already saved
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "bookmark")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture { // set ingredient state as saved
                            // change this later to use Firebase
                            if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                ingredients[index].isSaved.toggle()
                                if(ingredients[index].isSaved){
                                    firebaseManager.saveIngredient(ingredients[index])
                                }else{
                                    firebaseManager.removeIngredient(ingredients[index])
                                }
                            }
                        }
                    }
                }
                
                // saved ingredients section
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
                                firebaseManager.removeIngredient(ingredients[index])
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

