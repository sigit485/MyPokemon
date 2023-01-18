//
//  FavoritePokemonViewModel.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import Foundation

class FavoritePokemonViewModel {
    
    public var pokemonList: [FavoritePokemonModel]?
    
    public var didSuccess: (() -> Void)?
    public var didFailed: ((String) -> Void)?
    
    func getPokemonLocale() {
        PokemonProvider.shared.getPokemonsLocale { result in
            switch result {
            case .success(let data):
                self.pokemonList = data
                self.didSuccess?()
            case .failure(let error):
                self.didFailed?(error.errorDescription)
            }
        }
    }
    
    func deletePokemon(_ idPokemon: Int, completion: @escaping (() -> Void)) {
        PokemonProvider.shared.deletePokemon(idPokemon) {
            completion()
        }
    }
    
    
}
