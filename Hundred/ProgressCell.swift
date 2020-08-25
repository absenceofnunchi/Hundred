//
//  ProgressCell.swift
//  Hundred
//
//  Created by jc on 2020-08-05.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {
    var progressImageView = UIImageView()
    var progressTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        progressImageView = UIImageView()
        addSubview(progressImageView)
        addSubview(progressTitleLabel)
        
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func set(progress: Progress) {
        if let image = progress.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(image)
            if let data = try? Data(contentsOf: imagePath) {
                progressImageView.image = UIImage(data: data)
                progressImageView.widthAnchor.constraint(lessThanOrEqualTo: progressImageView.heightAnchor, multiplier: 16/9).isActive = true
            }
        } else {
            progressImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }
        progressTitleLabel.text = progress.comment
    }
    
    func configureImageView() {
        progressImageView.layer.cornerRadius = 5
        progressImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        progressTitleLabel.numberOfLines = 0
        progressTitleLabel.adjustsFontSizeToFitWidth = false
        progressTitleLabel.lineBreakMode = .byTruncatingTail
        progressTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        progressTitleLabel.textAlignment = .left
    }
    
    func setImageConstraints() {
        progressImageView.translatesAutoresizingMaskIntoConstraints = false
        progressImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        progressImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    func setTitleLabelConstraints() {
        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressTitleLabel.leadingAnchor.constraint(equalTo: progressImageView.trailingAnchor, constant: 5).isActive = true
        progressTitleLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        progressTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        progressTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
}


