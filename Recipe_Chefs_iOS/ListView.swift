//
//  ListView.swift
//  Recipe_Chefs_iOS
//
//

import SwiftUI

struct ListView: View {
    var recipes: [Recipe]
    
    var body: some View {
        List(recipes) { recipe in
            NavigationLink(
                destination: DetailView(recipe: recipe),
                label: {
                    HStack(spacing: 10) {
                        AsyncImage(url: URL(string: recipe.image)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 30, height: 30)
                        
                        Text(recipe.label)
                    }
                }
            )
        }
        .navigationTitle("Recipe List")
    }
}

