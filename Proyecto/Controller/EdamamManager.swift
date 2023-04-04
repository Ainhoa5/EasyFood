//
//  EdamamManager.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 3/4/23.
//

import Foundation

class EdamamManager {
    static let shared = EdamamManager()
    private let apiKey = "30ed7f012bab9748501c3bf3b109b2da"
    private let appId = "7036473e"
    private let baseURL = "https://api.edamam.com/api/recipes/v2?type=public"

    private init() {}
    
    func fetchRecipes(ingredients: [String], completion: @escaping (Result<[Recipe], Error>) -> Void) {
                let ingredientsString = ingredients.joined(separator: "%2C%20")
                print("IngredientsString: "+ingredientsString)
        
        guard let url = URL(string: "\(baseURL)&q=\(ingredientsString)&app_id=\(appId)&app_key=\(apiKey)&field=label&field=image&random=true") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("error data")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            // Print the JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                //print(jsonString)
            }
            
            print(data)
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(EdamamResponse.self, from: data)
                completion(.success(response.hits.map { $0.recipe }))
            } catch {
                print("decoding failure")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    struct EdamamResponse: Codable {
        let hits: [Hit]
    }
    
    struct Hit: Codable {
        let recipe: Recipe
    }
}

