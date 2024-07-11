//
//  Project.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 20/11/23.
//

import Foundation

struct Project: Codable, Equatable {
    var title: String
    var creationDate: Date? = Date()
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case creationDate = "creationDate"
        case id = "id"
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.title == rhs.title && lhs.id == rhs.id
    }
}
