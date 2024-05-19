//
//  ContentView.swift
//  Recipe_Chefs_iOS
//
//

import SwiftUI

struct ContentView: View {
    @State var search: String = ""
    @State private var recipes: [Recipe] = []
    @State private var isListViewActive = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var showNoMatchMessage = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $search)
                    .padding()
                
                Button(action: {
                    if isValidSearch(search) {
                        isLoading = true
                        showNoMatchMessage = false
                        Task {
                            do {
                                self.recipes = try await RecipeManager.shared.loadDataFromAPI(for: search)
                                search = ""
                                if self.recipes.isEmpty {
                                    showNoMatchMessage = true
                                } else {
                                    self.isListViewActive = true
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                            isLoading = false
                        }
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Search")
                }
                
                if isLoading {
                    ProgressView()
                } else {
                    NavigationLink(
                        destination: ListView(recipes: recipes),
                        isActive: $isListViewActive,
                        label: { EmptyView() }
                    )
                    .hidden()
                }
                
                if showNoMatchMessage {
                    Text("No matching recipes found.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .navigationTitle("Recipe Chefs")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Search"),
                    message: Text("Please enter a valid search term."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func isValidSearch(_ searchTerm: String) -> Bool {
        let trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedSearchTerm.isEmpty
    }
}
