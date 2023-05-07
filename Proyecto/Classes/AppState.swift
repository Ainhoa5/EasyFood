//
//  AppState.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 5/4/23.
//

import SwiftUI

class AppState: ObservableObject {
    // MARK: - MANAGERS
    let firebaseManager = FirebaseManager()
    let group = DispatchGroup()
    
    
    // MARK: - STATIC data
    @Published var ingredients: [Ingredient] = [
        Ingredient(name: "Pasta", image: "pasta"),
        Ingredient(name: "Chicken", image: "chicken"),
        Ingredient(name: "Garlic", image: "garlic"),
        Ingredient(name: "Cheese", image: "cheese"),
    ] // Available ingredients
    @Published var mealTypes: [RecipeTypes] = [
        RecipeTypes(name: "Breakfast", type: .mealType),
        RecipeTypes(name: "Lunch", type: .mealType),
        RecipeTypes(name: "Dinner", type: .mealType),
        RecipeTypes(name: "Snack", type: .mealType),
        RecipeTypes(name: "Teatime", type: .mealType)
    ] // Available meal types
    @Published var dietTypes: [RecipeTypes] = [
        RecipeTypes(name: "balanced", type: .diet),
        RecipeTypes(name: "high-fiber", type: .diet),
        RecipeTypes(name: "high-protein", type: .diet),
        RecipeTypes(name: "low-carb", type: .diet),
        RecipeTypes(name: "low-fat", type: .diet),
        RecipeTypes(name: "low-sodium", type: .diet)
    ] // Available diet types
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
    ] // Available dish types
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
    ] // Available health types
    
    // MARK: - DYNAMIC data
    @Published var recipes: [Recipe] = [] // recipes to be displayed on HomeView
    @Published var isLoading: Bool = false // recipe loading state for HomeView
    
    
    // MARK: - SAVED data (for the current user)
    @Published var savedRecipes: Set<Recipe> = []
    @Published var selectedMealTypes: Set<String> = []
    @Published var selectedDietTypes: Set<String> = []
    @Published var selectedDishTypes: Set<String> = []
    @Published var selectedHealthTypes: Set<String> = []
    
    // MARK: - Boolean condition
    @Published var shouldUpdateRecipes: Bool = false // checks if the there has been a change on the filters to update the recipes displayed on the HomeView
    
    init() {
        // Fetch all the user's saved data needed for the app to work as intended
        updateSavedIngredients(group: group)
        
        // Fetch users saved recipes from db
        updateSavedRecipes(group: group)
        
        // Fetch users saved meal types from db
        updateSelectedFilterTypes(type: "mealType", filterTypes: self.mealTypes) { types in
            self.selectedMealTypes = types
        }
        
        updateSelectedFilterTypes(type: "diet", filterTypes: self.dietTypes) { types in
            self.selectedDietTypes = types
        }
        
        updateSelectedFilterTypes(type: "dishType", filterTypes: self.dishTypes) { types in
            self.selectedDishTypes = types

        }
        
        updateSelectedFilterTypes(type: "health", filterTypes: self.health) { types in
            self.selectedHealthTypes = types

        }
        group.notify(queue: .main) { // once the functions above have been completed
            self.shouldUpdateRecipes = true
        }
    }
    
    // MARK: - Fetch user's saved data
    func updateSavedRecipes(group: DispatchGroup) {
        group.enter()
        firebaseManager.fetchRecipes { [weak self] recipes in
            guard let self = self else { return }
            
            self.savedRecipes = Set(recipes)
            group.leave()
        }
    } // fetch all the user's saved recipes on the db
    func updateSavedIngredients(group: DispatchGroup) {
        group.enter()
        firebaseManager.fetchSavedIngredients { [weak self] savedIngredients in
            guard let self = self else { return }
            
            for ingredientName in savedIngredients {
                if let index = self.ingredients.firstIndex(where: { $0.name == ingredientName }) {
                    self.ingredients[index].isSaved = true
                }
            }
            group.leave()
        }
    } // fetch the user's saved ingredients from the db
    func updateSelectedFilterTypes(type: String, filterTypes: [RecipeTypes], completion: @escaping (Set<String>) -> Void) {
        self.group.enter()
        firebaseManager.fetchSavedMealTypes(type) { types in
            let selectedTypes = Set(types)
            for filterType in filterTypes {
                if selectedTypes.contains(filterType.name) {
                    filterType.isSelected = true
                }
            }
            completion(selectedTypes)
            self.group.leave()
        }
    } // fetch the user's saved filters from the db

    // check if a given recipe is already saved on savedRecipes
    func isRecipeSaved(_ recipe: Recipe) -> Bool {
        let isSaved = savedRecipes.contains(where: { $0.label == recipe.label })
        return isSaved
    }
    // fetch the recipes that will be displayed on the HomeView
    func fetchRecipesAndDisplay() {
        if self.shouldUpdateRecipes{
            self.isLoading = true
            EdamamManager.shared.fetchRecipesFromApi(self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedRecipes):
                        self.recipes = fetchedRecipes
                        self.isLoading = false
                    case .failure(let error):
                        print("Error fetching recipes: \(error.localizedDescription)")
                    }
                }
            }
        }
        
    }
    
}
