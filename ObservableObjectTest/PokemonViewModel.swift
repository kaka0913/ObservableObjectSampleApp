//
//  PokemonViewModel.swift
//  ObservableObjectTest
//
//  Created by 株丹優一郎 on 2024/12/21.
//


import SwiftUI

class PokemonViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func toggleFavorite(for pokemonId: Int) {
        if let index = pokemons.firstIndex(where: { $0.id == pokemonId }) {
            var pokemon = pokemons[index]
            pokemon.isFavorite.toggle()
            pokemons[index] = pokemon
        }
    }
    
    func fetchPokemons() {
        isLoading = true
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("🔴 Error: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else { return }
                do {
                    let response = try JSONDecoder().decode(PokemonResponse.self, from: data)
                    self?.pokemons = response.results
                    print("😃Fetched \(response.results.count) Pokemon")
                    print("🧐Result \(response.results)")
                } catch {
                    self?.errorMessage = error.localizedDescription
                    print("😄Decode error: \(error)")
                }
            }
        }.resume()
    }
} 
