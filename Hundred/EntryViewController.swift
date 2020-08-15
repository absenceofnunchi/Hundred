//
//  EntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-06.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CalendarHeatmap

class EntryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIView!
    var progress: Progress!
    var metrics: [String]?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
        return stackView
    }()
    
    var uiImage: UIImage!
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = nil
        if let image = progress.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(image)
            if let data = try? Data(contentsOf: imagePath) {
                uiImage = UIImage(data: data)
                imgView.image = uiImage
                scrollView.addSubview(imgView)
                return imgView
            } else {
                return imgView
            }
        } else {
            return imgView
        }
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.string(from: progress.date)
        let tempLabel = UILabel()
        tempLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        tempLabel.textColor = .lightGray
        tempLabel.text = date
        tempLabel.textAlignment = .right
        return tempLabel
    }()
    
    private lazy var commentLabel: UILabel = {
        let comment = UILabel()
        comment.text = progress.comment
        comment.numberOfLines = 0
        comment.adjustsFontSizeToFitWidth = false
        comment.lineBreakMode = .byTruncatingTail
        comment.font = UIFont.preferredFont(forTextStyle: .body)
        return comment
    }()
    
    let firstMetricsStack = UIStackView()
    let secondMetricsStack = UIStackView()
    var data: [String: UIColor]!
    
    private lazy var calendarHeatMap: CalendarHeatmap = {
        var config = CalendarHeatmapConfig()
        config.backgroundColor = UIColor(ciColor: .white)
        // config item
        config.selectedItemBorderColor = .white
        config.allowItemSelection = true
        // config month header
        config.monthHeight = 30
        config.monthStrings = DateFormatter().shortMonthSymbols
        config.monthFont = UIFont.systemFont(ofSize: 18)
        config.monthColor = UIColor(ciColor: .black)
        // config weekday label on left
        config.weekDayFont = UIFont.systemFont(ofSize: 12)
        config.weekDayWidth = 30
        config.weekDayColor = UIColor(ciColor: .black)
        
        var dateComponent = DateComponents()
        let yearsBefore = -1
        dateComponent.year = yearsBefore
        if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) {
            let calendar = CalendarHeatmap(config: config, startDate: startDate, endDate: Date())
            calendar.delegate = self
            return calendar
        } else {
            let calendar = CalendarHeatmap(config: config, startDate: Date(2019, 1, 1), endDate: Date())
            calendar.delegate = self
            return calendar
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureTitleLabel()
        
        if imageView.image != nil {
            setImageViewConstraints()
        }
        setStackViewConstraints()
        //                setMetricsStackStraints()
        
        let dataImporter = DataImporter()
        data = dataImporter.data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func addTextToLabel(text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        stackView.addArrangedSubview(label)
    }
    
    private func addLine() {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
        l.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(l)
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(dateLabel)
        addTextToLabel(text: "Comment")
        addLine()
        stackView.addArrangedSubview(commentLabel)
        stackView.setCustomSpacing(30, after: commentLabel)
        addTextToLabel(text: "Calendar")
        addLine()
        stackView.addArrangedSubview(calendarHeatMap)
        //        configureMetricsLabel()
        scrollView.addSubview(stackView)
    }
    
    func configureTitleLabel() {
        title = progress.goal.title
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
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        if progress.image != nil {
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        }
    }
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = true
        if uiImage.size.width > uiImage.size.height {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
//    func setHeatMapConstraints(){
        //        calendarHeatMap.translatesAutoresizingMaskIntoConstraints = false
        //        calendarHeatMap.widthAnchor.constraint(equalTo: containerView2.widthAnchor).isActive = true
        //        calendarHeatMap.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 20).isActive = true
        //        calendarHeatMap.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor, constant: 20).isActive = true
        //        calendarHeatMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        //        calendarHeatMap.heightAnchor.constraint(equalToConstant: 190).isActive = true
//    }
    
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

extension EntryViewController: CalendarHeatmapDelegate {
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
        print(year, month, day)
    }
    
    func colorFor(dateComponents: DateComponents) -> UIColor {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return .clear}
        let dateString = "\(year).\(month).\(day)"
        return data[dateString] ?? UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    func finishLoadCalendar() {
        calendarHeatMap.scrollTo(date: Date(), at: .right, animated: false)
    }
}

