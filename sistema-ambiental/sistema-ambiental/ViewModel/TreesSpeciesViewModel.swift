//
//  TreesSpeciesViewModel.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 07/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

class TreesSpeciesViewModel {
    
    private let treesSpeciesRelay = BehaviorRelay<[TreeSpecies]>(value: [])
    var service = TreeSpeciesService()
    
    var treesSpeciesDriver: Driver<[TreeSpecies]> {
        return treesSpeciesRelay.asDriver(onErrorJustReturn: [])
    }
    
    func getAllSpecies() {
        self.service.getAllSpecies { [weak self] (species, error) in
            if let species = species {
                self?.treesSpeciesRelay.accept(species)
            }
        }
    }
    
    func searchSpecies(with searchText: String) {
        self.service.searchSpecies(searchText: searchText) { [weak self] (species, error) in
            if let species = species {
                self?.treesSpeciesRelay.accept(species)
            }
        }
    }
    
    func addSpecie(withPopularName popularName: String, withSciName sciName: String) {
        let specie = TreeSpecies(popularName: popularName, scientificName: sciName)
        self.service.addSpecie(with: specie) { [weak self] error in
            if error == nil {
                self?.getAllSpecies()
            }
            
        }
    }
}
