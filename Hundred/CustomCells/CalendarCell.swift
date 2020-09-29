//
//  ProgressCell.swift
//  Hundred
//
//  Created by jc on 2020-08-05.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {
    var goalLabel = UILabel()
    var progressImageView = UIImageView()
    var progressTitleLabel = UILabel()
    var progressDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(progressImageView)
        addSubview(goalLabel)
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
                progressImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
                goalLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
                progressTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
            }
        } else {
            progressImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
            goalLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.80).isActive = true
            progressTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.80).isActive = true
        }
        goalLabel.text = progress.goal.title
        progressTitleLabel.text = progress.comment
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        progressDateLabel.text = dateFormatter.string(from: progress.date)
    }
    
    func configureUI() {
        progressImageView.layer.cornerRadius = 5
        progressImageView.clipsToBounds = true
        
        goalLabel.adjustsFontSizeToFitWidth = false
        goalLabel.lineBreakMode = .byTruncatingTail
        goalLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        goalLabel.textAlignment = .left
        
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
//        progressImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        progressImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        progressImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.leadingAnchor.constraint(equalTo: progressImageView.trailingAnchor, constant: 8).isActive = true
        goalLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        goalLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        goalLabel.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.40).isActive = true
//        goalLabel.trailingAnchor.constraint(equalTo: progressDateLabel.leadingAnchor, constant: -8).isActive = true

        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressTitleLabel.leadingAnchor.constraint(equalTo: progressImageView.trailingAnchor, constant: 8).isActive = true
        progressTitleLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
//        progressTitleLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
        progressTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

        progressDateLabel.translatesAutoresizingMaskIntoConstraints = false
        progressDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        progressDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        progressDateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        progressDateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
//        progressDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
}
