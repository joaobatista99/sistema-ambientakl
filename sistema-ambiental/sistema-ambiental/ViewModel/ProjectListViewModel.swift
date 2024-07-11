//
//  ProjectListViewModel.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 20/11/23.
//

import Foundation
import RxSwift
import RxCocoa

class ProjectListViewModel {
    
    private let projectsRelay = BehaviorRelay<[Project]>(value: [])
    var service = ProjectService()
    
    var projectsDriver: Driver<[Project]> {
        return projectsRelay.asDriver(onErrorJustReturn: [])
    }
    
    func getAllProjects() {
        self.service.getAllProjects { [weak self] (projects, error) in
            if let projects = projects {
                self?.projectsRelay.accept(projects)
            }
        }
    }
    
    func createProject(with project: Project) {
        self.service.createProject(with: project) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func searchProjects(with searchText: String) {
        self.service.searchProject(searchText: searchText) { [weak self] (projects, error) in
            if let projects = projects {
                self?.projectsRelay.accept(projects)
            }
        }
    }
}
