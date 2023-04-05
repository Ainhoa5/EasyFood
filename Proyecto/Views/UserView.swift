//
//  UserView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 4/3/23.
//

import SwiftUI

struct UserView: View {
    // filters
    @State private var showFilters: Bool = false
    @State private var selectedMealType: String = ""
    @State private var selectedDishType: String = ""
    @State private var selectedDietType: String = ""
    
    let mealTypes = ["Breakfast", "Lunch", "Dinner","Snack","Teatime"]
    let dishTypes = ["Biscuits and cookies", "Bread", "Cereals", "Condiments and souces", "Desserts", "Drinks", "Main course", "Pancake", "Preps", "Preserve", "Salad", "Sandwiches", "Side dish", "Soup", "Starter", "Sweets"]
    let dietTypes = ["balanced", "high-fiber", "high-protein","low-carb","low-fat","low-sodium"]
    @StateObject private var firestoreManager = FirebaseManager()
    @State private var user: User?
    
    var body: some View {
        VStack {
            
        }.padding()
        VStack {
            Toggle(isOn: $showFilters) {
                Text("Show Filters")
            }.padding()
            
            if showFilters {
                Picker("Meal Type", selection: $selectedMealType) {
                    ForEach(mealTypes, id: \.self) { mealType in
                        Text(mealType).tag(mealType)
                    }
                }.pickerStyle(MenuPickerStyle())
                Picker("Dish Type", selection: $selectedDishType) {
                    ForEach(dishTypes, id: \.self) { dishType in
                        Text(dishType).tag(dishType)
                    }
                }.pickerStyle(MenuPickerStyle())
                Picker("Diet Type", selection: $selectedDietType) {
                    ForEach(dietTypes, id: \.self) { dietTypes in
                        Text(dietTypes).tag(dietTypes)
                    }
                }.pickerStyle(MenuPickerStyle())
            }
            
            Button(action: {
                // Perform the search with the selected filters
                print("Selected Meal Type: \(selectedMealType)")
                print("Selected Dish Type: \(selectedDishType)")
            }) {
                Text("Search")
            }.padding()
            
            // Show user data
            if let user = user {
                Text("Email: \(user.email)")
                Text("Name: \(user.name)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            firestoreManager.fetchUserDocument { user, error in
                if let error = error {
                    print("Failed to fetch user document: \(error.localizedDescription)")
                    return
                }
                self.user = user
            }
        }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
