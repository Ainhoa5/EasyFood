//
//  ContentView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var firestoreManager = FirebaseManager()
    @State var recipes = [Recipe]()
    
    var body: some View {
        Group {
            if let user = Auth.auth().currentUser {
                if let email = user.email {
                    Text(email)
                } else {
                    Text("No email")
                }
                
                TabView {
                    HomeView(recipes: recipes)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    SavedRecipesView(savedRecipes: firestoreManager.savedRecipes)
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
                }
                .onChange(of: user) { user in
                    firestoreManager.loadData()
                }
            } else {
                LoginSignupView()
            }
        }
        .onAppear {
            firestoreManager.checkIfUserExistsAndLogout()
        }
    }
}





