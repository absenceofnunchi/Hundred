//
//  FAQTableViewCell.swift
//  Hundred
//
//  Created by J C on 2020-09-26.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    var data: QandA? {
        didSet {
            guard let data = data else { return }
            questionLabel.text = data.question
            answerLabel.text = data.answer
        }
    }
    var containerView = UIView()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25)
        return stackView
    }()
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.body.with(weight: .bold)
        return questionLabel
    }()
    let answerLabel: UILabel = {
        let answerLabel = UILabel()
        answerLabel.numberOfLines = 0
        return answerLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        containerView.backgroundColor = .yellow
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 7
        containerView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 7.0, opacity: 0.35, bgColor: UIColor.white)
    }
    
    func configureUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(questionLabel)
        stackView.addArrangedSubview(answerLabel)
    }
    
    func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90).isActive = true
        containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        stackView.pin(to: containerView)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
}
