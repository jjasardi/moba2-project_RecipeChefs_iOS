//
//  DetailView.swift
//  Recipe_Chefs_iOS
//
//

import SwiftUI

struct DetailView: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            Text(recipe.label)
                .font(.title)
            
            
            List(recipe.ingredientLines, id: \.self) { ingredient in
                Text(ingredient)
                    .padding(.vertical, 4) 
            }
            .listStyle(PlainListStyle())
            
            
            AsyncImage(url: URL(string: recipe.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .padding()
                case .failure:
                    Text("Failed to load image")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Recipe Detail")
    }
}



