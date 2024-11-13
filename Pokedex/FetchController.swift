//
//  FetchController.swift
//  Pokedex
//
//  Created by Fernando Draghi on 12/11/2024.
//

import CoreData

struct FetchController {
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    
    func fetchPokemon(upTo: Int) async throws -> [DecodablePokemon]? {
        guard !hasCachedData(upTo: upTo) else {
            return nil
        }
        
        let pokemonApiUrl = baseURL.appendingPathComponent("pokemon")
        var fetchURLComponents = URLComponents(url: pokemonApiUrl, resolvingAgainstBaseURL: true)
        fetchURLComponents?.queryItems = [URLQueryItem(name: "limit", value: "\(upTo)")]
        
        guard let fetchURL = fetchURLComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }
        
        guard let resultDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let pokemonList = resultDictionary["results"] as? [[String: String]]
        else {
            throw NetworkError.badData
        }
        
        var fetchedPokemon = [DecodablePokemon]()
        
        for result in pokemonList {
            guard let urlString = result["url"],
                  let url = URL(string: urlString)
            else {
                throw NetworkError.badData
            }

            let pokemon = try await fetchPokemon(from: url)
            fetchedPokemon.append(pokemon)
        }
        
        return fetchedPokemon
    }
}

extension FetchController {
    private func fetchPokemon(from url: URL) async throws -> DecodablePokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }
        
        let decodedPokemon = try JSONDecoder().decode(DecodablePokemon.self, from: data)
        
        return decodedPokemon
    }
    
    private func hasCachedData(upTo: Int) -> Bool {
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, upTo])
        
        do {
            let checkedPokemon = try context.fetch(fetchRequest)
            
            if checkedPokemon.count == 2 {
                return true
            }
        } catch {
            print("CoreData Fetch Failed: \(error)")
            return false
        }
        
        return false
    }
}
