//
//  EditViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-21.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var goalDetail: Goal!
    var goalFromCoreData: Goal!

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 30, bottom: tabBarHeight + 50, trailing: 30)
        }
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    lazy var goalTextField: UITextField = {
        let textField = UITextField()
        textField.text = goalDetail.title
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = UIColor.gray
        textField.borderStyle = .roundedRect
        let borderColor = UIColor.gray
        textField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        return textField
    }()
    
    var goalDescContainer: UIStackView = {
        let gStackView = UIStackView()
        gStackView.axis = .vertical
        gStackView.distribution = .fill
        gStackView.alignment = .fill
        return gStackView
    }()
    
    lazy var goalDescTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.text = goalDetail.detail
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.gray
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        addHeader(text: "Goal Description", stackView: self.goalDescContainer)
        self.goalDescContainer.addArrangedSubview(textView)
        return textView
    }()
    
    var plusButton: UIButton = {
        let pButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        let uiImage = UIImage(systemName: "plus.square.fill", withConfiguration: largeConfig)
        pButton.setImage(uiImage, for: .normal)
        pButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
        pButton.tag = 1
        pButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return pButton
    }()
    
    var minusButton: UIButton = {
        let pButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        let uiImage = UIImage(systemName: "minus.square.fill", withConfiguration: largeConfig)
        pButton.setImage(uiImage, for: .normal)
        pButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
        pButton.tag = 2
        pButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return pButton
    }()
    
    var metricPanel = UIView()
    
    lazy var metricStackView: UIStackView = {
        let mStackView = UIStackView()
        mStackView.axis = .vertical
        mStackView.alignment = .fill
        mStackView.distribution = .equalSpacing
        mStackView.spacing = 10
        
        if let existingGoalMetrics = self.goalDetail.metrics {
            for metric in existingGoalMetrics {
                let metricUnitTextField = UITextField()
                metricUnitTextField.text = metric
                metricUnitTextField.textAlignment = .center
                metricUnitTextField.borderStyle = .roundedRect
                let borderColor = UIColor.gray
                metricUnitTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
                mStackView.addArrangedSubview(metricUnitTextField)
                
                metricUnitTextField.translatesAutoresizingMaskIntoConstraints = false
                metricUnitTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                metricUnitTextField.widthAnchor.constraint(equalTo: mStackView.widthAnchor).isActive = true
            }
        }
        
        return mStackView
    }()
    
    lazy var doneButton: UIButton = {
        let dButton = UIButton()
        dButton.setTitle("Done", for: .normal)
        dButton.layer.cornerRadius = 0
        dButton.backgroundColor = .systemYellow
        dButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        dButton.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        dButton.tag = 3
        dButton.addTarget(self, action: #selector(buttonPressed) , for: .touchUpInside)
        return dButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Goal Detail"
        
        initializeHideKeyboard()
        configureStackView()
        setConstraints()
        
        view.addSubview(doneButton)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureStackView() {
        addHeader(text: "Goal Title", stackView: stackView)
        stackView.addArrangedSubview(goalTextField)
        stackView.setCustomSpacing(60, after: goalTextField)
        
        stackView.addArrangedSubview(goalDescContainer)
        stackView.setCustomSpacing(60, after: goalDescContainer)
        
        addHeader(text: "Metrics", stackView: stackView)
        metricPanel.addSubview(plusButton)
        metricPanel.addSubview(minusButton)
        stackView.addArrangedSubview(metricPanel)
        stackView.addArrangedSubview(metricStackView)
        stackView.setCustomSpacing(60, after: metricStackView)
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalDescTextView.translatesAutoresizingMaskIntoConstraints = false
        goalDescTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        metricPanel.translatesAutoresizingMaskIntoConstraints = false
        metricPanel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -15).isActive = true
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.trailingAnchor.constraint(equalTo: metricPanel.trailingAnchor).isActive = true
        
        metricStackView.translatesAutoresizingMaskIntoConstraints = false
        metricStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            let metricUnitTextField = UITextField()
            metricUnitTextField.alpha = 0
            metricUnitTextField.placeholder = "Metrics Unit"
            metricUnitTextField.textAlignment = .center
            metricUnitTextField.borderStyle = .roundedRect
            metricUnitTextField.autocapitalizationType = .none
            metricUnitTextField.autocorrectionType = .no
            let borderColor = UIColor.gray
            metricUnitTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            metricStackView.addArrangedSubview(metricUnitTextField)
            
            UIView.animate(withDuration: 0.8, animations: {
                metricUnitTextField.alpha = 1
            })
            
            metricUnitTextField.translatesAutoresizingMaskIntoConstraints = false
            metricUnitTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        case 2:
            if metricStackView.arrangedSubviews.count > 0 {
                let metricSubview = metricStackView.arrangedSubviews[metricStackView.arrangedSubviews.count - 1]
                UIView.animate(withDuration: 0.8, animations: {
                    metricSubview.alpha = 0
                }, completion: { finished in
                    self.metricStackView.removeArrangedSubview(metricSubview)
                    metricSubview.removeFromSuperview()
                })
            }
        case 3:
            let ac = UIAlertController(title: "Warning", message: "If you're changing the name of the existing metrics, all the metric values with the previous name will be deleted", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: update))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
            
        default:
            print("default")
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - keyboardViewEndFrame.height - 50, width: view.frame.size.width, height: 50)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func update(arg: UIAlertAction) {
        // extract each metric to an array
        var metricArr: [String] = []
        for singleMetric in metricStackView.arrangedSubviews {
            if singleMetric is UILabel {
                let existingUnitLabel = singleMetric as! UILabel
                if let textContent = existingUnitLabel.text {
                    let trimmedText = textContent.trimmingCharacters(in: .whitespacesAndNewlines)
                    metricArr.append(trimmedText)
                }
            } else if singleMetric is UITextField {
                let unitTextField = singleMetric as! UITextField
                if let textContent = unitTextField.text {
                    let trimmedText = textContent.trimmingCharacters(in: .whitespacesAndNewlines)
                    metricArr.append(trimmedText)
                }
            }
        }
        
        if metricArr.isDistinct() == true {
            let goalRequest = Goal.createFetchRequest()
            goalRequest.predicate = NSPredicate(format: "title == %@", goalDetail.title)
            if let fetchedGoal = try? self.context.fetch(goalRequest) {
                if fetchedGoal.count > 0 {
                    goalFromCoreData = fetchedGoal.first
                    
                    if let goalTitle = goalTextField.text {
                        goalFromCoreData.title = goalTitle
                    }
                    
                    if let goalDesc = goalDescTextView.text {
                        goalFromCoreData.detail = goalDesc
                    }
                    
                    if goalFromCoreData.metrics == nil {
                        goalFromCoreData.metrics = []
                        goalFromCoreData.metrics = metricArr
                    } else {
                        // delete all the metrics from Core Data that are not in the newly updated version
                        if let existingMetrics = goalFromCoreData.metrics {
                            let discartedMetrics = metricArr.subtract(from: existingMetrics)
                            if discartedMetrics.count > 0 {
                                var subPredicateArr = [NSPredicate]()
                                for singleMetric in discartedMetrics {
                                    subPredicateArr.append(NSPredicate(format: "unit = %@", singleMetric))
                                }
                                let orPredicate = NSCompoundPredicate(type: .or, subpredicates: subPredicateArr)
                                let metricRequest = Metric.createFetchRequest()
                                metricRequest.predicate = orPredicate
                                //                                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: metricRequest)
                                //
                                //                                    do {
                                //                                        _ = try self.context.execute(deleteRequest)
                                //                                    } catch {
                                //                                        fatalError("Delete failed: \(error.localizedDescription)")
                                //                                    }
                            }
                        }
                        
                        goalFromCoreData.metrics = metricArr
                        
                    }
                    
                    self.saveContext()
                    

                    _ = navigationController?.popViewController(animated: true)
                } else {
                    print("goal's in the existing list, but doesn't fetch")
                    return
                }
            }
        } else {
            let ac = UIAlertController(title: "Duplicate Metrics", message: "Each metric unit has to be unique", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
    }

}

extension Array where Element: Hashable {
    func subtract(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(otherSet.subtracting(thisSet))
    }
}

extension EditViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? NewViewController)?.existingGoal = goalFromCoreData
    }
}
