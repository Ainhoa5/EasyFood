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
    let images: [String: ImageInfo]
    let source: String
    let url: String
    let yield: Int
    let dietLabels: [String]
    let healthLabels: [String]
    let cautions: [String]
    let ingredientLines: [String]
    let totalTime: Int
    let cuisineType: [String]
    let mealType: [String]
    let dishType: [String]

    struct ImageInfo: Codable {
        let url: String
        let width: Int
        let height: Int
    }
    
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
