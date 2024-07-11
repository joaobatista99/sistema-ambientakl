//
//  ProjectService.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 20/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ProjectService {
    
    let projectsRef = Firestore.firestore().collection("Projects")
    
    func getAllProjects(completionHandler: @escaping(_ projects: [Project]?, _ error: Error?) -> Void) {
        
        var decodedProjects = [Project]()
        
        projectsRef.getDocuments { (projectsSnapshot, error) in
            
            if let error = error {
                completionHandler(nil, error)
            } else if let projectsSnapshot = projectsSnapshot {
                for projectDocument in projectsSnapshot.documents {
                    let result = Result {
                        try projectDocument.data(as: Project.self)
                    }
                    
                    switch result {
                    case .success(let decodedProject):
                        decodedProjects.append(decodedProject)
                    case .failure(let error):
                        print("Error decoding project: \(error)")
                    }
                }
                completionHandler(decodedProjects, nil)
            }
        }
    }
        
    
    func createProject(with project: Project, completionHandler: @escaping (Error?) -> Void) {
        do {
            try projectsRef.document(project.id).setData(from: project)
            completionHandler(nil)
        } catch let error {
            print("Error writing project to Firestore: \(error)")
            completionHandler(error)
        }
    }
    
    func searchProject(searchText: String, completionHandler: @escaping(_ projects: [Project]?, _ error: Error?) -> Void) {
        
        var decodedProjects = [Project]()

        projectsRef.whereField("title", isGreaterThanOrEqualTo: searchText)
            .whereField("title", isLessThanOrEqualTo: searchText+"\u{f8ff}")
            .getDocuments() { (projects, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let projects = projects {
                    for project in projects.documents {
                        let result = Result {
                            try project.data(as: Project.self)
                        }
                        
                        switch result {
                        case .success(let decodedProject):
                            decodedProjects.append(decodedProject)
                        case .failure(let error):
                            print("Error decoding project: \(error)")
                        }
                    }
                    completionHandler(decodedProjects, nil)
                }
        }
    }
    
}
