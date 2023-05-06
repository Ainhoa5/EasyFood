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
    
    func fetchRecipesFromApi(_ appState: AppState, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        // TYPES
        let mealTypeQueryString = appState.selectedMealTypes.map { "&mealType=\($0)" }.joined()
        let dishTypeQueryString = appState.selectedDishypes.map {
            "&dishType=" + $0.replacingOccurrences(of: " ", with: "%20")
        }.joined()
        let dietTypeQueryString = appState.selectedDietTypes.map { "&diet=\($0)" }.joined()
        let healthTypeQueryString = appState.selectedHealthTypes.map { "&health=\($0)" }.joined()

        // INGREDIENTS
        let ingredientsString = appState.ingredients.filter { $0.isSaved }.map { $0.name }.joined(separator: "%2C%20")
        //print("IngredientsString: " + ingredientsString)
        
        
        guard let url = URL(string: "\(baseURL)&q=\(ingredientsString)&app_id=\(appId)&app_key=\(apiKey)&field=label&field=image&field=images&field=source&field=url&field=yield&field=dietLabels&field=healthLabels&field=cautions&field=ingredientLines&field=totalTime&field=cuisineType&field=mealType&field=dishType&random=false\(dishTypeQueryString)\(mealTypeQueryString)\(dietTypeQueryString)\(healthTypeQueryString)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        //print(url)
        
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
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print(jsonString)
//            }
            
            //print(data)
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
    
 
    func fetchSpecificRecipe(recipeLabels: [String], completion: @escaping (Result<Set<Recipe>, Error>) -> Void) {
        var fetchedRecipes: Set<Recipe> = []

        let group = DispatchGroup()

        for label in recipeLabels {
            group.enter()

            guard let encodedLabel = label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "\(baseURL)&q=\(encodedLabel)&app_id=\(appId)&app_key=\(apiKey)&field=label&field=image&field=uri&random=false") else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            print(url)

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }

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
                    print(jsonString)
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(EdamamResponse.self, from: data)
                    let matchingRecipes = response.hits.map { $0.recipe }.filter { $0.label == label }
                    fetchedRecipes.formUnion(matchingRecipes)
                } catch {
                    print("decoding failure")
                    completion(.failure(error))
                }
            }
            task.resume()
        }

        group.notify(queue: .main) {
            completion(.success(fetchedRecipes))
        }
    }

    
    struct EdamamResponse: Codable {
        let hits: [Hit]
    }
    
    struct Hit: Codable {
        let recipe: Recipe
    }
}

