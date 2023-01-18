//
//  PokemonListService.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import Foundation
import Alamofire

protocol PokemonListServiceProtocol {
    func getPokemonList(endpoint: APIEndpoint, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Result<PokemonModel, URLError>) -> Void)
    func getLoadMorePokemon(nextURL: String, completion: @escaping (Result<PokemonModel, URLError>) -> Void)
}

class PokemonListService: PokemonListServiceProtocol {
    
    func getPokemonList(endpoint: APIEndpoint, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Result<PokemonModel, URLError>) -> Void) {
        if let url = URL(string: APIManager.baseURL + endpoint.url) {
            AF.request(url, method: method, parameters: parameters).responseDecodable(of: PokemonModel.self) { result in
                switch result.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(URLError.invalidResponse))
                }
            }
        } else {
            completion(.failure(URLError.urlNotFound))
        }
    }
    
    func getLoadMorePokemon(nextURL: String, completion: @escaping (Result<PokemonModel, URLError>) -> Void) {
        if let url = URL(string: nextURL) {
            AF.request(url, method: .get, parameters: nil).responseDecodable(of: PokemonModel.self) { result in
                switch result.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(URLError.invalidResponse))
                }
            }
        } else {
            completion(.failure(URLError.urlNotFound))
        }
    }
}
