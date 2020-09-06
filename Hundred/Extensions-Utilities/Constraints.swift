//
//  Constraints.swift
//  Hundred
//
//  Created by jc on 2020-08-05.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
    }
    
    func center(in superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
    }
    
    func constraintEqualToAnchor(superView: UIView, multiplier: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: multiplier ?? 1).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        heightAnchor.constraint(equalTo: superView.heightAnchor, multiplier: multiplier ?? 1).isActive = true
    }
}
