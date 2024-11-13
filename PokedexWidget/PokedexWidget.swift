//
//  PokedexWidget.swift
//  PokedexWidget
//
//  Created by Fernando Draghi on 13/11/2024.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    var randomPokemon: Pokemon {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        var results = [Pokemon]()
        
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching pokemon from CoreData: \(error)")
        }
        
        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        
        return SamplePokemon.samplePokemon
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), pokemon: SamplePokemon.samplePokemon)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let pokemon: Pokemon
}

struct PokedexWidgetEntryView : View {
    @Environment(\.widgetFamily) var size
    var entry: Provider.Entry

    var body: some View {
        switch size {
        case .systemSmall:
            WidgetPokemon(size: .small)
                .environmentObject(entry.pokemon)
        case .systemMedium:
            WidgetPokemon(size: .medium)
                .environmentObject(entry.pokemon)
        case .systemLarge:
            WidgetPokemon(size: .large)
                .environmentObject(entry.pokemon)
        default:
            WidgetPokemon(size: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

struct PokedexWidget: Widget {
    let kind: String = "PokedexWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PokedexWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .ignoresSafeArea()
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    PokedexWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}

#Preview(as: .systemMedium) {
    PokedexWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}

#Preview(as: .systemLarge) {
    PokedexWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}
