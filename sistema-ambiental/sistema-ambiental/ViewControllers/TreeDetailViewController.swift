//
//  TreeDetailViewController.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 11/12/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum TreeDetailsSection: Int {
    case image = 0
    case info = 1
    case button = 2
}

class TreeDetailViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    var viewModel: TreeDetailViewModel
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinds()
        self.title = viewModel.tree.popularName
    }
    
    func setupBinds() {
        self.viewModel.treeDeletedDriver.asObservable().subscribe(onNext: { [weak self] isTreeDeleted in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                if isTreeDeleted {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    init(viewModel: TreeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: "Deletar árvore", message: "Tem certeza quer deletar esta árvore?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Deletar", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.deleteTree()
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        self.present(alertController, animated: true)
    }
}

// MARK: - Extension for UITableView setup

extension TreeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        // Setup UITableView
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Register cells
        tableView.register(TreeDetailImageCell.self, forCellReuseIdentifier: String(describing: TreeDetailImageCell.self))
        tableView.register(TreeDetailInfoCell.self, forCellReuseIdentifier: String(describing: TreeDetailInfoCell.self))
        tableView.register(TreeDetailDeleteButtonCell.self, forCellReuseIdentifier: String(describing: TreeDetailDeleteButtonCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UITableView Delegate and DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case TreeDetailsSection.image.rawValue:
            return 300
        case TreeDetailsSection.info.rawValue:
            return UITableView.automaticDimension
        case TreeDetailsSection.button.rawValue:
            return 40
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TreeDetailsSection.image.rawValue:
            return 1
        case TreeDetailsSection.info.rawValue:
            return self.viewModel.tree.getAttributesTitles().count
        case TreeDetailsSection.button.rawValue:
            return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == TreeDetailsSection.info.rawValue || section == TreeDetailsSection.button.rawValue {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == TreeDetailsSection.button.rawValue {
            return 60
        } else if section == TreeDetailsSection.info.rawValue {
            return 40
        }
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TreeDetailsSection.image.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TreeDetailImageCell.self), for: indexPath) as? TreeDetailImageCell {
                cell.setup(imageUrl: viewModel.tree.image ?? "")
                return cell
            }
        case TreeDetailsSection.info.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TreeDetailInfoCell.self), for: indexPath) as? TreeDetailInfoCell {
                let titles = viewModel.tree.getAttributesTitles()
                let attributes = viewModel.tree.getAttributes()
                cell.setup(title: titles[indexPath.row], info: attributes[indexPath.row])
                return cell
            }
        case TreeDetailsSection.button.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TreeDetailDeleteButtonCell.self), for: indexPath) as? TreeDetailDeleteButtonCell {
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == TreeDetailsSection.button.rawValue {
            self.showDeleteAlert()
        }
    }
}
