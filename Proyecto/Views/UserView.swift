//
//  UserView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 4/3/23.
//

import SwiftUI

struct UserView: View {
    // toggle
    @State private var showMealTypes: Bool = false
    @State private var showDishTypes: Bool = false
    @State private var showDietTypes: Bool = false
    @State private var showHealthTypes: Bool = false
    
    
    @EnvironmentObject var appState: AppState
    @StateObject private var firebaseManager = FirebaseManager()
    // filters
    @State private var selectedMealType: String = ""
    @State private var selectedDishType: String = ""
    @State private var selectedDietType: String = ""
    
    
    
    // grid layout
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10)
    ]
    
    
    struct CustomToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
                    .foregroundColor(.white)
                    .padding(10)
                    .background(configuration.isOn ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
            }
        }
    }
    
    
    var body: some View {
        ScrollView{
            VStack {
                Toggle(isOn: $showMealTypes) {
                    Text("Meal Types")
                }.padding()
                
                if showMealTypes {
                    ForEach(Array(appState.mealTypes.enumerated()), id: \.1.id) { index, mealType in
                        Toggle(mealType.name, isOn: bindingForMealType(at: index))
                    }
                }
                
                Toggle(isOn: $showDietTypes) {
                    Text("Diet Types")
                }.padding()
                
                if showDietTypes {
                    ForEach(Array(appState.dietTypes.enumerated()), id: \.1.id) { index, dietType in
                        Toggle(dietType.name, isOn: bindingForDietType(at: index))
                    }
                }
                
                Toggle(isOn: $showDishTypes) {
                    Text("Dish Types")
                }.padding()
                
                if showDishTypes {
                    ForEach(Array(appState.dishTypes.enumerated()), id: \.1.id) { index, dishType in
                        Toggle(dishType.name, isOn: bindingForDishType(at: index))
                    }
                }
                
                Toggle(isOn: $showHealthTypes) {
                    Text("Health restrictions")
                }.padding()
                
                if showHealthTypes {
                    ForEach(Array(appState.health.enumerated()), id: \.1.id) { index, healhType in
                        Toggle(healhType.name, isOn: bindingForHealthType(at: index))
                    }
                }
                
                
                
                
                
                Button(action: {
                    // Perform the search with the selected filters
                    print("Selected Meal Type: \(appState.selectedMealTypes)")
                    print("Selected Dish Type: \(appState.selectedDishypes)")
                    print("Selected Diet Type: \(appState.selectedDietTypes)")
                    print("Selected Health Type: \(appState.selectedHealthTypes)")
                }) {
                    Text("Search")
                }.padding()
            }
            .onAppear {
                firebaseManager.fetchSavedMealTypes("savedDishTypes") { savedMealTypeNames in
                    updateDishTypesWithSaved(savedMealTypeNames)
                }
                firebaseManager.fetchSavedMealTypes("savedDietTypes") { savedMealTypeNames in
                    updateDietTypesWithSaved(savedMealTypeNames)
                }
                firebaseManager.fetchSavedMealTypes("savedHealthTypes") { savedMealTypeNames in
                    updateHealthTypesWithSaved(savedMealTypeNames)
                }
                firebaseManager.fetchSavedMealTypes("savedMealTypes") { savedMealTypeNames in
                    updateMealTypesWithSaved(savedMealTypeNames)
                }
            }
        }
        
    }
    func bindingForMealType(at index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.appState.mealTypes[index].isSelected },
            set: { newValue in
                self.appState.mealTypes[index].isSelected = newValue
                if newValue {
                    firebaseManager.saveMealType(self.appState.mealTypes[index].name, "savedMealTypes")
                    self.appState.selectedMealTypes.insert(self.appState.mealTypes[index].name)
                    print(self.appState.mealTypes[index].isSelected)
                    
                } else {
                    firebaseManager.removeMealType(self.appState.mealTypes[index].name, "savedMealTypes")
                    self.appState.selectedMealTypes.remove(self.appState.mealTypes[index].name)
                    print(self.appState.mealTypes[index].isSelected)
                }
            }
        )
    }
    
    func bindingForDishType(at index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.appState.dishTypes[index].isSelected },
            set: { newValue in
                self.appState.dishTypes[index].isSelected = newValue
                if newValue {
                    firebaseManager.saveMealType(self.appState.dishTypes[index].name, "savedDishTypes")
                    self.appState.selectedDishypes.insert(self.appState.dishTypes[index].name)
                    print(self.appState.dishTypes[index].isSelected)
                    
                } else {
                    firebaseManager.removeMealType(self.appState.dishTypes[index].name, "savedDishTypes")
                    self.appState.selectedDishypes.remove(self.appState.dishTypes[index].name)
                    print(self.appState.dishTypes[index].isSelected)
                }
            }
        )
    }
    
    func bindingForDietType(at index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.appState.dietTypes[index].isSelected },
            set: { newValue in
                self.appState.dietTypes[index].isSelected = newValue
                if newValue {
                    firebaseManager.saveMealType(self.appState.dietTypes[index].name, "savedDietTypes")
                    self.appState.selectedDietTypes.insert(self.appState.dietTypes[index].name)
                    print(self.appState.dietTypes[index].isSelected)
                    
                } else {
                    firebaseManager.removeMealType(self.appState.dietTypes[index].name, "savedDietTypes")
                    self.appState.selectedDietTypes.remove(self.appState.dietTypes[index].name)
                    print(self.appState.dietTypes[index].isSelected)
                }
            }
        )
    }
    
    func bindingForHealthType(at index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.appState.health[index].isSelected },
            set: { newValue in
                self.appState.health[index].isSelected = newValue
                if newValue {
                    firebaseManager.saveMealType(self.appState.health[index].name, "savedHealthTypes")
                    self.appState.selectedHealthTypes.insert(self.appState.health[index].name)
                    print(self.appState.health[index].isSelected)
                    
                } else {
                    firebaseManager.removeMealType(self.appState.health[index].name, "savedHealthTypes")
                    self.appState.selectedHealthTypes.remove(self.appState.health[index].name)
                    print(self.appState.health[index].isSelected)
                }
            }
        )
    }
    
    
    
    private func updateMealTypesWithSaved(_ savedMealTypeNames: [String]) {
        for mealTypeName in savedMealTypeNames {
            if let index = appState.mealTypes.firstIndex(where: { $0.name == mealTypeName }) {
                appState.mealTypes[index].isSelected = true
                appState.selectedMealTypes.insert(appState.mealTypes[index].name)
            }
        }

    }
    private func updateDishTypesWithSaved(_ savedDishTypeName: [String]){
        for dishTypeName in savedDishTypeName {
            if let index = appState.dishTypes.firstIndex(where: { $0.name == dishTypeName }) {
                appState.dishTypes[index].isSelected = true
                appState.selectedDishypes.insert(appState.dishTypes[index].name)
            }
        }
    }
    private func updateDietTypesWithSaved(_ savedDietTypeName: [String]){
        for dietTypeName in savedDietTypeName {
            if let index = appState.dietTypes.firstIndex(where: { $0.name == dietTypeName }) {
                appState.dietTypes[index].isSelected = true
                appState.selectedDietTypes.insert(appState.dietTypes[index].name)
            }
        }
    }
    private func updateHealthTypesWithSaved(_ savedHealthTypeNames: [String]){
        for healthTypeName in savedHealthTypeNames {
            if let index = appState.health.firstIndex(where: { $0.name == healthTypeName }) {
                appState.health[index].isSelected = true
                appState.selectedHealthTypes.insert(appState.health[index].name)
            }
        }
    }
}


//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
