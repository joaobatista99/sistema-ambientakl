//
//  ProjectDetailViewModel.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 30/11/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ProjectDetailViewModel {
    
    var project: Project?
    var treeService = TreeService()

    private let treesRelay = BehaviorRelay<[Tree]>(value: [])

    var treesDriver: Driver<[Tree]> {
        return treesRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(project: Project? = nil) {
        self.project = project
    }
    
    func setProject(_ project: Project) {
        self.project = project
    }
    
    func getAllTrees() {
        if let project {
            treeService.getAllTrees(on: project.id) { [weak self] (trees, error) in
                if let trees = trees {
                    self?.treesRelay.accept(trees)
                }
            }
        }
    }
    
    func searchTrees(with searchText: String) {
        if let project {
            self.treeService.searchTree(on: project.id,
                                        searchText: searchText) { [weak self] (trees, error) in
                if let trees = trees {
                    self?.treesRelay.accept(trees)
                }
            }
        }
        
    }
}
