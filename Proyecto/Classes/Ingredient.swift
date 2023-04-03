//
//  Ingredient.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/4/23.
//

import Foundation
struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var isSaved: Bool = false
}

