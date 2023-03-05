//
//  ContentView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = false
    let recipes = [
        Recipe(title: "Spaghetti with Meatballs", image: "spaghetti", summary: "Delicious spaghetti with homemade meatballs"),
        Recipe(title: "Grilled Chicken Caesar Salad", image: "salad", summary: "Fresh grilled chicken with crisp romaine lettuce and tangy Caesar dressing"),
        Recipe(title: "Chocolate Chip Cookies", image: "cookies", summary: "Classic chocolate chip cookies, perfect for any occasion")
    ]
    
    var body: some View {
        NavigationView {
            Group {
                
                TabView {
                    if isLoggedIn {
                        HomeView(recipes: recipes)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        SavedRecipesView()
                            .tabItem {
                                Label("Saved Recipes", systemImage: "bookmark")
                            }
                        SavedIngredientsView()
                            .tabItem {
                                Label("Saved Ingredients", systemImage: "cart")
                            }
                        UserView()
                            .tabItem {
                                Label("User", systemImage: "person.circle")
                            }
                    } else {
                        LoginSignupView(onSuccess: {
                            self.isLoggedIn = true
                        })
                    }
                }
                .navigationBarTitle("My App")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {
                    FirebaseManager.shared.signOut()
                    isLoggedIn = false
                }) {
                    Text("Log Out")
                })
                
            }
        }
    }
}







