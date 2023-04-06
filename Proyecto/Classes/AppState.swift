//
//  AppState.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 5/4/23.
//

import SwiftUI

class AppState: ObservableObject {
    // saved variables
    @Published var selectedMealTypes: Set<String> = []
    @Published var selectedDietTypes: Set<String> = []
    @Published var selectedDishypes: Set<String> = []
    @Published var selectedHealthTypes: Set<String> = []
    @Published var recipes: [Recipe] = []
    @Published var savedIngredients: [Ingredient] = []
    
    // Types
    @Published var mealTypes: [RecipeTypes] = [
        RecipeTypes(name: "Breakfast", type: .mealType),
        RecipeTypes(name: "Lunch", type: .mealType),
        RecipeTypes(name: "Dinner", type: .mealType),
        RecipeTypes(name: "Snack", type: .mealType),
        RecipeTypes(name: "Teatime", type: .mealType)
    ]

    @Published var dietTypes: [RecipeTypes] = [
        RecipeTypes(name: "balanced", type: .diet),
        RecipeTypes(name: "high-fiber", type: .diet),
        RecipeTypes(name: "high-protein", type: .diet),
        RecipeTypes(name: "low-carb", type: .diet),
        RecipeTypes(name: "low-fat", type: .diet),
        RecipeTypes(name: "low-sodium", type: .diet)
    ]

    @Published var dishTypes: [RecipeTypes] = [
        RecipeTypes(name: "Biscuits and cookies", type: .dishType),
        RecipeTypes(name: "Bread", type: .dishType),
        RecipeTypes(name: "Cereals", type: .dishType),
        RecipeTypes(name: "Condiments and sauces", type: .dishType),
        RecipeTypes(name: "Desserts", type: .dishType),
        RecipeTypes(name: "Drinks", type: .dishType),
        RecipeTypes(name: "Main course", type: .dishType),
        RecipeTypes(name: "Pancake", type: .dishType),
        RecipeTypes(name: "Preps", type: .dishType),
        RecipeTypes(name: "Preserve", type: .dishType),
        RecipeTypes(name: "Salad", type: .dishType),
        RecipeTypes(name: "Sandwiches", type: .dishType),
        RecipeTypes(name: "Side dish", type: .dishType),
        RecipeTypes(name: "Soup", type: .dishType),
        RecipeTypes(name: "Starter", type: .dishType),
        RecipeTypes(name: "Sweets", type: .dishType)
    ]

    @Published var health: [RecipeTypes] = [
        RecipeTypes(name: "alcohol-free", type: .health),
        RecipeTypes(name: "celery-free", type: .health),
        RecipeTypes(name: "crustacean-free", type: .health),
        RecipeTypes(name: "dairy-free", type: .health),
        RecipeTypes(name: "DASH", type: .health),
        RecipeTypes(name: "egg-free", type: .health),
        RecipeTypes(name: "fish-free", type: .health),
        RecipeTypes(name: "fodmap-free", type: .health),
        RecipeTypes(name: "gluten-free", type: .health),
        RecipeTypes(name: "immuno-supportive", type: .health),
        RecipeTypes(name: "keto-friendly", type: .health),
        RecipeTypes(name: "kidney-friendly", type: .health),
        RecipeTypes(name: "kosher", type: .health),
        RecipeTypes(name: "low-fat-abs", type: .health),
        RecipeTypes(name: "low-potassium", type: .health),
        RecipeTypes(name: "low-sugar", type: .health),
        RecipeTypes(name: "lupine-free", type: .health),
        RecipeTypes(name: "Mediterranean", type: .health),
        RecipeTypes(name: "mollusk-free", type: .health),
        RecipeTypes(name: "mustard-free", type: .health),
        RecipeTypes(name: "no-oil-added", type: .health),
        RecipeTypes(name: "paleo", type: .health),
        RecipeTypes(name: "peanut-free", type: .health),
        RecipeTypes(name: "pescatarian", type: .health),
        RecipeTypes(name: "pork-free", type: .health),
        RecipeTypes(name: "red-meat-free", type: .health),
        RecipeTypes(name: "sesame-free", type: .health),
        RecipeTypes(name: "shellfish-free", type: .health),
        RecipeTypes(name: "soy-free", type: .health),
        RecipeTypes(name: "sugar-conscious", type: .health),
        RecipeTypes(name: "sulfite-free", type: .health),
        RecipeTypes(name: "tree-nut-free", type: .health),
        RecipeTypes(name: "vegan", type: .health),
        RecipeTypes(name: "vegetarian", type: .health),
        RecipeTypes(name: "wheat-free", type: .health)
    ]

    
    
    
    // conditions
    @Published var shouldUpdateRecipes: Bool = false
    @Published var ingredientsFetched: Bool = false
}
