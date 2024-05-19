//
//  Recipe.swift
//  Recipe_Chefs_iOS
//
//

import Foundation

struct Hit: Decodable {
    let recipe: Recipe
}


class RecipeModel: Decodable {
    var hits: [Hit]
}


class Recipe : Decodable, Identifiable {
    var label : String
    var image : String
    var ingredientLines: [String]
    
    var id : String {
        return UUID().uuidString
    }
}
