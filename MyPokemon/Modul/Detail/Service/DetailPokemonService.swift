//
//  DetailPokemonService.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import Foundation
import Alamofire

protocol DetailPokemonServiceProtocol {
    func getDetailPokemon(url: String, completion: @escaping (Result<DetailPokemonModel, Error>) -> Void)
}

class DetailPokemonService: DetailPokemonServiceProtocol {
    func getDetailPokemon(url: String, completion: @escaping (Result<DetailPokemonModel, Error>) -> Void) {
        if let url = URL(string: url) {
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: DetailPokemonModel.self) { result in
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
