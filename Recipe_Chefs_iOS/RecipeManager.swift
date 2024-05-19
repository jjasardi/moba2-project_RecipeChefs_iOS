//
//  RecipeManager.swift
//  Recipe_Chefs_iOS
//
//

import Foundation

class RecipeManager {
    static let shared = RecipeManager()
    
    private init() {}
    
    func loadDataFromAPI(for searchQuery: String) async throws -> [Recipe] {
        
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"],
              let appId = ProcessInfo.processInfo.environment["APP_ID"]
        else {
            throw NSError(domain: "MissingCredentials", code: -1, userInfo: nil)
        }
        
        guard searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) != nil
        else {
            throw NSError(domain: "InvalidQuery", code: -1, userInfo: nil)
        }
        
        guard var urlComponents = URLComponents(string: "https://api.edamam.com/api/recipes/v2")
        else {
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "q", value: searchQuery),
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: apiKey)
        ]
        guard let url = urlComponents.url else {
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        
        let decoder = JSONDecoder()
        let recipeModel = try decoder.decode(RecipeModel.self, from: data)
        
        let recipes = recipeModel.hits.map { $0.recipe }
        
        return recipes
    }
    
}
