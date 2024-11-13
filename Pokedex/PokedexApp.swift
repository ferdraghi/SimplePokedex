//
//  PoKeDexApp.swift
//  Pokedex
//
//  Created by Fernando Draghi on 11/11/2024.
//

import SwiftUI

@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
