//
//  TreeImageView.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 28/11/23.
//

import Foundation
import UIKit

class TreeImageView: UIView {
    
    private lazy var treeImageStrokeView: UIView = {
        let strokeView = UIView()
        strokeView.layer.cornerRadius = 5
        strokeView.layer.borderWidth = 0.5
        strokeView.layer.borderColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.29).cgColor
        strokeView.translatesAutoresizingMaskIntoConstraints = false
        strokeView.isUserInteractionEnabled = false
        return strokeView
    }()
    
    fileprivate lazy var placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    fileprivate lazy var treeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 5
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.addSubview(treeImageStrokeView)
        self.addSubview(placeHolderImageView)
        self.addSubview(treeImage)
        
        NSLayoutConstraint.activate([
            self.treeImageStrokeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.treeImageStrokeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.treeImageStrokeView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.treeImageStrokeView.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.placeHolderImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            self.placeHolderImageView.heightAnchor.constraint(equalTo: self.placeHolderImageView.widthAnchor),
            self.placeHolderImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.placeHolderImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            self.treeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.treeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.treeImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.treeImage.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    func setImage(_ image: UIImage) {
        self.placeHolderImageView.isHidden = true
        self.treeImageStrokeView.isHidden = false
        self.treeImage.isHidden = false
        self.treeImage.image = image
    }
    
}
