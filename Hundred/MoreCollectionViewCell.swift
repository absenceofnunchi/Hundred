//
//  MoreCollectionViewCell.swift
//  Hundred
//
//  Created by J C on 2020-09-24.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class MoreCollectionViewCell: UICollectionViewCell {    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    var data: Menu? {
        didSet {
            guard let data = data else { return }
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .medium)
            let uiImage = UIImage(systemName: data.image, withConfiguration: largeConfig)
            imageView.image = uiImage
            imageView.tintColor = .darkGray
            titleLabel.text = data.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
    }
    
    func configureUI() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 7
        containerView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 7.0, opacity: 0.35, bgColor: UIColor.white)
        contentView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
    }
    
    func setConstraints() {
        containerView.pin(to: contentView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -15).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 15).isActive = true
    }
}
