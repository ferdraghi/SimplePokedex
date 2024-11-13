//
//  PokemonStat.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import Foundation

enum PokemonStat: String, Codable {
    case hp
    case attack
    case defense
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed
    case unknown

    var statURL: URL {
        PokemonStat.baseURL.appendingPathComponent(uri)
    }
    
    var sylizedName: String {
        switch self {
        case .hp: return "HP"
        case .attack: return "Attack"
        case .defense: return "Defense"
        case .specialAttack: return "Sp. Attack"
        case .specialDefense: return "Sp. Defense"
        case .speed: return "Speed"
        case .unknown: return "???"
        }
    }
}

extension PokemonStat {
    static var baseURL: URL {
        URL(string: "https://pokeapi.co/api/v2/stat")!
    }
    
    var uri: String {
        switch self {
        case .hp: return "1"
        case .attack: return "2"
        case .defense: return "3"
        case .specialAttack: return "4"
        case .specialDefense: return "5"
        case .speed: return "6"
        case .unknown: return "999"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let stat = try container.decode(String.self, forKey: .name)
        if let pokemonStat = PokemonStat(rawValue: stat) {
            self = pokemonStat
        } else {
            self = .unknown
            print("Tried to decode an unknown Pokemon Stat: \(try container.decode(String.self, forKey: .name))")
        }
    }
}

extension PokemonStat: Identifiable {
    var id: Int { Int(uri)! }
}
