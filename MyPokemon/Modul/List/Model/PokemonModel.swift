//
//  PokemonModel.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import Foundation

struct PokemonModel: Codable {
    let next: String?
    let previous: String?
    let results: [PokemonResult]?
}

struct PokemonResult: Codable {
    let name: String?
    let url: String?
}
