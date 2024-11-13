//
//  Persistence.swift
//  Pokedex
//
//  Created by Fernando Draghi on 11/11/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let samplePokemon = Pokemon(context: viewContext)
        
        samplePokemon.id = 1
        samplePokemon.name = "Bulbasaur"
        samplePokemon.baseExp = 64
        samplePokemon.height = 7
        samplePokemon.weight = 69
        samplePokemon.favorite = false
        
        let attackStat = Stat(context: viewContext)
        let hpStat = Stat(context: viewContext)
        let defenseStat = Stat(context: viewContext)
        let spAttackStat = Stat(context: viewContext)
        let spDefenseStat = Stat(context: viewContext)
        let speedStat = Stat(context: viewContext)

        hpStat.name = PokemonStat.hp.rawValue
        hpStat.base = 45
        hpStat.effort = 0
        
        attackStat.name = PokemonStat.attack.rawValue
        attackStat.base = 49
        attackStat.effort = 0

        defenseStat.name = PokemonStat.defense.rawValue
        defenseStat.base = 49
        defenseStat.effort = 0
        
        spAttackStat.name = PokemonStat.specialAttack.rawValue
        spAttackStat.base = 65
        spAttackStat.effort = 1
        
        spDefenseStat.name = PokemonStat.specialDefense.rawValue
        spDefenseStat.base = 65
        spDefenseStat.effort = 0
        
        speedStat.name = PokemonStat.speed.rawValue
        speedStat.base = 45
        speedStat.effort = 0
        
        samplePokemon.addToStats([attackStat, hpStat, defenseStat, spAttackStat, spDefenseStat, speedStat])
        
        let sprites = Sprites(context: viewContext)
        sprites.back = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!
        sprites.backShiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png")!
        sprites.front = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
        sprites.frontShiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")!
        
        samplePokemon.sprites = sprites
        
        samplePokemon.types = [PokemonType.grass.rawValue, PokemonType.poison.rawValue]
        
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Pokedex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.fernandod.Pokedex-Group")!.appending(path: "Pokedex.sqlite")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("sarasa")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
