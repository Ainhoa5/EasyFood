//
//  ContentView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = false //determines whether the user is logged into Firebase or not
    @StateObject private var appState = AppState()


    
    var body: some View {
        
        NavigationView {
            Group {
                TabView {
                    if isLoggedIn { // display tabbed Views
                        HomeView()
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
                        LoginSignupView(onSuccess: { // display LoginSignupView so the user can create an account / log in
                            self.isLoggedIn = true // to indicate the user is logged in now
                        })
                    }
                }
                .environmentObject(appState)
                .navigationBarTitle("My App")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: { // add log out button
                    FirebaseManager.shared.signOut()
                    isLoggedIn = false
                }) {
                    Text("Log Out")
                })
                
            }
        }
    }
}







