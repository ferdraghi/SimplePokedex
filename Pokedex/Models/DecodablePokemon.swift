//
//  DecodablePokemon.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import Foundation

struct DecodablePokemon: Decodable {
    let id: Int
    let name: String
    let baseExp: Int
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let stats: [DecodableStat]
    let sprites: DecodableSprites
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExp = "base_experience"
        case height
        case weight
        case types
        case stats
        case sprites
    }
}
