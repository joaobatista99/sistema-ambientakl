//
//  TreeService.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 28/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class TreeService {
    
    let projectsRef = Firestore.firestore().collection("Projects")
    
    func createTree(on projectId: String,
                    with tree: Tree,
                    image: UIImage?,
                    completionHandler: @escaping(_ success: Bool, _ error: Error?) -> Void) {
        
        let treesRef = projectsRef.document(projectId).collection("Trees")

        if let image {
            var treeCopy = tree
            FirebaseStorageManager.shared.uploadImageToFirebaseStorage(image: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let downloadURL):
                    do {
                        treeCopy.setImageURL(downloadURL.absoluteString)
                        let treeRef = treesRef.document(treeCopy.id)
                        try treeRef.setData(from: treeCopy)
                        completionHandler(true, nil)
                    } catch let error {
                        completionHandler(false, error)
                        print("Error writing project to Firestore: \(error)")
                    }
                case .failure(let error):
                    print("Error uploading image: \(error.localizedDescription)")
                    completionHandler(false, error)
                }
            }
        } else {
            do {
                let treeRef = treesRef.document(tree.id)
                try treeRef.setData(from: tree)
                completionHandler(true, nil)
            } catch let error {
                print("Error writing project to Firestore: \(error)")
                completionHandler(false, error)
            }
        }
    }
    
    func getAllTrees(on projectId: String, completionHandler: @escaping(_ projects: [Tree]?, _ error: Error?) -> Void)  {
        
        let treesRef = projectsRef.document(projectId).collection("Trees")
        var decodedTrees = [Tree]()
        
        treesRef.getDocuments(completion: { (treesSnapshot, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let treesSnapshot = treesSnapshot {
                for treeDocument in treesSnapshot.documents {
                    let result = Result {
                        try treeDocument.data(as: Tree.self)
                    }
                    
                    switch result {
                    case .success(let decodedTree):
                        decodedTrees.append(decodedTree)
                    case .failure(let error):
                        print("Error decoding project: \(error)")
                    }
                }
                completionHandler(decodedTrees, error)
            }
        })
    }
    
    func deleteTree(on projectId: String, with treeId: String, completionHandler: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let treeRef = db.collection("Projects").document(projectId).collection("Trees").document(treeId)
        
        treeRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
                completionHandler(error)
            } else {
                print("Document successfully deleted")
                completionHandler(nil)
            }
        }
    }
                       
    func searchTree(on projectId: String, searchText: String, completionHandler: @escaping(_ projects: [Tree]?, _ error: Error?) -> Void) {
        
        let treesRef = projectsRef.document(projectId).collection("Trees")
        var decodedTrees = [Tree]()
        
        treesRef.whereField("popularName", isGreaterThanOrEqualTo: searchText)
            .whereField("popularName", isLessThanOrEqualTo: searchText+"\u{f8ff}")
            .getDocuments() { (trees, err) in
                if let err = err {
                    print("Error getting trees: \(err)")
                } else if let trees {
                    for tree in trees.documents {
                        let result = Result {
                            try tree.data(as: Tree.self)
                        }
                        
                        switch result {
                        case .success(let decodedTree):
                            decodedTrees.append(decodedTree)
                        case .failure(let error):
                            print("Error decoding trees: \(error)")
                        }
                    }
                    completionHandler(decodedTrees, nil)
                }
            }
    }
}
