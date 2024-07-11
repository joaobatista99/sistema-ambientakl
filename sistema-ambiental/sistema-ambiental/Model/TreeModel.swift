//
//  Tree.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 07/11/2023.
//

import Foundation

struct Tree: Codable {
    var id: String
    var dap: String
    var height: String
    var fuste: String
    var observations: String
    var latitude: String
    var longitude: String
    var popularName: String
    var scientificName: String
    var image: String?
    
    public init() {
        self.id = UUID().uuidString
        dap = ""
        height = ""
        fuste = ""
        observations = "--"
        latitude = ""
        longitude = ""
        popularName = ""
        scientificName = ""
        image = ""
    }
    
    mutating func setImageURL(_ downloadURL: String) {
        self.image = downloadURL
    }
    
    func getAttributes() -> [String] {
        return ["\(popularName) (\(scientificName))", "\(dap)", "\(height)", "\(fuste)", "\(latitude)", "\(longitude)", "\(observations)"]
    }
    
    func getAttributesTitles() -> [String] {
        return ["Espécie", "DAP", "Altura", "Fuste", "Latitude", "Longitude", "Observações"]
    }
    
}
