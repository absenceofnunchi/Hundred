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
    var metrics: [String]?
    var stackView = UIStackView()
    var imageView = UIImageView()
    var dateLabel = UILabel()
    var line = UIView()
    var commentLabel = UILabel()
    var uiImage: UIImage!
    let firstMetricsStack = UIStackView()
    let secondMetricsStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureDateLabel()
        configureTitleLabel()
        configureCommentLabel()
        
        setDateLabelConstraints()
        setLineConstraints()
        setCommentLabelConstraints()
        setMetricsStackStraints()
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
        line.addBottomBorderWithColor(color: UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1), width: view.frame.width - 20)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(commentLabel)
        configureMetricsLabel()
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
    
    func configureDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.string(from: progress.date)
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.textColor = .lightGray
    }
    
    func configureCommentLabel() {
        commentLabel.text = progress.comment
        commentLabel.numberOfLines = 0
        commentLabel.adjustsFontSizeToFitWidth = false
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func configureMetricsLabel() {
        if let firstMetric = progress.firstMetric, let secondMetric = progress.secondMetric {
            firstMetricsStack.axis = .horizontal
            firstMetricsStack.alignment = .center
            firstMetricsStack.distribution = .fill
            if let firstMetricUnit = metrics?[0] {
                let firstMetricUnitLabel = UILabel()
                firstMetricUnitLabel.text = firstMetricUnit
                firstMetricsStack.addArrangedSubview(firstMetricUnitLabel)
                let firstMetricLabel = UILabel()
                firstMetricLabel.text = String(describing: firstMetric)
                firstMetricsStack.addArrangedSubview(firstMetricLabel)
                stackView.addArrangedSubview(firstMetricsStack)
            }

            if secondMetric != 0 {
                if let secondMetricUnit = metrics?[1] {
                    secondMetricsStack.axis = .horizontal
                    secondMetricsStack.alignment = .center
                    secondMetricsStack.distribution = .fill
                    let secondMetricUnitLabel = UILabel()
                    secondMetricUnitLabel.text = secondMetricUnit
                    secondMetricsStack.addArrangedSubview(secondMetricUnitLabel)
                    let secondMetricLabel = UILabel()
                    secondMetricLabel.text = String(describing: secondMetric)
                    secondMetricsStack.addArrangedSubview(secondMetricLabel)
                    stackView.addArrangedSubview(secondMetricsStack)
                }
            }
        }
    }
    
    func setLineConstraints() {
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .black
        line.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
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
    
    func setDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dateLabel.textAlignment = .right
    }
    
    func setCommentLabelConstraints() {
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func setMetricsStackStraints() {
        firstMetricsStack.translatesAutoresizingMaskIntoConstraints = false
        firstMetricsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        firstMetricsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
         if let secondMetric = progress.secondMetric {
            if secondMetric != 0 {
                secondMetricsStack.translatesAutoresizingMaskIntoConstraints = false
                secondMetricsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                secondMetricsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            }
        }
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

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height, width: width, height: 1)
        self.layer.addSublayer(border)
    }
}



