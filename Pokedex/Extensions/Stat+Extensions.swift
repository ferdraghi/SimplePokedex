//
//  Stat+Extensions.swift
//  Pokedex
//
//  Created by Fernando Draghi on 13/11/2024.
//

import CoreData

extension Stat {
    var stylizedName: String {
        PokemonStat(rawValue: name!)!.sylizedName
    }
}
