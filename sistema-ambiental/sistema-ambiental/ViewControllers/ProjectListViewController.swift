//
//  ProjectListViewController.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 18/10/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProjectSelectionDelegate: AnyObject {
    func didSelectProject(_ project: Project)
    func didDeselectProject() 
}

class ProjectListViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.scrollsToTop = false
        tableView.separatorStyle = .none
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        
        tableView.backgroundView = bgView
        return tableView
    }()
    
    fileprivate lazy var noProjectsView: UIView = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Nenhum projeto encontrado."
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     label.centerXAnchor.constraint(equalTo:  view.centerXAnchor),
                                     label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)])
        
        return view
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Procurar projetos"
        searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        return searchController
    }()
    
    private let viewModel = ProjectListViewModel()
    private let disposeBag = DisposeBag()
    private var projects: [Project] = []
    weak var delegate: ProjectSelectionDelegate?

    override func viewDidLoad() {
        self.setupSubviews()
        self.title = "Projetos"
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: String(describing: ProjectTableViewCell.self))
        definesPresentationContext = true

        self.tableView.tableHeaderView = searchController.searchBar
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add,
                                                                                    target: self,
                                                                                    action: #selector(createProject)),
                                                                    animated: true)

        self.view.backgroundColor = .white
        self.setupBinds()
        self.setupRefreshControl()
        self.viewModel.getAllProjects()
    }
    
    private func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refreshProjects), for: .valueChanged)
    }
    
    @objc func refreshProjects() {
        self.viewModel.getAllProjects()
    }
    
    func setupBinds() {
        self.viewModel.projectsDriver.asObservable().subscribe(onNext: { [weak self] projects in
            guard let self = self else {return}
            
            if projects.isEmpty {
                self.noProjectsView.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.noProjectsView.isHidden = true
                self.tableView.isHidden = false
            }
            
            self.projects = projects
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }).disposed(by: self.disposeBag)
    }

    private func setupSubviews() {
        
        self.view.addSubview(tableView)
        self.view.addSubview(noProjectsView)
        self.noProjectsView.isHidden = true

        NSLayoutConstraint.activate([
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            self.noProjectsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.noProjectsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.noProjectsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.noProjectsView.topAnchor.constraint(equalTo: self.view.topAnchor),
       ])
    }
    
    @objc func createProject() {
        
        let alert = UIAlertController(title: "Novo Projeto", message: "Insira o nome do novo projeto", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Nome do projeto"
            textField.autocapitalizationType = .sentences
        }

        alert.addAction(UIAlertAction(title: "Criar projeto", style: .default, handler: { [weak alert] _ in
            if let textFieldProject = alert?.textFields?.first, let projectTitle = textFieldProject.text, !projectTitle.isEmpty {
                let newProject = Project(title: projectTitle, id: UUID().uuidString)
                self.viewModel.createProject(with: newProject)
                self.refreshProjects()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { [weak alert] _ in
            alert?.dismiss(animated: true)
        }))


        self.present(alert, animated: true, completion: nil)
    }
}

extension ProjectListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectTableViewCell.self),
                                                    for: indexPath) as? ProjectTableViewCell {
            let project = self.projects[indexPath.row]
            cell.setup(with: project)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectProject(projects[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.delegate?.didDeselectProject()
    }
}

extension ProjectListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = self.searchController.searchBar.text {
            
            if searchText.isEmpty {
                self.refreshProjects()
            } else {
                self.viewModel.searchProjects(with: searchText)
            }
        }
    }
}
