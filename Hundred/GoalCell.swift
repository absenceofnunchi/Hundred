//
//  GoalCell.swift
//  Hundred
//
//  Created by jc on 2020-08-24.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    var containerView = UIView()
    var upperContainer = UIView()
    var titleLabel = UILabel()
    var countLabel = UILabel()
    var detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        containerView.addSubview(upperContainer)
        upperContainer.addSubview(titleLabel)
        upperContainer.addSubview(countLabel)
        containerView.addSubview(detailLabel)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.selectionStyle = .none
//        containerView.layer.borderWidth = 0.2
//        containerView.layer.borderColor = UIColor.lightGray.cgColor
//        containerView.layer.cornerRadius = 13
        let borderColor = UIColor.gray
        containerView.layer.borderWidth = 1
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 7.0;
        containerView.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 4.0
        containerView.layer.backgroundColor = UIColor.white.cgColor
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .left
        
        countLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        countLabel.textColor = .lightGray
        countLabel.adjustsFontSizeToFitWidth = false
        countLabel.textAlignment = .right

        detailLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailLabel.numberOfLines = 0
        detailLabel.adjustsFontSizeToFitWidth = false
        detailLabel.lineBreakMode = .byTruncatingTail
        detailLabel.textAlignment = .left
    }
    
    func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        upperContainer.translatesAutoresizingMaskIntoConstraints = false
        upperContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        upperContainer.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        upperContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        upperContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: upperContainer.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: upperContainer.leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: upperContainer.widthAnchor, multiplier: 0.7).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: upperContainer.heightAnchor).isActive = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.topAnchor.constraint(equalTo: upperContainer.topAnchor, constant: 10).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: upperContainer.trailingAnchor, constant: -10).isActive = true
        countLabel.widthAnchor.constraint(equalTo: upperContainer.widthAnchor, multiplier: 0.3).isActive = true
        countLabel.heightAnchor.constraint(equalTo: upperContainer.heightAnchor).isActive = true
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
    
    func set(goal: Goal) {
        titleLabel.text = goal.title

        countLabel.text = "\(String(goal.progress.count))/100"
        if let detail = goal.detail {
            detailLabel.text = detail
        }
  
        if let progressEntry = goal.progress.first {
            if progressEntry.image != nil {
                let imagePath = getDocumentsDirectory().appendingPathComponent(progressEntry.image!)
                if let data = try? Data(contentsOf: imagePath) {
                    if let uiImage = UIImage(data: data) {
                        containerView.backgroundColor = UIColor(patternImage: uiImage).withAlphaComponent(0.3)
                        if uiImage.size.width > uiImage.size.height {
                            containerView.contentMode = .scaleAspectFit
                        } else {
                            containerView.contentMode = .scaleAspectFill
                        }
                    }
                }
            } else {
                containerView.backgroundColor = .white
            }
        } else {
            containerView.backgroundColor = .white
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
