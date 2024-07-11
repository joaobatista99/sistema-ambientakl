//
//  TreeDetailInfoCell.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 11/12/23.
//

import Foundation
import UIKit

class TreeDetailInfoCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        self.selectionStyle = .none

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.infoLabel.leadingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 12),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(title: String, info: String) {
        titleLabel.text = title
        infoLabel.text = info
    }
}
