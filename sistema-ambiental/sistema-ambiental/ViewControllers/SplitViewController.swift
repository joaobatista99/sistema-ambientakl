//
//  SplitViewController.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 20/11/23.
//

import Foundation
import UIKit

class SplitViewController: UISplitViewController {
   
    private var primaryViewController: ProjectListViewController?
    private var secondaryViewController: ProjectDetailViewController?
    private var secondaryNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        self.loadViewControllers()
    }
        
    private func loadViewControllers() {
        let listViewController = ProjectListViewController()
        self.primaryViewController = listViewController
        self.primaryViewController?.delegate = self
        
        let listNavController = UINavigationController(rootViewController: listViewController)

        let detailViewController = ProjectDetailViewController()
        self.secondaryViewController = detailViewController
        let detailNavController = UINavigationController(rootViewController: detailViewController)
        self.secondaryNavigationController = detailNavController
        
        self.viewControllers = [listNavController, detailNavController]
    }
}

extension SplitViewController: ProjectSelectionDelegate {
    func didSelectProject(_ project: Project) {
        
        if let secondaryViewController, self.isCollapsed {
            self.showDetailViewController(secondaryViewController, sender: self)
        }
        
        self.secondaryNavigationController?.popToRootViewController(animated: true)
        self.secondaryViewController?.viewModel.setProject(project)
        self.secondaryViewController?.showProject()
    }
    
    func didDeselectProject() {
        self.secondaryViewController?.showEmptyState()
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
