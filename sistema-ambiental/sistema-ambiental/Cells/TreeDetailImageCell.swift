//
//  TreeDetailImageCell.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 11/12/23.
//

import Foundation
import UIKit
import Kingfisher

class TreeDetailImageCell: UITableViewCell {

    let treeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(treeImageView)
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            treeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            treeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            treeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            treeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            self.treeImageView.kf.setImage(with: url)
        }
    }
}
