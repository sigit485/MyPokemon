//
//  DetailPokemonViewModel.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import Foundation

class DetailPokemonViewModel {
    
    private let service: DetailPokemonService
    private let detailURL: String
    public var detailData: DetailPokemonModel?
    
    public var didSuccess: (() -> Void)?
    public var didFailed: ((String) -> Void)?
    
    init(detailURL: String) {
        self.service = DetailPokemonService()
        self.detailURL = detailURL
    }
    
    var isAllowCatch: Bool {
        return Bool.random()
    }
    
    func fetchDetail() {
        guard !self.detailURL.isEmpty else { return }
        service.getDetailPokemon(url: self.detailURL) { result in
            switch result {
            case .success(let data):
                self.detailData = data
                self.didSuccess?()
            case .failure(let failure):
                self.didFailed?(failure.localizedDescription)
            }
        }
    }
    
    func catchNewPokemon(username: String, completion: @escaping (() -> Void)) {
        if let detailData = detailData {
            PokemonProvider.shared.insertNewPokemon(
                id: detailData.id ?? 0,
                username: username, name: detailData.name ?? "",
                image: detailData.sprites?.other?.home?.frontDefault ?? "") { result in
                    switch result {
                    case .success:
                        completion()
                    case .failure(let error):
                        self.didFailed?(error.errorDescription)
                    }
                }
        } else {
            self.didFailed?(DatabaseError.invalidInstance.errorDescription)
        }
    }
}
