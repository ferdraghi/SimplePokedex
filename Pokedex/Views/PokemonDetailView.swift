//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import SwiftUI
import CoreData

struct PokemonDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                AsyncImage(url: showShiny ? pokemon.sprites!.frontShiny : pokemon.sprites!.front) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id:\.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                Spacer()
                
                Button {
                    withAnimation {
                        pokemon.favorite.toggle()
                        do {
                            try viewContext.save()
                        } catch {
                            fatalError("Error trying to save Core Data: \(error)")
                        }
                    }
                } label: {
                    if pokemon.favorite {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            }
            .padding()
            
            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            
            StatsView()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShiny.toggle()
                } label : {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonDetailView()
        .environmentObject(SamplePokemon.samplePokemon)
}

