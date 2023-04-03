//
//  Recipe.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//
import Foundation
struct Recipe: Identifiable, Codable, Hashable  {
    let id = UUID()
    let label: String
    let image: String
    let summary: String
    let url: String
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
        hasher.combine(image)
        hasher.combine(summary)
        hasher.combine(url)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.label == rhs.label &&
        lhs.image == rhs.image &&
        lhs.summary == rhs.summary &&
        lhs.url == rhs.url
    }
}
