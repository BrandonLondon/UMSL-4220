import UIKit
import ObjectLibrary

protocol ListModelDelegate: class {
    func willDownload()
    func didDownload(error: ServiceCallError?, reloadData: Bool)
    func show(_ pokémon: Pokémon)
}

final class ListModel {
    private let pokédexPersistence: PokédexPersistence
    private let pokémonPersistence: PokémonPersistence
    private let serviceClient: PokéAPIServiceClient
    private weak var delegate: ListModelDelegate?
    private(set) var pokédex: Pokédex!
    
    init(pokédexPersistence: PokédexPersistence, pokémonPersistence: PokémonPersistence, serviceClient: PokéAPIServiceClient, delegate: ListModelDelegate) {
        self.pokédexPersistence = pokédexPersistence
        self.pokémonPersistence = pokémonPersistence
        self.serviceClient = serviceClient
        self.delegate = delegate
    }
    
    func loadPokédex() {
        let pokédex = pokédexPersistence.pokédex
        if pokédex == nil {
            self.delegate?.willDownload()
            serviceClient.getPokédex(completion: {result in
                switch result {
                case .success(let pokedex):
                    self.pokédex = pokedex
                    self.pokédexPersistence.save(pokedex)
                    self.delegate?.didDownload(error: nil, reloadData: true)
                case .failure(let error):
                    self.delegate?.didDownload(error: error, reloadData: false)
                }
            })
        } else {
            self.pokédex = pokédex
        }
    }
    
    func loadPokemon(index: Int) {
        let pokémonEntry = self.pokédex.entries[index]
        let pokemon = pokémonPersistence.pokémon(named: pokémonEntry.name)
        if pokemon == nil {
            self.delegate?.willDownload()
            serviceClient.getPokémon(fromUrl: pokémonEntry.url, completion: { result in
                switch result {
                case .success(let pokemon):
                    self.pokémonPersistence.save(pokemon)
                    self.delegate?.didDownload(error: nil, reloadData: true)
                    self.delegate?.show(pokemon)
                case .failure(let error):
                    self.delegate?.didDownload(error: error, reloadData: false)
                }
            })
        } else {
            delegate?.show(pokemon!)
        }
    }
}
