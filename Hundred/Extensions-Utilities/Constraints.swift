//
//  Constraints.swift
//  Hundred
//
//  Created by jc on 2020-08-05.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView, top: CGFloat?, leading: CGFloat?, trailing: CGFloat?, bottom: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top, let leading = leading, let trailing = trailing, let bottom = bottom {
            topAnchor.constraint(equalTo: superView.topAnchor, constant: top).isActive = true
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading).isActive = true
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailing).isActive = true
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: bottom).isActive = true
        }
    }
}
