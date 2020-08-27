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
    var progressDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(progressImageView)
        addSubview(progressTitleLabel)
        addSubview(progressDateLabel)
        
        configureUI()
        setConstraints()
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        progressDateLabel.text = dateFormatter.string(from: progress.date)
    }
    
    func configureUI() {
        progressImageView.layer.cornerRadius = 5
        progressImageView.clipsToBounds = true
        
        progressTitleLabel.numberOfLines = 0
        progressTitleLabel.adjustsFontSizeToFitWidth = false
        progressTitleLabel.lineBreakMode = .byTruncatingTail
        progressTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        progressTitleLabel.textAlignment = .left
        
        progressDateLabel.textAlignment = .right
        progressDateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        progressDateLabel.textColor = .lightGray
    }
    
    
    func setConstraints() {
        progressImageView.translatesAutoresizingMaskIntoConstraints = false
        progressImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        progressImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressTitleLabel.leadingAnchor.constraint(equalTo: progressImageView.trailingAnchor, constant: 8).isActive = true
        progressTitleLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        progressTitleLabel.trailingAnchor.constraint(equalTo: progressDateLabel.leadingAnchor, constant: -8).isActive = true
//        progressTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true
        
        progressDateLabel.translatesAutoresizingMaskIntoConstraints = false
        progressDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        progressDateLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        progressDateLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        progressDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
    
}


