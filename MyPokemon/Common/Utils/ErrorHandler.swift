//
//  ErrorHandler.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import Foundation

enum URLError: LocalizedError {
    
    case urlNotFound
    case invalidResponse
    case addressUnreachable
    
    var errorDescription: String {
        switch self {
        case .urlNotFound: return "failed get url"
        case .invalidResponse: return "failed to get data your request."
        case .addressUnreachable: return "the url is unreachable."
        }
    }
    
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    case duplicateData
    
    public var errorDescription: String {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .requestFailed: return "Your request failed."
        case .duplicateData: return "you can't catch the same pokemon"
        }
    }
}
