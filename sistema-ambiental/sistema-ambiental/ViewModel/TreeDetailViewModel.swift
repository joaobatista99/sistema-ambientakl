//
//  TreeDetailViewModel.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 11/12/23.
//

import Foundation
import RxCocoa
import RxSwift

class TreeDetailViewModel {
    
    var tree: Tree
    var service = TreeService()
    var projectId: String

    private let treeDeletedRelay = BehaviorRelay<Bool>(value: false)
    
    var treeDeletedDriver: Driver<Bool> {
        return treeDeletedRelay.asDriver(onErrorJustReturn: false)
    }
    
    init(tree: Tree, projectId: String) {
        self.tree = tree
        self.projectId = projectId
    }
    
    func deleteTree() {
        self.service.deleteTree(on: projectId, with: tree.id) { [weak self] error in
            if let error {
                self?.treeDeletedRelay.accept(false)
            } else {
                self?.treeDeletedRelay.accept(true)
            }
        }
    }
}
