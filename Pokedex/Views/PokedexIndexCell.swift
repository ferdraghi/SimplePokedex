//
//  PokedexIndexCell.swift
//  Pokedex
//
//  Created by Fernando Draghi on 13/11/2024.
//

import SwiftUI

struct PokedexIndexCell: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CachedAsyncImage(url: pokemon.sprites!.front) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .shadow(color: pokemon.statsColor, radius: 20, x: 0, y: 0)
            Text(pokemon.name!.capitalized)
                .font(.caption)
                .foregroundStyle(.white)
                .shadow(color: .gray, radius: 1, x: 1, y: 1)
                .padding(3)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial.opacity(0.5))
            
            Image(systemName: "star.fill")
                .font(.caption2)
                .padding([.bottom], 80)
                .padding([.leading], 70)
                .foregroundStyle(.yellow)
                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                .opacity(pokemon.favorite ? 1 : 0)
        }
        .frame(width: 100, height: 100)
        .background(pokemon.statsColor.opacity(0.5))
        .clipShape(.rect(cornerRadius: 25))
        .shadow(color: .gray, radius: 1, x: 0, y: 0)
    }
}

#Preview {
    PokedexIndexCell()
        .environmentObject(SamplePokemon.samplePokemon)
}
