//
//  PriceCell.swift
//  Hundred
//
//  Created by J C on 2020-10-02.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import StoreKit

class PriceCell: UITableViewCell {
    let containerView = UILabel()
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let priceLabel = UILabel()
    let perMonthLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func set(product: SKProduct?, invalidProduct: String?) {
        // Show the localized title of the product.
        if let localizedTitle = product?.localizedTitle {
            titleLabel.text = localizedTitle
        }
        
        // Show the product's price in the locale and currency returned by the App Store.
        if let formattedPrice = product?.regularPrice {
            priceLabel.text = "\(formattedPrice)"
        }
    }

    func configureUI() {
        self.selectionStyle = .none

        BorderStyle.customShadowBorder(for: containerView)
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(perMonthLabel)

        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = UIColor(red: 0/255, green: 88/255, blue: 122/255, alpha: 1.0)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        
        detailLabel.text = "Post on Public Feed!"
        detailLabel.font = UIFont.caption.with(weight: .regular)
        detailLabel.adjustsFontSizeToFitWidth = false
        detailLabel.lineBreakMode = .byTruncatingTail
        
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        priceLabel.adjustsFontSizeToFitWidth = false
        priceLabel.lineBreakMode = .byTruncatingTail
        priceLabel.textColor = UIColor(red: 0/255, green: 136/255, blue: 145/255, alpha: 1.0)
        
        perMonthLabel.text = "auto-renewal"
        perMonthLabel.font = UIFont.caption.with(weight: .regular)
        perMonthLabel.adjustsFontSizeToFitWidth = false
        perMonthLabel.lineBreakMode = .byTruncatingTail
    }
    
    func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90).isActive = true
        containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10).isActive = true
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10).isActive = true
        
        perMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        perMonthLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        perMonthLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
}
