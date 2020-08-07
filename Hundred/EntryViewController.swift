//
//  EntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-06.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    var progress: Progress!
    var stackView = UIStackView()
    var imageView = UIImageView()
    var commentLabel = UILabel()
    var dateLabel = UILabel()
    var uiImage: UIImage!
    var line = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureDateLabel()
        configureTitleLabel()
        configureCommentLabel()
        
        setDateLabelConstraints()
        setCommentLabelConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        configureImageView()
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(commentLabel)
        view.addSubview(stackView)
        
        if progress.image != nil {
            setImageViewConstraints()
        } else {
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
    }
    
    func configureImageView() {
        if let image = progress.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(image)
            if let data = try? Data(contentsOf: imagePath) {
                uiImage = UIImage(data: data)
                imageView.image = uiImage
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    
    func configureTitleLabel() {
        title = progress.goal.title
    }
    
    func configureCommentLabel() {
        commentLabel.text = progress.comment
        commentLabel.numberOfLines = 0
        commentLabel.adjustsFontSizeToFitWidth = false
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func configureDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.string(from: progress.date)
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    func configureLine() {
        line.layer.borderWidth = 5
        line.layer.borderColor = CGColor(
        line.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = true
        if uiImage.size.width > uiImage.size.height {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    func setCommentLabelConstraints() {
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
    }
    
    func setDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        var axis: NSLayoutConstraint.Axis
    //
    //         if view.traitCollection.verticalSizeClass == .compact {
    //            axis = NSLayoutConstraint.Axis.horizontal
    //            if progress.image != nil {
    //                setImageViewConstraintsCompact()
    //            }
    //            setCommentLabelConstraintsCompact()
    //         } else {
    //            axis = NSLayoutConstraint.Axis.vertical
    //            if progress.image != nil {
    //                setImageViewConstraints()
    //            }
    //            setCommentLabelConstraints()
    //         }
    //
    //        stackView.axis = axis
    //    }
}




