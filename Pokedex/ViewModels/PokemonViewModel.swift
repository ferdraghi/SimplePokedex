//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller

        Task {
            await getPokemon()
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        
        do {
            guard var pokedex = try await controller.fetchPokemon(upTo: 151) else {
                print("using cached data")
                status = .success
                return
            }

            pokedex.sort { $0.id < $1.id }
            
            try pokedex.forEach { pokemon in
                let newEntry = Pokemon(context: PersistenceController.shared.container.viewContext)
                
                newEntry.id = Int16(pokemon.id)
                newEntry.name = pokemon.name
                newEntry.baseExp = Int32(pokemon.baseExp)
                newEntry.height = Int16(pokemon.height)
                newEntry.weight = Int16(pokemon.weight)
                newEntry.types = pokemon.types.map { $0.rawValue }
                
                pokemon.stats.forEach { stat in
                    let statEntry = Stat(context: PersistenceController.shared.container.viewContext)
                    
                    statEntry.base = Int16(stat.base)
                    statEntry.effort = Int16(stat.effort)
                    statEntry.name = stat.name
                    
                    newEntry.addToStats(statEntry)
                }
                
                let spritesEntry = Sprites(context: PersistenceController.shared.container.viewContext)
                spritesEntry.back = pokemon.sprites.back
                spritesEntry.front = pokemon.sprites.front
                spritesEntry.backShiny = pokemon.sprites.backShiny
                spritesEntry.frontShiny = pokemon.sprites.frontShiny
                spritesEntry.backFemale = pokemon.sprites.backFemale
                spritesEntry.frontFemale = pokemon.sprites.frontFemale
                spritesEntry.backShinyFemale = pokemon.sprites.backShinyFemale
                spritesEntry.frontShinyFemale = pokemon.sprites.frontShinyFemale
                
                newEntry.sprites = spritesEntry
                
                newEntry.favorite = false
                
                try PersistenceController.shared.container.viewContext.save()
            }
            
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
