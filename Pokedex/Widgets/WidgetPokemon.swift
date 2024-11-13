//
//  WidgetPokemon.swift
//  Pokedex
//
//  Created by Fernando Draghi on 13/11/2024.
//

import SwiftUI

enum WidgetSize {
    case small, medium, large
}

struct WidgetPokemon: View {
    @EnvironmentObject var pokemon: Pokemon
    let size: WidgetSize

    var body: some View {
        ZStack {
            Color(pokemon.types![0].capitalized)
            
            switch size {
            case .small:
                FetchedImage(url: pokemon.sprites?.front)
            case .medium:
                HStack {
                    FetchedImage(url: pokemon.sprites?.front)
                    VStack (alignment: .leading) {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                            .minimumScaleFactor(0.5)
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing, 30)
                }
            case .large:
                FetchedImage(url: pokemon.sprites?.front)
                VStack {
                    HStack {
                        Text(pokemon.name!.capitalized)
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WidgetPokemon(size: .large)
        .environmentObject(SamplePokemon.samplePokemon)
}
