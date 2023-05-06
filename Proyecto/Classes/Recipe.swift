//
//  Recipe.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//
import Foundation
struct Recipe: Identifiable, Codable, Hashable  {
    let id: UUID = UUID()
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    let dietLabels: [String]
    let healthLabels: [String]
    let cautions: [String]
    let cuisineType: [String]
    let mealType: [String]
    let dishType: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
        hasher.combine(image)
        hasher.combine(url)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.label == rhs.label &&
        lhs.image == rhs.image &&
        lhs.url == rhs.url
    }
}
