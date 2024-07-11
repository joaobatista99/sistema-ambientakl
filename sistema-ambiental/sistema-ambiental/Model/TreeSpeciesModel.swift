//
//  TreeSpeciesMode
//  sistema-ambiental
//
//  Created by João Victor Batista on 07/11/2023.
//

import Foundation

struct TreeSpecies: Codable {
    var popularName: String
    var scientificName: String
    
    func getFullName() -> String {
        return popularName + " (\(scientificName))"
    }
}
