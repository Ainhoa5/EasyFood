import Foundation

class EdamamManager {
    static let shared = EdamamManager()
    private var apiKey = ""
    private var apiId = ""
    private let baseURL = "https://api.edamam.com/api/recipes/v2?type=public"

    private init() {
        setApiCredentials()
    }

    private func setApiCredentials(){
        if let url = Bundle.main.url(forResource: "Edamam", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String] {
            self.apiId = config["API_ID"] ?? ""
            self.apiKey = config["API_KEY"] ?? ""
            
        }
    }
    private func createQueryString(from appState: AppState) -> String {
        let mealTypeQueryString = appState.selectedMealTypes.map { "&mealType=\($0)" }.joined()
        let dishTypeQueryString = appState.selectedDishTypes.map {
            "&dishType=" + $0.replacingOccurrences(of: " ", with: "%20")
        }.joined()
        let dietTypeQueryString = appState.selectedDietTypes.map { "&diet=\($0)" }.joined()
        let healthTypeQueryString = appState.selectedHealthTypes.map { "&health=\($0)" }.joined()
        let ingredientsString = appState.ingredients.filter { $0.isSaved }.map { $0.name }.joined(separator: "%2C%20")

        return "\(baseURL)&q=\(ingredientsString)&app_id=\(apiId)&app_key=\(apiKey)&field=label&field=image&field=images&field=source&field=url&field=yield&field=dietLabels&field=healthLabels&field=cautions&field=ingredientLines&field=totalTime&field=cuisineType&field=mealType&field=dishType&random=false\(dishTypeQueryString)\(mealTypeQueryString)\(dietTypeQueryString)\(healthTypeQueryString)"
    }
}

// MARK: - Request Handling
extension EdamamManager {
    func fetchRecipesFromApi(_ appState: AppState, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        guard let url = URL(string: createQueryString(from: appState)) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(EdamamResponse.self, from: data)
                completion(.success(response.hits.map { $0.recipe }))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - Edamam Response Structs
extension EdamamManager {
    struct EdamamResponse: Codable {
        let hits: [Hit]
    }

    struct Hit: Codable {
        let recipe: Recipe
    }
}
