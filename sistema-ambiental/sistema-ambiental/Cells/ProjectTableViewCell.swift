//
//  ProjectTableViewCell.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 23/10/23.
//

import Foundation
import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        view.layer.cornerRadius = 11
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var folderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Nome"
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
        self.selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with project: Project) {
        self.titleLabel.text = project.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            self.folderImage.tintColor = .white
            self.bgView.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            self.titleLabel.textColor = .white
        } else {
            self.folderImage.tintColor = .systemBlue
            self.bgView.backgroundColor = .white
            self.titleLabel.textColor = .black
        }
        
        super.setSelected(selected, animated: animated)

    }
    
    func addSubviews() {
        self.contentView.addSubview(bgView)
        self.bgView.addSubview(folderImage)
        self.bgView.addSubview(titleLabel)


        NSLayoutConstraint.activate([
            
            bgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            bgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            bgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            bgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            
            folderImage.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 8),
            folderImage.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            folderImage.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            folderImage.widthAnchor.constraint(equalTo: folderImage.heightAnchor),
            folderImage.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.leadingAnchor.constraint(equalTo: folderImage.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.bgView.trailingAnchor, constant: -8)

        ])
    }
}

