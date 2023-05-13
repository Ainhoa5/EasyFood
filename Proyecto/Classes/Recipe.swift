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
}
