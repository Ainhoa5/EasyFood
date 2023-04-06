//
//  MealType.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 6/4/23.
//

import Foundation
class RecipeTypes: Identifiable, ObservableObject {
    let id = UUID()
    let name: String
    let type: MealOptionType
    @Published var isSelected: Bool
    
    init(name: String, type: MealOptionType, isSelected: Bool = false) {
        self.name = name
        self.type = type
        self.isSelected = isSelected
    }
    
}

enum MealOptionType: String {
    case diet
    case health
    case mealType
    case dishType
}

