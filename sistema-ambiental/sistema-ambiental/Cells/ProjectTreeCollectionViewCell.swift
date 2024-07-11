//
//  ProjectTreeCollectionViewCell.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 07/11/2023.
//

import UIKit

class ProjectTreeCollectionViewCell: UICollectionViewCell {

    private lazy var name: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "Jaboticabeira"
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 1))
        return label
    }()

    private lazy var date: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "10/02/22"
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.33, alpha: 1))
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "treePlaceholderImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(name)
        contentView.addSubview(date)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            name.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            date.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

        ])
        contentView.backgroundColor = UIColor(cgColor: CGColor(genericGrayGamma2_2Gray: 0.0, alpha: 0.0))
    }


    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
