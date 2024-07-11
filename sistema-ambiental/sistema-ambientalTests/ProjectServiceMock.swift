//
//  ProjectServiceMock.swift
//  sistema-ambientalTests
//
//  Created by João Victor Batista on 10/07/24.
//

import Foundation
@testable import sistema_ambiental

class MockProjectService: ProjectService {
    
    var projects: [Project] = []
    var shouldReturnError = false
    
    override func getAllProjects(completionHandler: @escaping (_ projects: [Project]?, _ error: Error?) -> Void) {
        if shouldReturnError {
            completionHandler(nil, NSError(domain: "Test", code: -1, userInfo: nil))
        } else {
            completionHandler(projects, nil)
        }
    }
    
    override func searchProject(searchText: String, completionHandler: @escaping (_ projects: [Project]?, _ error: Error?) -> Void) {
        if shouldReturnError {
            completionHandler(nil, NSError(domain: "Test", code: -1, userInfo: nil))
        } else {
            let filteredProjects = projects.filter { $0.title.contains(searchText) }
            completionHandler(filteredProjects, nil)
        }
    }
}
