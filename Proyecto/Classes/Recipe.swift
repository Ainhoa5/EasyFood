//
//  Recipe.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/3/23.
//
import Foundation
struct Recipe: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let image: String
    let summary: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(image)
        hasher.combine(summary)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == rhs.title &&
            lhs.image == rhs.image &&
            lhs.summary == rhs.summary
    }
}
