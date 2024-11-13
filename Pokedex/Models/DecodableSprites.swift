//
//  DecodableSprites.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import Foundation

struct DecodableSprites: Decodable {
    let back: URL
    let front: URL
    let backShiny: URL
    let frontShiny: URL
    let backFemale: URL?
    let frontFemale: URL?
    let backShinyFemale: URL?
    let frontShinyFemale: URL?
    
    enum CodingKeys: String, CodingKey {
        case back = "back_default"
        case front = "front_default"
        case backShiny = "back_shiny"
        case frontShiny = "front_shiny"
        case backFemale = "back_female"
        case frontFemale = "front_female"
        case backShinyFemale = "back_shiny_female"
        case frontShinyFemale = "front_shiny_female"
    }
}
