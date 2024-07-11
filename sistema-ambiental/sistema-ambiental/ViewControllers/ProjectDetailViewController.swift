//
//  ProjectDetailViewController.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 18/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

enum ProjectDetailViewControllerState {
    case empty
    case project
    case emptyProject
    case map
}

class TreeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var tree: Tree
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, tree: Tree) {
        self.coordinate = coordinate
        self.tree = tree
        self.title = tree.popularName
        self.subtitle = "10/02/22"
    }
}


class ProjectDetailViewController: UIViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Pesquise por árvores"
        searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        return searchController
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isHidden = true
        mapView.mapType = .satelliteFlyover
        return mapView
    }()
    
    fileprivate lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem.menuButton(self, action: #selector(addTree), imageName: "plus")
        return button
    }()

    fileprivate lazy var mapBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem.menuButton(self, action: #selector(showMap), imageName: "map")
        return button
    }()

    fileprivate lazy var exportBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem.menuButton(self, action: #selector(addTree), imageName: "square.and.arrow.up")
        return button
    }()
    
    fileprivate lazy var emptyStateLabel: UILabel = {
        var label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Selecione o projeto"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    var viewState: ProjectDetailViewControllerState = .empty {
        didSet {
            switch viewState {
            case .empty:
                self.handleEmptyState()
            case .project:
                self.handleProjectState()
            case .emptyProject:
                self.handleEmptyProjectState()
            case .map:
                self.handleMapState()
            }
        }
    }
    
    let viewModel = ProjectDetailViewModel()
    var trees: [Tree] = []
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.setupSubviews()
        self.viewState = .empty
        mapView.delegate = self
        collectionView.register(TreeDetailCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TreeDetailCollectionViewCell.self))
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
                
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.rightBarButtonItems = [addBarButton, mapBarButton, exportBarButton]
        
        self.setupBinds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getAllTrees()
    }
    
    func setupBinds() {
        self.viewModel.treesDriver.asObservable().subscribe(onNext: { [weak self] trees in
            guard let self = self else {return}
            if trees.isEmpty {
                self.viewState = .emptyProject
            } else {
                if self.viewState == .empty || self.viewState == .emptyProject {
                    self.viewState = .project
                }
            }
            self.trees = trees
            self.collectionView.reloadData()
            self.setupMap()
        }).disposed(by: self.disposeBag)
    }
    
    func handleEmptyState() {
        self.title = ""
        self.navigationController?.isNavigationBarHidden = true
        self.emptyStateLabel.isHidden = false
        self.collectionView.isHidden = true
        self.mapView.isHidden = true
        self.emptyStateLabel.text = "Selecione o projeto"
    }
    
    func handleMapState() {
        self.title = viewModel.project?.title
        self.emptyStateLabel.isHidden = true
        self.collectionView.isHidden = true
        self.mapView.isHidden = false
    }
    
    func handleProjectState() {
        self.title = viewModel.project?.title
        self.navigationController?.isNavigationBarHidden = false
        self.emptyStateLabel.isHidden = true
        self.collectionView.isHidden = false
        self.mapView.isHidden = true
    }
    
    func handleEmptyProjectState() {
        self.emptyStateLabel.isHidden = false
        self.emptyStateLabel.text = "Nenhuma árvore no projeto"
        self.collectionView.isHidden = true
    }
    
    private func setupSubviews() {
        self.view.addSubview(collectionView)
        self.view.addSubview(emptyStateLabel)
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.emptyStateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyStateLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }
    
    @objc func addTree() {
        if let project = viewModel.project {
            let newTreeViewModel = NewTreeViewModel(projectId: project.id)
            self.navigationController?.pushViewController(NewTreeViewController(viewModel: newTreeViewModel), animated: true)
        }
    }
    
    @objc func showMap() {
        if viewState != .map {
            self.viewState = .map
        } else {
            self.viewState = .project
        }
    }
    
    func setupMap() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        for tree in trees {
            self.addPinToMap(withTree: tree)
        }
    }
    
    func addPinToMap(withTree tree: Tree) {
        guard let latitudeDouble = Double(tree.latitude), let longitudeDouble = Double(tree.longitude) else {
            print("Invalid latitude or longitude format")
            return
        }
        
        let location = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
        let annotation = TreeAnnotation(coordinate: location, tree: tree)
        mapView.addAnnotation(annotation)
        
        if mapView.annotations.count == 1 {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func showProject() {
        self.viewState = .project
        self.viewModel.getAllTrees()
    }
    
    func showEmptyState() {
        self.viewState = .empty
    }
}

extension ProjectDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TreeDetailCollectionViewCell.self),
                                                         for: indexPath) as? TreeDetailCollectionViewCell {
            let tree = trees[indexPath.row]
            cell.setup(with: tree)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTree = trees[indexPath.row]
        if let projectId = viewModel.project?.id {
            let treeDetailViewModel = TreeDetailViewModel(tree: selectedTree, projectId: projectId)
            let treeDetailController = TreeDetailViewController(viewModel: treeDetailViewModel)
            self.navigationController?.pushViewController(treeDetailController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3) - 3*3, height: 180)
    }
}

extension ProjectDetailViewController: UISearchResultsUpdating, UISearchControllerDelegate  {

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = self.searchController.searchBar.text {
            if searchText.isEmpty {
                self.viewModel.getAllTrees()
            } else {
                self.viewModel.searchTrees(with: searchText)
            }
        }
    }
    
}

extension ProjectDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? TreeAnnotation {
            let identifier = "CustomPin"
            var annotationView: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? TreeAnnotation {
                if let projectId = viewModel.project?.id {
                    let treeDetailViewModel = TreeDetailViewModel(tree: annotation.tree, projectId: projectId)
                    let treeDetailController = TreeDetailViewController(viewModel: treeDetailViewModel)
                    self.navigationController?.pushViewController(treeDetailController, animated: true)
                }
            }
        }
    }
    
}
