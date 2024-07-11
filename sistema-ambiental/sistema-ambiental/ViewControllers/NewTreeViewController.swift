//
//  NewTreeViewController.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 07/11/2023.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class NewTreeViewController: UIViewController {
    
    var viewModel: NewTreeViewModel
    private let disposeBag = DisposeBag()
    var imagePicker = UIImagePickerController()
    var tree = Tree()
    var treeImage: UIImage?
    
    var locationManager: CLLocationManager?

    init(viewModel: NewTreeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var spinnerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.layer.zPosition = 1
        return view
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isMultipleTouchEnabled = true
        scrollView.contentMode = .scaleToFill
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameLabelView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var dapView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var latitudeView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var longitudeView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var heightView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var fusteView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var observationsView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()
    
    private lazy var treeImageView: TreeImageView = {
        var view = TreeImageView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didAddPhoto)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addTreeButtonView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Nome"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var selectSpeciesButton: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor(cgColor: CGColor(srgbRed: 0.96, green: 0.96, blue: 0.96, alpha: 1)).cgColor
        return view
    }()

    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Selecione a espécie"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var speciesChevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(cgColor: CGColor(srgbRed: 0.38, green: 0.81, blue: 0.88, alpha: 1))
        return imageView
    }()

    private lazy var dapTextField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: 70"
        textField.textAlignment = .natural
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var dapTitle: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "DAP (em centímetros)"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: -23.33445"
        textField.textAlignment = .natural
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .numbersAndPunctuation
        return textField
    }()
    
    private lazy var latitudeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.addTarget(self, action: #selector(latitudeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var latitudeTitleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Latitude"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: -45.23212"
        textField.textAlignment = .natural
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .numbersAndPunctuation
        return textField
    }()
    
    private lazy var longitudeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(longitudeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var longitudeTitleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Longitude"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var heightTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 2
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: 1,5"
        textField.textAlignment = .natural
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var heightTitleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Altura (em metros)"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var fusteTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 3
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: 0,5"
        textField.textAlignment = .natural
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var fusteTitleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Fuste (em metros)"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var observationsTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 4
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: Possui marcação "
        textField.textAlignment = .natural
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        return textField
    }()

    private lazy var observationsTitleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Observações"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var addTreeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.38, green: 0.8, blue: 0.88, alpha: 1))
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitle("Adicionar", for: .normal)
        button.setTitleColor(UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1)), for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(addTree), for: .touchUpInside)
        return button
    }()

    func setupView() {
        view.addSubview(scrollView)
        view.addSubview(spinnerView)
        spinnerView.addSubview(spinner)
        scrollView.addSubview(footerView)
        footerView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabelView)
        stackView.addArrangedSubview(dapView)
        stackView.addArrangedSubview(latitudeView)
        stackView.addArrangedSubview(longitudeView)
        stackView.addArrangedSubview(heightView)
        stackView.addArrangedSubview(fusteView)
        stackView.addArrangedSubview(observationsView)
        stackView.addArrangedSubview(treeImageView)
        stackView.addArrangedSubview(addTreeButtonView)
        nameLabelView.addSubview(nameLabel)
        nameLabelView.addSubview(selectSpeciesButton)
        selectSpeciesButton.addSubview(speciesLabel)
        selectSpeciesButton.addSubview(speciesChevronImage)
        dapView.addSubview(dapTextField)
        dapView.addSubview(dapTitle)
        latitudeView.addSubview(latitudeTextField)
        latitudeView.addSubview(latitudeTitleLabel)
        latitudeView.addSubview(latitudeButton)
        longitudeView.addSubview(longitudeTextField)
        longitudeView.addSubview(longitudeTitleLabel)
        longitudeView.addSubview(longitudeButton)
        heightView.addSubview(heightTextField)
        heightView.addSubview(heightTitleLabel)
        fusteView.addSubview(fusteTextField)
        fusteView.addSubview(fusteTitleLabel)
        observationsView.addSubview(observationsTextField)
        observationsView.addSubview(observationsTitleLabel)
        addTreeButtonView.addSubview(addTreeButton)
        
        NSLayoutConstraint.activate([
            
            spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            speciesChevronImage.trailingAnchor.constraint(equalTo: selectSpeciesButton.trailingAnchor, constant: -8),
            speciesChevronImage.centerYAnchor.constraint(equalTo: selectSpeciesButton.centerYAnchor),
            speciesChevronImage.widthAnchor.constraint(equalTo: speciesChevronImage.heightAnchor),
            speciesChevronImage.heightAnchor.constraint(equalToConstant: 22),
            
            selectSpeciesButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            selectSpeciesButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            selectSpeciesButton.centerXAnchor.constraint(equalTo: nameLabelView.centerXAnchor),
            selectSpeciesButton.centerYAnchor.constraint(equalTo: nameLabelView.centerYAnchor),
            selectSpeciesButton.centerYAnchor.constraint(equalTo: nameLabelView.centerYAnchor),
            selectSpeciesButton.centerYAnchor.constraint(equalTo: nameLabelView.centerYAnchor),
            selectSpeciesButton.trailingAnchor.constraint(equalTo: nameLabelView.trailingAnchor, constant: -32),
            selectSpeciesButton.heightAnchor.constraint(equalToConstant: 56),
            
            speciesLabel.leadingAnchor.constraint(equalTo: selectSpeciesButton.leadingAnchor, constant: 16),
            speciesLabel.centerYAnchor.constraint(equalTo: selectSpeciesButton.centerYAnchor),
            
            nameLabelView.heightAnchor.constraint(equalToConstant: 108),
            nameLabel.topAnchor.constraint(equalTo: nameLabelView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: selectSpeciesButton.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: nameLabelView.leadingAnchor, constant: 32),

            dapTextField.topAnchor.constraint(equalTo: dapTitle.bottomAnchor, constant: 8),
            dapTextField.leadingAnchor.constraint(equalTo: dapTitle.leadingAnchor),
            dapTextField.centerXAnchor.constraint(equalTo: dapView.centerXAnchor),
            dapTextField.centerYAnchor.constraint(equalTo: dapView.centerYAnchor),
            dapTextField.trailingAnchor.constraint(equalTo: dapView.trailingAnchor, constant: -32),
            dapTextField.heightAnchor.constraint(equalToConstant: 56),
            
            dapView.heightAnchor.constraint(equalToConstant: 108),
            
            dapTitle.trailingAnchor.constraint(equalTo: dapTextField.trailingAnchor),
            dapTitle.leadingAnchor.constraint(equalTo: dapView.leadingAnchor, constant: 32),
            dapTitle.topAnchor.constraint(equalTo: dapView.topAnchor),

            latitudeTextField.topAnchor.constraint(equalTo: latitudeTitleLabel.bottomAnchor, constant: 8),
            latitudeTextField.leadingAnchor.constraint(equalTo: latitudeTitleLabel.leadingAnchor),
            latitudeTextField.trailingAnchor.constraint(equalTo: latitudeView.trailingAnchor, constant: -32),
            latitudeTextField.heightAnchor.constraint(equalToConstant: 56),
        
            latitudeButton.centerYAnchor.constraint(equalTo: latitudeTextField.centerYAnchor),
            latitudeButton.widthAnchor.constraint(equalToConstant: 24),
            latitudeButton.heightAnchor.constraint(equalTo: latitudeButton.widthAnchor),
            latitudeButton.trailingAnchor.constraint(equalTo: latitudeTextField.trailingAnchor, constant: -8),
            
            latitudeTitleLabel.trailingAnchor.constraint(equalTo: latitudeTextField.trailingAnchor),
            latitudeTitleLabel.leadingAnchor.constraint(equalTo: latitudeView.leadingAnchor, constant: 32),
            latitudeTitleLabel.topAnchor.constraint(equalTo: latitudeView.topAnchor),

            latitudeView.heightAnchor.constraint(equalToConstant: 108),
            
            longitudeTextField.topAnchor.constraint(equalTo: longitudeTitleLabel.bottomAnchor, constant: 8),
            longitudeTextField.leadingAnchor.constraint(equalTo: longitudeTitleLabel.leadingAnchor),
            longitudeTextField.trailingAnchor.constraint(equalTo: longitudeView.trailingAnchor, constant: -32),
            longitudeTextField.heightAnchor.constraint(equalToConstant: 56),
            
            longitudeButton.centerYAnchor.constraint(equalTo: longitudeTextField.centerYAnchor),
            longitudeButton.widthAnchor.constraint(equalToConstant: 24),
            longitudeButton.heightAnchor.constraint(equalTo: longitudeButton.widthAnchor),
            longitudeButton.trailingAnchor.constraint(equalTo: longitudeTextField.trailingAnchor, constant: -8),
            
            longitudeTitleLabel.trailingAnchor.constraint(equalTo: longitudeTextField.trailingAnchor),
            longitudeTitleLabel.leadingAnchor.constraint(equalTo: longitudeView.leadingAnchor, constant: 32),
            longitudeTitleLabel.topAnchor.constraint(equalTo: longitudeView.topAnchor),

            longitudeView.heightAnchor.constraint(equalToConstant: 108),
            
            heightTextField.topAnchor.constraint(equalTo: heightTitleLabel.bottomAnchor, constant: 8),
            heightTextField.leadingAnchor.constraint(equalTo: heightTitleLabel.leadingAnchor),
            heightTextField.centerXAnchor.constraint(equalTo: heightView.centerXAnchor),
            heightTextField.centerYAnchor.constraint(equalTo: heightView.centerYAnchor),
            heightTextField.trailingAnchor.constraint(equalTo: heightView.trailingAnchor, constant: -32),
            heightTextField.heightAnchor.constraint(equalToConstant: 56),
            
            heightTitleLabel.trailingAnchor.constraint(equalTo: heightTextField.trailingAnchor),
            heightTitleLabel.leadingAnchor.constraint(equalTo: heightView.leadingAnchor, constant: 32),
            heightTitleLabel.topAnchor.constraint(equalTo: heightView.topAnchor),

            heightView.heightAnchor.constraint(equalToConstant: 108),
            
            fusteTextField.topAnchor.constraint(equalTo: fusteTitleLabel.bottomAnchor, constant: 8),
            fusteTextField.leadingAnchor.constraint(equalTo: fusteTitleLabel.leadingAnchor),
            fusteTextField.centerXAnchor.constraint(equalTo: fusteView.centerXAnchor),
            fusteTextField.centerYAnchor.constraint(equalTo: fusteView.centerYAnchor),
            fusteTextField.trailingAnchor.constraint(equalTo: fusteView.trailingAnchor, constant: -32),
            fusteTextField.heightAnchor.constraint(equalToConstant: 56),
            
            fusteTitleLabel.trailingAnchor.constraint(equalTo: fusteTextField.trailingAnchor),
            fusteTitleLabel.leadingAnchor.constraint(equalTo: fusteView.leadingAnchor, constant: 32),
            fusteTitleLabel.topAnchor.constraint(equalTo: fusteView.topAnchor),

            fusteView.heightAnchor.constraint(equalToConstant: 108),
            
            observationsTextField.topAnchor.constraint(equalTo: observationsTitleLabel.bottomAnchor, constant: 8),
            observationsTextField.leadingAnchor.constraint(equalTo: observationsTitleLabel.leadingAnchor),
            observationsTextField.trailingAnchor.constraint(equalTo: addTreeButton.trailingAnchor),
            observationsTextField.centerXAnchor.constraint(equalTo: observationsView.centerXAnchor),
            observationsTextField.centerYAnchor.constraint(equalTo: observationsView.centerYAnchor),
            observationsTextField.trailingAnchor.constraint(equalTo: observationsView.trailingAnchor, constant: -32),
            observationsTextField.heightAnchor.constraint(equalToConstant: 56),
            
            observationsView.heightAnchor.constraint(equalToConstant: 108),
            
            observationsTitleLabel.trailingAnchor.constraint(equalTo: observationsTextField.trailingAnchor),
            observationsTitleLabel.leadingAnchor.constraint(equalTo: observationsView.leadingAnchor, constant: 32),
            observationsTitleLabel.topAnchor.constraint(equalTo: observationsView.topAnchor),

            treeImageView.heightAnchor.constraint(equalToConstant: 240),
            
            addTreeButton.leadingAnchor.constraint(equalTo: observationsTextField.leadingAnchor),
            addTreeButton.centerXAnchor.constraint(equalTo: addTreeButtonView.centerXAnchor),
            addTreeButton.centerYAnchor.constraint(equalTo: addTreeButtonView.centerYAnchor),
            addTreeButton.heightAnchor.constraint(equalToConstant: 56),
            addTreeButton.trailingAnchor.constraint(equalTo: addTreeButtonView.trailingAnchor, constant: -32),

            addTreeButtonView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            
            footerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            footerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            footerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            footerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
        
        spinnerView.isHidden = true
        view.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 1, alpha: 1))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTextFields()
        self.changeAddButtonTreeState(active: false)
        self.setupView()
        self.setupBinds()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        view.addGestureRecognizer(tap)
        selectSpeciesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectSpecies)))
        
        self.title = "Adicionar árvore"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager?.stopUpdatingLocation()
    }
    
    func setupBinds() {
        self.viewModel.treeCreatedDriver.asObservable().subscribe(onNext: { [weak self] isTreeCreated in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                self.spinnerView.isHidden = true
                self.spinner.stopAnimating()
                
                if isTreeCreated {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    @objc func didAddPhoto(_ sender: UIView) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tirar Foto", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Selecionar Foto", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func longitudeButtonTapped() {
        locationManager?.startUpdatingLocation()
    }
    
    @objc func latitudeButtonTapped() {
        locationManager?.startUpdatingLocation()
    }
    
    /// Open the camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    /// Choose image from camera roll
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc func selectSpecies() {
        let speciesViewController = TreesSpeciesViewController()
        speciesViewController.setupDelegate(delegate: self)
        self.navigationController?.pushViewController(speciesViewController, animated: true)
    }

    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset.bottom = keyboardFrame.size.height + 20
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func setupUI() {
        self.selectSpeciesButton.layer.cornerRadius = 6
        self.selectSpeciesButton.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.selectSpeciesButton.layer.borderWidth = 1
    }
    
    func setupTextFields() {
        self.dapTextField.delegate = self
        self.heightTextField.delegate = self
        self.fusteTextField.delegate = self
        self.observationsTextField.delegate = self
        self.longitudeTextField.delegate = self
        self.latitudeTextField.delegate = self
    }
    
    func changeAddButtonTreeState(active: Bool) {
        self.addTreeButton.backgroundColor = active ? .systemBlue : .lightGray
        self.addTreeButton.setTitleColor(active ? .white : .darkGray, for: .normal)
        self.addTreeButton.isUserInteractionEnabled = active
    }
    
    @objc func addTree() {
        self.spinner.startAnimating()
        self.spinnerView.isHidden = false
        self.viewModel.createTree(with: self.tree, image: treeImage)
    }
}

extension NewTreeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var errorMessage = ""
        let isTextFieldEmpty = textField.text?.isEmpty ?? true
        
        switch textField {
        case dapTextField:
            if (textField.text?.doubleValue()) != nil {
                self.changeAddButtonTreeState(active: true)
                self.tree.dap = textField.text ?? ""
            } else if !isTextFieldEmpty {
                errorMessage = "O DAP deve ser um valor numérico"
                self.changeAddButtonTreeState(active: false)
            }
        case heightTextField:
            if (textField.text?.doubleValue()) != nil {
                self.changeAddButtonTreeState(active: true)
                self.tree.height = textField.text ?? ""
            } else if !isTextFieldEmpty {
                errorMessage = "A altura deve ser um valor numérico"
                self.changeAddButtonTreeState(active: false)
            }
        case fusteTextField:
            if (textField.text?.doubleValue()) != nil {
                self.changeAddButtonTreeState(active: true)
                self.tree.fuste = textField.text ?? ""
            } else if !isTextFieldEmpty {
                errorMessage = "O fuste deve ser um valor numérico"
                self.changeAddButtonTreeState(active: false)
            }
        case latitudeTextField:
            if (textField.text?.doubleValue(localeID: "en_US")) != nil {
                self.changeAddButtonTreeState(active: true)
                self.tree.latitude = textField.text ?? ""
            } else if !isTextFieldEmpty {
                errorMessage = "A latitude deve ser um valor numérico"
                self.changeAddButtonTreeState(active: false)
            }
        case longitudeTextField:
            if (textField.text?.doubleValue(localeID: "en_US")) != nil {
                self.changeAddButtonTreeState(active: true)
                self.tree.longitude = textField.text ?? ""
            } else if !isTextFieldEmpty {
                errorMessage = "A longitude deve ser um valor numérico"
                self.changeAddButtonTreeState(active: false)
            }
        case observationsTextField:
            self.tree.observations = textField.text ?? ""
        default:
            return
        }
        
        if !errorMessage.isEmpty {
            let alert = UIAlertController(title: "Dados informados não são válidos", message: errorMessage, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Entendi", style: .cancel, handler: { [weak alert] _ in
                alert?.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.stackView.viewWithTag(textField.tag + 1) as? UITextField {
             nextField.becomeFirstResponder()
          } else {
             textField.resignFirstResponder()
          }
          return false
    }
}

extension NewTreeViewController: TreesSpeciesSelectionDelegate {
    func didSelectSpecies(species: TreeSpecies) {
        self.speciesLabel.text = species.getFullName()
        self.tree.popularName = species.popularName
        self.tree.scientificName = species.scientificName
        self.changeAddButtonTreeState(active: true)
    }
}

extension NewTreeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            self.treeImageView.setImage(editedImage)
            self.treeImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.treeImageView.setImage(originalImage)
            self.treeImage = originalImage
        }
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewTreeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        self.latitudeTextField.text = latitude
        self.longitudeTextField.text = longitude
        self.tree.latitude = latitude
        self.tree.longitude = longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
