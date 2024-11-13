//
//  DecodableStat.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import Foundation

struct DecodableStat: Codable {
    let base: Int
    let effort: Int
    let stat: PokemonStat

    enum CodingKeys: String, CodingKey {
        case base = "base_stat"
        case effort
        case stat
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base = try container.decode(Int.self, forKey: .base)
        self.effort = try container.decode(Int.self, forKey: .effort)
        stat = try container.decode(PokemonStat.self, forKey: .stat)
    }
}

extension DecodableStat {
    var name: String {
        stat.rawValue
    }
}
