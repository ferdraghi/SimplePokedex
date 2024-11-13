//
//  StasView.swift
//  Pokedex
//
//  Created by Fernando Draghi on 13/11/2024.
//

import SwiftUI
import Charts
import CoreData

struct StatsView: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Chart(pokemon.sortedStats) { stat in
            BarMark(
                x: .value("Value", stat.base),
                y: .value("Stat", stat.stylizedName)
            )
            .annotation(position: .trailing) {
                Text("\(stat.base)")
                    .padding(.top, -5)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .frame(height: 200)
        .padding([.leading, .bottom, .trailing])
        .foregroundColor(pokemon.statsColor)
        .chartXScale(domain: 0...pokemon.highestStat.base + 5)
    }
}

#Preview {
    StatsView()
        .environmentObject(SamplePokemon.samplePokemon)
}
