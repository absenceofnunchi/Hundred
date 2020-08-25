//
//  ButtonCreator.swift
//  Hundred
//
//  Created by jc on 2020-08-18.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

struct ButtonCreator {
    lazy var button: UIButton = createButton(title: title, image: image, uiImage: nil, cornerRadius: cornerRadius, color: color, size: size, tag: tag)
    var title: String? = nil
    var image: String = "camera.circle"
    var cornerRadius: CGFloat = 0
    var color: UIColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
    var size: CGFloat = 60
    var tag: Int = 1
    var delegate: NewViewController?
    
    func createButton(title: String?, image: String?, uiImage: UIImage?, cornerRadius: CGFloat, color: UIColor, size: CGFloat?, tag: Int) -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        
        if let image = image {
            if let size = size {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .medium, scale: .large)
                let uiImage = UIImage(systemName: image, withConfiguration: largeConfig)
                
                button.tintColor = color
                button.setImage(uiImage, for: .normal)
            }
        } else if let uiImage = uiImage {
            button.frame.size.height = 100
            button.frame.size.width = 200
            button.setImage(uiImage, for: .normal)
        }
        
        button.tag = tag
        button.addTarget(delegate, action: #selector(delegate?.buttonPressed), for: .touchDown)
            
        return button
    }
}


// 1. delete button - done
// 2. image delete - done
// 3. custom cell for goals - done
// 4. icloud kit
// 5. keychain
// 6. spotlight
// 7. face id
// 8. substract from plist when deleted
// 9. 100 days count
// 10. share
// 11. chart
// 12. show dates everywhere
