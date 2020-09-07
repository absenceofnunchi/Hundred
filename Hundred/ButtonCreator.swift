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
// 4. icloud kit - needs a developer account
// 5. keychain
// 6. spotlight - appdelegate doesn't work
// 7. face id
// 8. substract from plist when deleted - done
// 9. 100 days count - done
// 10. share
// 11. chart - done
// 12. show dates everywhere, esp. goal created date - done
// 13. notification
// 14. disable a done button  - done
// 15. fix detail custom cell text alignment
// 16. map - needs google places - done
// 17. peek - done
// 18. only show select plist per entry - done
// 19. image corner radius
// 20. cell animation - delays touch
// 21. landscape pie chart
// 22. delete the images in ios directory
// 23. fix streak
// 24. make things background
// 25. modified the goal from no metrics to some metrics. But since no values are added, they won't appear on modifying the entry
// 26. done button when coming back from existing goals
// 27. dark mode
// 28. multiple photos

//Thread 1: Fatal error: Unresolved error Error Domain=NSCocoaErrorDomain Code=134060 "A Core Data error occurred." UserInfo={NSLocalizedFailureReason=CloudKit integration requires that the value transformers for transformable attributes are available via +[NSValueTransformer valueTransformerForName:], return instances of NSData, and allow reverse transformation:
//Goal: metrics - Claims to return instances of nil}, ["NSLocalizedFailureReason": CloudKit integration requires that the value transformers for transformable

// NSSecureUnarchiveFromData
