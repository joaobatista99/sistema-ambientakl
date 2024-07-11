//
//  TreesSpeciesService.swift
//  sistema-ambiental
//  Created by João Victor Batista on 07/11/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class TreeSpeciesService {

    let speciesRef = Firestore.firestore().collection("Species")

    func getAllSpecies(completionHandler: @escaping(_ projects: [TreeSpecies]?, _ error: Error?) -> Void) {

        var decodedSpecies = [TreeSpecies]()

        speciesRef.getDocuments { (species, error) in

            if let error = error {
                completionHandler(nil, error)
            } else if let species = species {
                for tree in species.documents {
                    let result = Result {
                        try tree.data(as: TreeSpecies.self)
                    }

                    switch result {
                    case .success(let species):
                        decodedSpecies.append(species)
                    case .failure(let error):
                        print("Error decoding project: \(error)")
                    }
                }
                completionHandler(decodedSpecies, nil)
            }
        }
    }

    func searchSpecies(searchText: String, completionHandler: @escaping(_ projects: [TreeSpecies]?, _ error: Error?) -> Void) {

        var decodedSpecies = [TreeSpecies]()

        speciesRef.whereField("popularName", isGreaterThanOrEqualTo: searchText)
            .whereField("popularName", isLessThanOrEqualTo: searchText+"\u{f8ff}")
            .getDocuments() { (species, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let species = species {
                    for tree in species.documents {
                        let result = Result {
                            try tree.data(as: TreeSpecies.self)
                        }

                        switch result {
                        case .success(let species):
                            decodedSpecies.append(species)
                        case .failure(let error):
                            print("Error decoding project: \(error)")
                        }
                    }
                    completionHandler(decodedSpecies, nil)
                }
        }
    }
    
    func addSpecie(with specie: TreeSpecies, completionHandler: @escaping(_ error: Error?) -> Void) {
        do {
            try speciesRef.addDocument(from: specie)
            completionHandler(nil)
        } catch let error {
            completionHandler(error)
            print("Error writing project to Firestore: \(error)")
        }
    }

}
