import SwiftUI

struct FilterView: View {
    // toggle
    @State private var showMealTypes: Bool = false
    @State private var showDishTypes: Bool = false
    @State private var showDietTypes: Bool = false
    @State private var showHealthTypes: Bool = false
    
    @EnvironmentObject var appState: AppState
    @StateObject private var firebaseManager = FirebaseManager()

    // Set the initial state for the already saved filters

    // This function toggles the selection state of a recipe type
    func toggleSelection(_ recipeType: RecipeTypes) {
        recipeType.isSelected.toggle()
        
        let typeString = recipeType.type.rawValue
        
        switch recipeType.type {
        case .mealType:
            if recipeType.isSelected {
                appState.selectedMealTypes.insert(recipeType.name)
            } else {
                appState.selectedMealTypes.remove(recipeType.name)
            }
        case .diet:
            if recipeType.isSelected {
                appState.selectedDietTypes.insert(recipeType.name)
            } else {
                appState.selectedDietTypes.remove(recipeType.name)
            }
        case .dishType:
            if recipeType.isSelected {
                appState.selectedDishTypes.insert(recipeType.name)
            } else {
                appState.selectedDishTypes.remove(recipeType.name)
            }
        case .health:
            if recipeType.isSelected {
                appState.selectedHealthTypes.insert(recipeType.name)
            } else {
                appState.selectedHealthTypes.remove(recipeType.name)
            }
        }

        if recipeType.isSelected {
            firebaseManager.saveRecipeType(recipeType.name, typeString)
        } else {
            firebaseManager.removeMealType(recipeType.name, typeString)
        }

    }

    // This view represents a single recipe type in the filter
    func recipeTypeView(_ recipeType: RecipeTypes) -> some View {
        Text(recipeType.name)
            .padding()
            .background(recipeType.isSelected ? Color.orange.opacity(0.6) : Color.clear)
            .foregroundColor(recipeType.isSelected ? .white : .primary)
            .cornerRadius(8)
            .onTapGesture {
                toggleSelection(recipeType)
            }
    }
    var body: some View {
        NavigationView {
            List {
                // Meal Types section
                // Meal Types section
                Section() {
                    HStack {
                        Image("meal")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Meal Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showMealTypes.toggle()
                    }
                    
                    if showMealTypes {
                        ForEach(appState.mealTypes) { mealType in
                            recipeTypeView(mealType)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Dish Types section
                Section() {
                    HStack {
                        Image("dish")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Dish Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showDishTypes.toggle()
                    }
                    
                    if showDishTypes {
                        ForEach(appState.dishTypes) { dishType in
                            recipeTypeView(dishType)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Diet Types section
                Section() {
                    HStack {
                        Image("diet")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Diet Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showDietTypes.toggle()
                    }
                    .background(.white)
                    
                    if showDietTypes {
                        ForEach(appState.dietTypes) { dietType in
                            recipeTypeView(dietType)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Health Types section
                Section() {
                    HStack {
                        Image("health")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Health Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showHealthTypes.toggle()
                    }
                    .background(.white)
                    
                    if showHealthTypes {
                        ForEach(appState.health) { healthType in
                            recipeTypeView(healthType)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView().environmentObject(AppState())
    }
}
