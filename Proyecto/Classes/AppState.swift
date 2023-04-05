//
//  AppState.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 5/4/23.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var shouldUpdateRecipes: Bool = false
    @Published var ingredientsFetched: Bool = false
    @Published var recipes: [Recipe] = []
    @Published var savedIngredients: [Ingredient] = []
}
