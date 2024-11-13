//
//  PokemonType.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import Foundation

enum PokemonType: String, CaseIterable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown

    var typeURL: URL {
        PokemonType.baseURL.appendingPathComponent(uri)
    }
}

extension PokemonType {
    static var baseURL: URL {
        URL(string: "https://pokeapi.co/api/v2/type")!
    }

    var uri: String {
        switch self {
        case .normal: return "1"
        case .fighting: return "2"
        case .flying: return "3"
        case .poison: return "4"
        case .ground: return "5"
        case .rock: return "6"
        case .bug: return "7"
        case .ghost: return "8"
        case .steel: return "9"
        case .fire: return "10"
        case .water: return "11"
        case .grass: return "12"
        case .electric: return "13"
        case .psychic: return "14"
        case .ice: return "15"
        case .dragon: return "16"
        case .dark: return "17"
        case .fairy: return "18"
        case .unknown: return "-1"
        }
    }
    
    var background: String {
        switch self {
        case .normal, .grass, .electric, .poison, .fairy:
            return "normalgrasselectricpoisonfairy"
        case .rock, .ground, .steel, .fighting, .ghost, .dark, .psychic: return
            "rockgroundsteelfightingghostdarkpsychic"
        case .fire, .dragon: return
            "firedragon"
        case .flying, .bug: return
            "flyingbug"
        case .water: 
            return "water"
        case .ice:
            return "ice"
        case .unknown: return ""
        }
    }
}

extension PokemonType: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    enum TypeCodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeContainer = try container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
        let type = try typeContainer.decode(String.self, forKey: .name)
        if let pokemonType = PokemonType(rawValue: type) {
            self = pokemonType
        } else {
            self = .unknown
            print("Tried to decode an unknown Pokemon Type: \(try typeContainer.decode(String.self, forKey: .name))")
        }
    }
}
