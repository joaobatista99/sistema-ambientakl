//
//  NewTreeViewModel.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 28/11/23.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class NewTreeViewModel {
    
    var projectId: String
    private let treeCreatedRelay = BehaviorRelay<Bool>(value: false)
    
    var treeCreatedDriver: Driver<Bool> {
        return treeCreatedRelay.asDriver(onErrorJustReturn: false)
    }
    
    init(projectId: String) {
        self.projectId = projectId
    }
    
    var service = TreeService()
    
    func createTree(with tree: Tree, image: UIImage?) {
        self.service.createTree(on: projectId, with: tree, image: image) { [weak self] (success, error) in
            self?.treeCreatedRelay.accept(success)
        }
    }
    
}
