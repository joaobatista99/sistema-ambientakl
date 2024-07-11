//
//  TreeDetailDeleteButtonCell.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 11/12/23.
//

import Foundation
import UIKit

class TreeDetailDeleteButtonCell: UITableViewCell {
    
    let deleteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.textAlignment = .center
        label.text = "Apagar árvore"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(deleteLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            deleteLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
