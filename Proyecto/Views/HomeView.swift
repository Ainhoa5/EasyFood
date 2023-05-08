//
//  HomeView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            if appState.isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .frame(width: 50, height: 50)
                    Text("Loading recipes...")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                }
            } else if appState.recipes.isEmpty {
                VStack {
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)
                    Text("No recipes available.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.pink)
                    Text("We are sorry, we couldn't find any recipes matching your filters, maybe try some new ingredient if you haven't yet!")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                }.padding()

            } else {
                List(appState.recipes) { recipe in
                    RecipeCell(recipe: recipe, firebaseManager: FirebaseManager())
                }
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle())
            }
        }
        .onAppear{
            appState.fetchRecipesAndDisplay()
        }
        .padding()
    }
}
