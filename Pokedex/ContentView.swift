//
//  ContentView.swift
//  Pokedex
//
//  Created by Fernando Draghi on 11/11/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var pokemonViewModel = PokemonViewModel(controller: FetchController())
    @State var filterByFavorites = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>
    
    var body: some View {
        switch pokemonViewModel.status {
        case .success:
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(filterByFavorites ? favorites : pokedex, id: \.id) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokedexIndexCell()
                                    .environmentObject(pokemon)
                            }
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetailView()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Label("Filter by favorites", systemImage: filterByFavorites ? "star.fill" : "star")
                        }
                        .font(.title)
                        .foregroundStyle(.yellow)
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
