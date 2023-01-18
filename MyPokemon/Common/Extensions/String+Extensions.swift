//
//  String+Extensions.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import Foundation

extension BidirectionalCollection where Element: StringProtocol {
    var sentence: String {
        count <= 2 ? joined(separator: " and ") : dropLast().joined(separator: ", ") + ", and " + last!
    }
}
