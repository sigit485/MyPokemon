//
//  APIManager.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import Foundation

enum APIEndpoint {
    case list
    
    var url: String {
        switch self {
        case .list:
            return "/pokemon"
        }
    }
    
}

class APIManager {
    public static let baseURL = "https://pokeapi.co/api/v2"
    public static let baseImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home"
}
