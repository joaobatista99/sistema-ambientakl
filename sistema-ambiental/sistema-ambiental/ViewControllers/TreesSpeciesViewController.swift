//
//  TreesSpeciesViewController.swift
//  sistema-ambiental
//
// Created by João Victor Batista on 07/11/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol TreesSpeciesSelectionDelegate: AnyObject {
    func didSelectSpecies(species: TreeSpecies)
}

class TreesSpeciesViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.alwaysBounceVertical = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    fileprivate lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem.menuButton(self, action: #selector(addSpecies), imageName: "plus")
        return button
    }()
    
    func setupView() {
        self.title = "Espécies"
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        ])
        
        view.backgroundColor = .systemBackground
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = TreesSpeciesViewModel()
    private let disposeBag = DisposeBag()
    private var species: [TreeSpecies] = []
    weak var delegate: TreesSpeciesSelectionDelegate?
    
    @objc func refreshSpecies() {
        self.viewModel.getAllSpecies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Pesquise por espécies"
        searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        
        
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(TreesSpeciesTableViewCell.self, forCellReuseIdentifier: String(describing: TreesSpeciesTableViewCell.self))
        
        self.navigationItem.rightBarButtonItems = [addBarButton]
        
        setupBinds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getAllSpecies()
    }
    
    @objc func addSpecies() {
        let alertController = UIAlertController(title: "Adicionar espécie", message: "Preencha com os dados que deseja adicionar", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nome popular"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Nome científico"
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        // Add "Adicionar" button with .default style
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { _ in
            // Retrieve text from text fields
            if let popName = alertController.textFields?.first?.text,
               let sciName = alertController.textFields?.last?.text {
                
                // Use textField1Text and textField2Text as needed
                self.viewModel.addSpecie(withPopularName: popName, withSciName: sciName)
            }
        }
        
        // Add buttons to the alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func setupBinds() {
        self.viewModel.treesSpeciesDriver.asObservable().subscribe(onNext: { [weak self] species in
            guard let self = self else {return}
            self.species = species
            self.tableView.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    func setupDelegate(delegate: TreesSpeciesSelectionDelegate) {
        self.delegate = delegate
    }
}

extension TreesSpeciesViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = self.searchController.searchBar.text {
            
            if searchText.isEmpty {
                self.refreshSpecies()
            } else {
                self.viewModel.searchSpecies(with: searchText)
            }
        }
    }
}

extension TreesSpeciesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreesSpeciesTableViewCell", for: indexPath) as! TreesSpeciesTableViewCell
        let species = self.species[indexPath.row]
        cell.setup(with: species.getFullName())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let species = self.species[indexPath.row]
        self.delegate?.didSelectSpecies(species: species)
        self.navigationController?.popViewController(animated: true)
    }
}
