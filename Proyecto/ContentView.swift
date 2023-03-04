//
//  ContentView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var firestoreManager = FirebaseManager()
    
    let recipes = [
        Recipe(title: "Spaghetti with Meatballs", image: "spaghetti", summary: "Delicious spaghetti with homemade meatballs"),
        Recipe(title: "Grilled Chicken Caesar Salad", image: "salad", summary: "Fresh grilled chicken with crisp romaine lettuce and tangy Caesar dressing"),
        Recipe(title: "Chocolate Chip Cookies", image: "cookies", summary: "Classic chocolate chip cookies, perfect for any occasion")
    ]
    
    var body: some View {
        TabView {
            HomeView(recipes: recipes)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SavedRecipesView(firestoreManager: firestoreManager)
                .tabItem {
                    Label("Saved Recipes", systemImage: "bookmark")
                }
            
            SavedIngredientsView()
                .tabItem {
                    Label("Saved Ingredients", systemImage: "cart")
                }
        }
    }
}


