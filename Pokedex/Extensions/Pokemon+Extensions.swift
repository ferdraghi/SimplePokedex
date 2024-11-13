//
//  Pokemon+Extensions.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import SwiftUI
import CoreData

extension Pokemon {
    var background: String {
        let typeString = types!.first!

        var pokemonType = PokemonType(rawValue: typeString)!
        
        if pokemonType == .normal && types!.count > 1 {
            pokemonType = PokemonType(rawValue: types![1])!
        }
        
        return pokemonType.background
    }
    
    var sortedStats: [Stat] {
        guard let stats = stats as? Set<Stat> else { return [] }
        
        return stats.sorted { s1, s2 in
            let stat1 = PokemonStat(rawValue: s1.name!)
            let stat2 = PokemonStat(rawValue: s2.name!)
            
            return stat1!.id < stat2!.id
        }
    }
    
    var highestStat: Stat {
        sortedStats.max { $0.base < $1.base }!
    }
    
    var statsColor: Color {
        Color(types!.first!.capitalized)
    }
}
