//
//  PokemonListViewModel.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import Foundation

class PokemonListViewModel {
    let service: PokemonListService
    
    public var pokemonList: [PokemonResult]?
    public var nextURL: String?
    public var lastIndexPath: [IndexPath]?
    
    public var didSuccess: (() -> Void)?
    public var didFailed: ((String) -> Void)?
    
    init(service: PokemonListService) {
        self.service = service
    }
    
    func getData() {
        let param: [String: Any] = [
            "limit": 20,
            "offset": 0
        ]
        service.getPokemonList(endpoint: .list, method: .get, parameters: param) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                strongSelf.pokemonList = data.results ?? []
                strongSelf.nextURL = data.next
                strongSelf.didSuccess?()
            case .failure(let failure):
                strongSelf.didFailed?(failure.errorDescription)
            }
        }
    }
    
    func loadMoreData() {
        guard let nextURL = nextURL, !nextURL.isEmpty else { return }
        service.getLoadMorePokemon(nextURL: nextURL) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                let startIndex = (self?.pokemonList?.count ?? 0) - 1
                let endIndex = startIndex + (data.results?.count ?? 0)
                let tempIndexPaths = Array(startIndex..<endIndex).compactMap { return IndexPath(row: $0, section: 0) }
                strongSelf.lastIndexPath = tempIndexPaths
                strongSelf.pokemonList?.append(contentsOf: data.results ?? [])
                strongSelf.nextURL = data.next
                strongSelf.didSuccess?()
            case .failure(let error):
                strongSelf.didFailed?(error.errorDescription)
            }
        }
    }
    
}
