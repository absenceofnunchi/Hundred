//
//  UserCell.swift
//  Hundred
//
//  Created by J C on 2020-09-09.
//  Copyright © 2020 J. All rights reserved.
//

/*
 Abstract:
 The custom cell for Public Feed.  It displays the information from the public cloud container.
 Linked to the UserViewController's table view.
 */

import UIKit
import CloudKit
import Charts

class UserCell: UITableViewCell {
    // MARK: - Properties
    
    // includes the image and the containerView
    lazy var outerContainerView: UIView = {
        let outerContainerView = UIView()
        addSubview(outerContainerView)
        BorderStyle.customShadowBorder(for: outerContainerView)
        outerContainerView.addSubview(self.containerView)
        return outerContainerView
    }()
    
    // excludes the image
    var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    var imageConstraints: [NSLayoutConstraint] = []
    var coverImageView = UIImageView()
    let titleLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0), lineBreakMode: .byTruncatingTail, textAlignment: .left)
    lazy var titleLabel = UILabel(theme: titleLabelTheme, text: "")
    let dateLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .regular), color: .gray, lineBreakMode: .byTruncatingTail, textAlignment: .right)
    lazy var dateLabel = UILabel(theme: dateLabelTheme, text: "")
    let usernameLabelTheme = UILabelTheme(font: UIFont.caption, color: .darkGray, lineBreakMode: .byTruncatingTail, textAlignment: .right)
    lazy var usernameLabel = UILabel(theme: usernameLabelTheme, text: "")
    let borderColor = UIColor.gray
    var commentContainer = UIView()
    var commentLabel = CustomLabel()
    var streakContainer = UIView()
    var currentStreakLabel = UILabel()
    var longestStreakLabel = UILabel()
    let metricCard = MetricCard()
    let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail)
    lazy var currentStreakTitle = UILabel(theme: unitLabelTheme, text: "")
    lazy var longestStreakTitle = UILabel(theme: unitLabelTheme, text: "")

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configureUI
    
    func configureUI() {
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(dateLabel)
        containerView.addArrangedSubview(usernameLabel)
        containerView.addArrangedSubview(commentContainer)
        
        commentContainer.addSubview(commentLabel)
        containerView.addArrangedSubview(streakContainer)

        streakContainer.addSubview(currentStreakLabel)
        streakContainer.addSubview(longestStreakLabel)
        streakContainer.addSubview(currentStreakTitle)
        streakContainer.addSubview(longestStreakTitle)
    }
    
    // MARK: - setConstraints
    
    func setConstraints() {
        outerContainerView.translatesAutoresizingMaskIntoConstraints = false
        outerContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.90).isActive = true
        outerContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        outerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        outerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: outerContainerView.widthAnchor, multiplier: 0.8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: outerContainerView.bottomAnchor, constant: -30).isActive = true
        containerView.centerXAnchor.constraint(equalTo: outerContainerView.centerXAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        containerView.setCustomSpacing(0, after: dateLabel)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        commentContainer.translatesAutoresizingMaskIntoConstraints = false
        commentContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.widthAnchor.constraint(equalTo: commentContainer.widthAnchor, multiplier: 0.9).isActive = true
        commentLabel.centerXAnchor.constraint(equalTo: commentContainer.centerXAnchor).isActive = true
        commentLabel.centerYAnchor.constraint(equalTo: commentContainer.centerYAnchor).isActive = true
        containerView.setCustomSpacing(20, after: commentContainer)
        
        streakContainer.translatesAutoresizingMaskIntoConstraints = false
        streakContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStreakLabel.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakLabel.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor, constant: 15).isActive = true
        currentStreakLabel.topAnchor.constraint(equalTo: streakContainer.topAnchor, constant: 10).isActive = true
        
        longestStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        longestStreakLabel.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakLabel.leadingAnchor.constraint(equalTo: currentStreakLabel.trailingAnchor, constant: 5).isActive = true
        longestStreakLabel.topAnchor.constraint(equalTo: streakContainer.topAnchor, constant: 10).isActive = true
        
        currentStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        currentStreakTitle.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakTitle.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor).isActive = true
        currentStreakTitle.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor, constant: 15).isActive = true
        currentStreakTitle.bottomAnchor.constraint(greaterThanOrEqualTo: streakContainer.bottomAnchor, constant: -10).isActive = true
        
        longestStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        longestStreakTitle.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakTitle.leadingAnchor.constraint(equalTo: currentStreakTitle.trailingAnchor, constant: 5).isActive = true
        longestStreakTitle.topAnchor.constraint(equalTo: longestStreakLabel.bottomAnchor).isActive = true
        longestStreakTitle.bottomAnchor.constraint(greaterThanOrEqualTo: streakContainer.bottomAnchor, constant: -10).isActive = true
    }
    
    // MARK: - set
    
    func set(user: CKRecord) {
        let title = user.object(forKey: MetricAnalytics.goal.rawValue) as? String
        let date = user.object(forKey: MetricAnalytics.date.rawValue) as? Date
        let username = user.object(forKey: MetricAnalytics.username.rawValue) as? String
        let comment = user.object(forKey: MetricAnalytics.comment.rawValue) as? String
        // today's metric/value pair, not the analytics
        let currentStreak = user.object(forKey: MetricAnalytics.currentStreak.rawValue) as? Int
        let longestStreak = user.object(forKey: MetricAnalytics.longestStreak.rawValue) as? Int

        // title
        titleLabel.text = title
        
        // date
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d y"
            dateLabel.text = dateFormatter.string(from: date)
        }

        // username
        if let username = username {
            usernameLabel.text = username
        }
        
        // comment
        commentContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        commentContainer.layer.borderWidth = 0.8
        commentContainer.layer.cornerRadius = 7.0
        
        commentLabel.textColor = .darkGray
        commentLabel.numberOfLines = 0
        commentLabel.adjustsFontSizeToFitWidth = false
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.font = UIFont.preferredFont(forTextStyle: .body)
        commentLabel.backgroundColor = .white
        if let comment = comment {
            commentLabel.text = comment
        }
        
        streakContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        streakContainer.layer.borderWidth = 0.8
        streakContainer.layer.cornerRadius = 7.0
        
        //longest, current streaks
        currentStreakTitle.text = "Current Streak"
        longestStreakTitle.text = "Longest Streak"
        
        currentStreakLabel.text = String(currentStreak ?? 0)
        longestStreakLabel.text = String(longestStreak ?? 0)
        
        // main image
        if let imageAsset = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset {
            metricCard.loadCoverPhoto(imageAsset: imageAsset) { (image) in
                if let image = image {
                    self.coverImageView.image = image
                    self.coverImageView.contentMode = .scaleAspectFill
                    self.coverImageView.clipsToBounds = true
                }
            }
            
            outerContainerView.addSubview(coverImageView)
            NSLayoutConstraint.deactivate(imageConstraints)
            
            coverImageView.translatesAutoresizingMaskIntoConstraints = false
            imageConstraints = [
                coverImageView.topAnchor.constraint(equalTo: outerContainerView.topAnchor),
                coverImageView.widthAnchor.constraint(equalTo: outerContainerView.widthAnchor),
                coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 9/16),
                containerView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 30),
                containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: commentLabel.frame.size.height + 20)
            ]
            NSLayoutConstraint.activate(imageConstraints)
            
        } else {
            NSLayoutConstraint.deactivate(imageConstraints)
            imageConstraints = [
                containerView.topAnchor.constraint(equalTo: outerContainerView.topAnchor, constant: 20),
                outerContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250)
            ]
            NSLayoutConstraint.activate(imageConstraints)
        }
    }
    
    // MARK: - prepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil

    }
}

