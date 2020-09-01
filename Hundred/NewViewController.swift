//
//  NewViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-16.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class NewViewController: UIViewController {
    var imagePathString: String?
    var imagePath: URL?

    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    private lazy var cameraButton: UIButton = {
        return createButton(title: nil, image: "camera.circle", cornerRadius: 0, color:  UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 60, tag: 1)
    }()
    
    lazy var goalTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Goal Title"
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        customShadowBorder(for: textField)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
        
    lazy var goalLabel: CustomLabel = {
        let gLabel = CustomLabel()
        gLabel.textAlignment = .left
        gLabel.font = UIFont.preferredFont(forTextStyle: .body)
        gLabel.alpha = 0
        customShadowBorder(for: gLabel)
        return gLabel
    }()
    
    lazy var goalButton: UIButton = {
        let gButton = UIButton()
        gButton.setTitle("Get existing goals", for: .normal)
        gButton.tag = 5
        gButton.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
        gButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        let borderColor = UIColor.gray
        gButton.layer.borderWidth = 1
        gButton.layer.masksToBounds = false
        gButton.layer.cornerRadius = 7.0;
        gButton.layer.borderColor = UIColor.clear.cgColor
        gButton.layer.shadowColor = UIColor.black.cgColor
        gButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        gButton.layer.shadowOpacity = 0.2
        gButton.layer.shadowRadius = 4.0
        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return gButton
    }()
    
    lazy var backToNewGoalButton: UIButton = {
        let bButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "arrowshape.turn.up.left.circle", withConfiguration: largeConfig)
        bButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
        bButton.imageView?.contentMode = .scaleAspectFit
        //        bButton.imageEdgeInsets = UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50)
        bButton.setImage(uiImage, for: .normal)
        bButton.tag = 6
        bButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return bButton
    }()
    
    lazy var editGoalButton: UIButton = {
        let eButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "pencil.circle", withConfiguration: largeConfig)
        eButton.tintColor = UIColor(red: 117/255, green: 212/255, blue: 213/255, alpha: 1.0)
        eButton.imageView?.contentMode = .scaleAspectFit
        eButton.setImage(uiImage, for: .normal)
        eButton.tag = 8
        eButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return eButton
    }()
    
    lazy var deleteGoalButton: UIButton = {
        let tButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "trash.circle", withConfiguration: largeConfig)
        tButton.tintColor = UIColor(red: 234/255, green: 84/255, blue: 85/255, alpha: 1.0)
        tButton.imageView?.contentMode = .scaleAspectFit
        tButton.setImage(uiImage, for: .normal)
        tButton.tag = 7
        tButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return tButton
    }()
    
    lazy var editButtonContainer: UIStackView = {
        let eStackView = UIStackView()
        eStackView.distribution = .equalSpacing
        eStackView.alignment = .fill
        eStackView.axis = .horizontal
        eStackView.addArrangedSubview(backToNewGoalButton)
        eStackView.addArrangedSubview(editGoalButton)
        eStackView.addArrangedSubview(deleteGoalButton)
        return eStackView
    }()
    
    var existingGoal: Goal? {
        didSet {
            if existingGoal == nil {
                doneButton.isEnabled = false
                doneButton.backgroundColor = .systemGray3
                
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                self.cameraButton.setImage(uiImage, for: .normal)
                self.cameraButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                
                self.goalLabel.alpha = 0
                self.goalLabel.text = nil
                self.stackView.removeArrangedSubview(self.goalLabel)
                self.goalLabel.removeFromSuperview()
                
                if stackView.contains(editButtonContainer) {
                    stackView.removeArrangedSubview(editButtonContainer)
                    editButtonContainer.removeFromSuperview()
                }

                for singleSubview in metricStackView.arrangedSubviews {
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                        singleSubview.alpha = 0
                    })
                    metricStackView.removeArrangedSubview(singleSubview)
                    singleSubview.removeFromSuperview()
                }
                
                stackView.removeArrangedSubview(metricStackView)
                metricStackView.removeFromSuperview()
                
                self.stackView.insertArrangedSubview(self.goalTextField, at: 3)
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.goalTextField.alpha = 1
                    self.plusButton.alpha = 1
                    self.minusButton.alpha = 1
                })
                
                goalButton.alpha = 0
                stackView.insertArrangedSubview(goalButton, at: 4)
                stackView.setCustomSpacing(70, after: goalButton)
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.goalButton.alpha = 1
                })
                
                self.stackView.insertArrangedSubview(self.goalDescContainer, at: 5)
                self.stackView.setCustomSpacing(70, after: self.goalDescContainer)
                self.goalDescContainer.alpha = 1
                
                self.commentTextView.text = "Provide a comment about your first progress"
                self.commentTextView.textColor = UIColor.lightGray
                
                metricPanel.addSubview(plusButton)
                metricPanel.addSubview(minusButton)
                stackView.addArrangedSubview(metricPanel)
                stackView.addArrangedSubview(metricStackView)
                stackView.setCustomSpacing(70, after: metricStackView)
                setConstraints()
            } else {
                doneButton.isEnabled = true
                doneButton.backgroundColor = UIColor(red: 254/255, green: 211/255, blue: 48/255, alpha: 1.0)
                
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                self.cameraButton.setImage(uiImage, for: .normal)
                self.cameraButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                
                if stackView.contains(goalButton) {
                    stackView.removeArrangedSubview(goalButton)
                    goalButton.removeFromSuperview()
                }
                editButtonContainer.alpha = 0
                stackView.insertArrangedSubview(editButtonContainer, at: 4)
                stackView.setCustomSpacing(70, after: editButtonContainer)
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.editButtonContainer.alpha = 1
                })
                
                // remove the existing fields for a new goal
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.goalTextField.alpha = 0
                    self.goalDescContainer.alpha = 0
                    self.plusButton.alpha = 0
                    self.minusButton.alpha = 0
                })
                goalTextField.text = nil
                stackView.removeArrangedSubview(goalTextField)
                goalTextField.removeFromSuperview()
                stackView.removeArrangedSubview(goalDescContainer)
                goalDescContainer.removeFromSuperview()
                plusButton.removeFromSuperview()
                minusButton.removeFromSuperview()
                stackView.removeArrangedSubview(metricPanel)
                metricPanel.removeFromSuperview()
                
                // add the fields relevant to the existing goal
                stackView.insertArrangedSubview(goalLabel, at: 3)
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.goalLabel.text = self.existingGoal?.title
                    self.goalLabel.alpha = 1
                })
                
                for singleSubview in metricStackView.arrangedSubviews {
                    metricStackView.removeArrangedSubview(singleSubview)
                    singleSubview.removeFromSuperview()
                }
                
                if let existingGoalMetrics = existingGoal?.metrics {
                    commentTextView.text = "Provide a comment about today's progress"
                    commentTextView.textColor = UIColor.lightGray
                    
                    for metric in existingGoalMetrics {
                        
                        let metricView = UIView()
                        metricView.alpha = 0
                        
                        let metricLabel = UILabel()
                        metricLabel.text = metric
                        metricLabel.textAlignment = .center
                        customShadowBorder(for: metricLabel)
                        metricView.addSubview(metricLabel)
                        
                        let metricTextField = UITextField()
                        metricTextField.keyboardType = UIKeyboardType.decimalPad
                        metricTextField.placeholder = "Metrics"
                        metricTextField.textAlignment = .center
                        customShadowBorder(for: metricTextField)
                        metricView.addSubview(metricTextField)
                        
                        metricStackView.addArrangedSubview(metricView)
                        
                        metricLabel.translatesAutoresizingMaskIntoConstraints = false
                        metricLabel.leadingAnchor.constraint(equalTo: metricView.leadingAnchor).isActive = true
                        metricLabel.centerYAnchor.constraint(equalTo: metricView.centerYAnchor).isActive = true
                        metricLabel.widthAnchor.constraint(equalTo: metricView.widthAnchor, multiplier: 0.46).isActive = true
                        metricLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
                        
                        metricTextField.translatesAutoresizingMaskIntoConstraints = false
                        metricTextField.trailingAnchor.constraint(equalTo: metricView.trailingAnchor).isActive = true
                        metricTextField.centerYAnchor.constraint(equalTo: metricView.centerYAnchor).isActive = true
                        metricTextField.widthAnchor.constraint(equalTo: metricView.widthAnchor, multiplier: 0.46).isActive = true
                        metricTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                        
                        metricView.translatesAutoresizingMaskIntoConstraints = false
                        metricView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                        
                        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                            metricView.alpha = 1
                        })
                    }
                }
            }
        }
    }
    
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
        textView.text = "Provide a description about your goal"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.lightGray
        addHeader(text: "Goal Description", stackView: self.goalDescContainer)
        self.goalDescContainer.addArrangedSubview(textView)
        customShadowBorder(for: textView)
        
        return textView
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.text = "Provide a comment about your first progress"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.lightGray
        customShadowBorder(for: textView)
        
        return textView
    }()
    
    var plusButton: UIButton!
    var minusButton: UIButton!
    var metricPanel = UIView()
    
    var metricStackView: UIStackView = {
        let mStackView = UIStackView()
        mStackView.axis = .vertical
        mStackView.alignment = .fill
        mStackView.distribution = .equalSpacing
        mStackView.spacing = 10
        return mStackView
    }()
    
    lazy var doneButton: UIButton = {
        let dButton = UIButton()
        dButton.setTitle("Done", for: .normal)
        dButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        dButton.layer.cornerRadius = 0
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            dButton.frame = CGRect(x: 0, y: view.frame.size.height - CGFloat(tabBarHeight + 50), width: view.frame.size.width, height: 50)
        }
        dButton.tag = 4
        dButton.backgroundColor = .systemGray3
        dButton.addTarget(self, action: #selector(buttonPressed) , for: .touchUpInside)
        dButton.isEnabled = false
        return dButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        goalDescTextView.delegate = self
        initializeHideKeyboard()
        
        plusButton = createButton(title: nil, image: "plus.square.fill", cornerRadius: 0, color: UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 30, tag: 2)
        minusButton = createButton(title: nil, image: "minus.square.fill", cornerRadius: 0, color: UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 30, tag: 3)
        
        configureUI()
        setConstraints()
        view.addSubview(doneButton)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
       self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func configureUI() {
        navigationController?.title = "New Entry"
        
        stackView.addArrangedSubview(cameraButton)
        stackView.setCustomSpacing(40, after: cameraButton)
        
        addHeader(text: "Goal Title", stackView: stackView)
        stackView.addArrangedSubview(goalTextField)
        stackView.addArrangedSubview(goalButton)
        stackView.setCustomSpacing(70, after: goalButton)
        
        stackView.addArrangedSubview(goalDescContainer)
        stackView.setCustomSpacing(70, after: goalDescContainer)
        
        addHeader(text: "Comment", stackView: stackView)
        stackView.addArrangedSubview(commentTextView)
        stackView.setCustomSpacing(70, after: commentTextView)
        
        addHeader(text: "Metrics", stackView: stackView)
        metricPanel.addSubview(plusButton)
        metricPanel.addSubview(minusButton)
        stackView.addArrangedSubview(metricPanel)
        stackView.addArrangedSubview(metricStackView)
        stackView.setCustomSpacing(70, after: metricStackView)
    }
    
    func setConstraints() {
        stackView.pin(to: scrollView)
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalButton.translatesAutoresizingMaskIntoConstraints = false
        goalButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        editButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        editButtonContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalDescTextView.translatesAutoresizingMaskIntoConstraints = false
        goalDescTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
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
    
    func createButton(title: String?, image: String?, cornerRadius: CGFloat, color: UIColor, size: CGFloat?, tag: Int) -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
        
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
        }
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tag = tag
        
        return button
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            let ac = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhoto))
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
            if imagePathString != nil {
                ac.addAction(UIAlertAction(title: "No Image", style: .default, handler: { action in
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                    let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                    self.cameraButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                    self.cameraButton.setImage(uiImage, for: .normal)
                }))
                self.imagePathString = nil
            }
            present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
            
        case 2:
            let metricView = UIView()
            metricView.alpha = 0
            
            let metricUnitTextField = CustomTextField()
            metricUnitTextField.placeholder = "Unit"
            metricUnitTextField.textAlignment = .center
            
            metricUnitTextField.autocapitalizationType = .none
            metricUnitTextField.autocorrectionType = .no
            customShadowBorder(for: metricUnitTextField)
            metricView.addSubview(metricUnitTextField)
            
            let metricTextField = CustomTextField()
            metricTextField.keyboardType = UIKeyboardType.decimalPad
            metricTextField.placeholder = "Metrics"
            metricTextField.textAlignment = .center
            customShadowBorder(for: metricTextField)
            metricView.addSubview(metricTextField)
            
            metricView.translatesAutoresizingMaskIntoConstraints = false
            metricStackView.addArrangedSubview(metricView)
            UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                metricView.alpha = 1
            })
            
            metricUnitTextField.translatesAutoresizingMaskIntoConstraints = false
            metricUnitTextField.leadingAnchor.constraint(equalTo: metricView.leadingAnchor).isActive = true
            metricUnitTextField.centerYAnchor.constraint(equalTo: metricView.centerYAnchor).isActive = true
            metricUnitTextField.widthAnchor.constraint(equalTo: metricView.widthAnchor, multiplier: 0.46).isActive = true
            metricUnitTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            metricTextField.translatesAutoresizingMaskIntoConstraints = false
            metricTextField.trailingAnchor.constraint(equalTo: metricView.trailingAnchor).isActive = true
            metricTextField.centerYAnchor.constraint(equalTo: metricView.centerYAnchor).isActive = true
            metricTextField.widthAnchor.constraint(equalTo: metricView.widthAnchor, multiplier: 0.46).isActive = true
            metricTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            metricView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        case 3:
            if metricStackView.arrangedSubviews.count > 0 {
                let metricSubview = metricStackView.arrangedSubviews[metricStackView.arrangedSubviews.count - 1]
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseOut], animations: {
                    metricSubview.alpha = 0
                }, completion: { finished in
                    self.metricStackView.removeArrangedSubview(metricSubview)
                    metricSubview.removeFromSuperview()
                })
            }
            
        case 4:
            // extract each metric unit/value to metricDict
            var metricDict: [String: String] = [:]
            for metricPair in metricStackView.arrangedSubviews {
                if metricPair.subviews[0] is UITextField {
                    let unitTextField = metricPair.subviews[0] as! UITextField
                    let valueTextField = metricPair.subviews[1] as! UITextField
                    
                    if let textContent = unitTextField.text, let valueTextContent = valueTextField.text {
                        guard Double(valueTextContent) != nil else {
                            let ac = UIAlertController(title: "Invalid Input", message: "The metric value has to be a number", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
                            present(ac, animated: true)
                            return
                        }
                        
                        let trimmedKey = textContent.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedValue = valueTextContent.trimmingCharacters(in: .whitespacesAndNewlines)
                        metricDict.updateValue(trimmedValue, forKey: trimmedKey)
                    }
                } else if metricPair.subviews[0] is UILabel {
                    let unitLabel = metricPair.subviews[0] as! UILabel
                    let valueTextField = metricPair.subviews[1] as! UITextField
                    if let textContent = unitLabel.text, let valueTextContent = valueTextField.text {
                        let trimmedValue = valueTextContent.trimmingCharacters(in: .whitespacesAndNewlines)
                        metricDict.updateValue(trimmedValue, forKey: textContent)
                    }
                }
            }
            
            // check for any duplicate metric unit and instantiate an array of metric entities
            var metricArr: [Metric] = []
            if Array(metricDict.keys).isDistinct() == true {
                for singleMetricPair in metricDict {
                    let metric = Metric(context: self.context)
                    
//                    let df = DateFormatter()
//                    df.dateFormat = "yyyy/MM/dd HH:mm"
//                    let someDateTime = df.date(from: "2020/08/26 22:31")
//                    metric.date = someDateTime!
                    metric.date = Date()
                    metric.unit = singleMetricPair.key
                    metric.id = NSUUID() as UUID
                    metric.value = stringToDecimal(string: singleMetricPair.value)
                    metricArr.append(metric)
                }
            } else {
                let ac = UIAlertController(title: "Duplicate Metrics", message: "Each metric unit has to be unique", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(ac, animated: true)
                return
            }
            
            // create a progress instance
            let progress = Progress(context: self.context)
            progress.image = imagePathString
            progress.comment = commentTextView.text
            progress.date = Date()
//            progress.id = UUID().uuidString
            
            // Core Spotlight indexing for Progress
            let progressAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            progressAttributeSet.title = goalTextField.text
            progressAttributeSet.contentCreationDate = Date()
            progressAttributeSet.contentDescription = commentTextView.text
            if let titleKeywords =  goalTextField.text?.components(separatedBy: " ") {
                var keywordsArr = ["productivity", "goal setting", "habit"]
                for keyword in titleKeywords {
                    keywordsArr.append(keyword)
                }
                progressAttributeSet.keywords = keywordsArr
            }
            
            if let imagePath = imagePath {
                progressAttributeSet.thumbnailURL = imagePath
            }

            let progressItem = CSSearchableItem(uniqueIdentifier: "\(String(describing: goalTextField.text))\(Date())", domainIdentifier: "com.noName.Hundred", attributeSet: progressAttributeSet)
            progressItem.expirationDate = Date.distantFuture
            CSSearchableIndex.default().indexSearchableItems([progressItem]) { (error) in
                if let error = error {
                    print("Indexing error: \(error.localizedDescription)")
                } else {
                    print("Search item successfully indexed")
                }
            }
            
            var goalFromCoreData: Goal!
            let goalRequest = Goal.createFetchRequest()
            
            // create a new goal
            if let goalText = goalTextField.text, !goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                goalRequest.predicate = NSPredicate(format: "title == %@", goalText)
                if let fetchedGoal = try? self.context.fetch(goalRequest) {
                    if fetchedGoal.count > 0 {
                        let ac = UIAlertController(title: "The goal already exists", message: "Please choose from the existing goals", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        present(ac, animated: true)
                        return
                    } else {
                        let goal = Goal(context: self.context)
                        goal.title = goalText
                        goal.detail = goalDescTextView.text
                        goal.date = Date()
                        goal.lastUpdatedDate = Date()
                        goal.streak = 0
                        goal.longestStreak = 0
                        
                        for item in metricDict {
                            if case nil = goal.metrics?.append(item.key) {
                                goal.metrics = [item.key]
                                
                                let highestMetric = HighestMetrics(context: self.context)
                                highestMetric.unit = item.key
                                highestMetric.value = stringToDecimal(string: item.value)
                                goal.highestToGoal.insert(highestMetric)
                            }
                        }
                        
                        for singleEntry in metricArr {
                            progress.metric.insert(singleEntry)
                            goal.goalToMetric.insert(singleEntry)
                        }

                        goal.progress.insert(progress)
                         
                        // Core Spotlight indexing
                        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                        attributeSet.title = goalText
                        attributeSet.contentCreationDate = Date()
                        attributeSet.contentDescription = goalDescTextView.text
                        if let titleKeywords =  goalTextField.text?.components(separatedBy: " ") {
                             var keywordsArr = ["productivity", "goal setting", "habit"]
                             for keyword in titleKeywords {
                                 keywordsArr.append(keyword)
                             }
                             progressAttributeSet.keywords = keywordsArr
                         }
                        
                        let item = CSSearchableItem(uniqueIdentifier: "\(goalText)", domainIdentifier: "com.noName.Hundred", attributeSet: attributeSet)
                        item.expirationDate = Date.distantFuture
                        CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
                            if let error = error {
                                print("Indexing error: \(error.localizedDescription)")
                            } else {
                                print("Search item successfully indexed")
                            }
                        }
                    }
                }
            // Add to an existing goal
            } else if let existingGoalText = goalLabel.text, !existingGoalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                goalRequest.predicate = NSPredicate(format: "title == %@", existingGoalText)
                if let fetchedGoal = try? self.context.fetch(goalRequest) {
                    if fetchedGoal.count > 0 {
                        // Update existing Core Data
                        goalFromCoreData = fetchedGoal.first
                        
                        // metrics
                        for singleEntry in metricArr {
                            progress.metric.insert(singleEntry)
                            goalFromCoreData.goalToMetric.insert(singleEntry)
                        }
                        
                        // progress
                        goalFromCoreData.progress.insert(progress)
                        
                        // highest metric
                        for highestMetric in goalFromCoreData.highestToGoal {
                            if let newMetric = metricDict[highestMetric.unit] {
                                if let convertedNewMetric = Double(newMetric) {
                                    if  convertedNewMetric > highestMetric.value.doubleValue {
                                        highestMetric.value = stringToDecimal(string: newMetric)
                                    }
                                } else {
                                    print("metric couldn't be converted to double")
                                }
                            }
                        }
                        
                        // streak
                        if let lastUpdatedDate =  goalFromCoreData.lastUpdatedDate {
                            let deadline = dayVariance(date: lastUpdatedDate, value: 1)
                            let endOfToday = dayVariance(date: Date(), value: 0)
                            let endOfYesterday = dayVariance(date: Date(), value: -1)
                            
                            // prevent multiple streaks from the same day
                            if deadline > Date() && !(endOfYesterday < lastUpdatedDate &&  lastUpdatedDate < endOfToday) {
                                goalFromCoreData.streak += 1
                                
                                if goalFromCoreData.streak > goalFromCoreData.longestStreak {
                                    goalFromCoreData.longestStreak = goalFromCoreData.streak
                                }
                            } else {
                                goalFromCoreData.streak = 0
                            }
                        } else {
                            goalFromCoreData.streak = 0
                        }
                        
                        goalFromCoreData.lastUpdatedDate = Date()
                    } else {
                        print("goal's in the existing list, but doesn't fetch")
                        return
                    }
                }
            }
            
            savePList()
            self.saveContext()
            
            imagePathString = nil
            goalFromCoreData = nil
            existingGoal = nil
            goalTextField.text = nil
            goalDescTextView.text = "Provide a description about your goal"
            goalDescTextView.textColor = UIColor.lightGray
            commentTextView.text = "Provide a comment about your first progress"
            commentTextView.textColor = UIColor.lightGray

            if self.metricStackView.arrangedSubviews.count > 0 {
                for subView in self.metricStackView.arrangedSubviews {
                    self.metricStackView.removeArrangedSubview(subView)
                    subView.removeFromSuperview()
                }
            }
            
            view.endEditing(true)
            self.showSpinner(container: self.scrollView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tabBarController?.selectedIndex = 1
                self.removeSpinner()
            }
            
        case 5:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ExistingGoalsMenu") as? ExistingGoalsMenuTableViewController {
                vc.isDismissed = { [weak self] goal in
                    self?.existingGoal = goal
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        case 6:
            existingGoal = nil
        case 7:
            let ac = UIAlertController(title: "Delete Goal", message: "Are you sure you want to delete this goal? All the related entries and the metrics will be deleted as well.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteGoal))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
        case 8:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "EditGoal") as? EditViewController {
                if let existingGoal = existingGoal {
                    vc.goalDetail = existingGoal
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            print("default")
        }
    }
    
    func deleteGoal(arg: UIAlertAction) {
        if let existingGoal = existingGoal {
            self.context.delete(existingGoal)
            self.existingGoal = nil
            self.saveContext()
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
                doneButton.frame = CGRect(x: 0, y: view.frame.size.height - CGFloat(tabBarHeight + 50), width: view.frame.size.width, height: 50)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - keyboardViewEndFrame.height - 50, width: view.frame.size.width, height: 50)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let text = textField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let commentText = commentTextView.text, !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = UIColor(red: 254/255, green: 211/255, blue: 48/255, alpha: 1.0)
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .systemGray3
        }
    }
    
    func openPhoto(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let ac = UIAlertController(title: "Photo Library Not Available", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
    }
    
    func openCamera(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let ac = UIAlertController(title: "Camera Not Available", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func alertClose(_ alert:UIAlertController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePList() {
        let dateString = dateForPlist(date: Date())
        
        if let url = pListURL() {
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    let dataContent = try Data(contentsOf: url)
                    if var dict = try PropertyListSerialization.propertyList(from: dataContent, format: nil) as? [String: [String: Int]] {
                        if let oldGoalTitle = existingGoal?.title {
                            if let oldGoalData = dict[oldGoalTitle] {
                                if var count = oldGoalData[dateString] {
                                    count += 1
                                    dict.updateValue([dateString: count], forKey: oldGoalTitle)
                                    write(dictionary: dict)
                                } else {
                                    dict.updateValue([dateString: 1], forKey: oldGoalTitle)
                                    write(dictionary: dict)
                                }
                            } else {
                                dict[oldGoalTitle] = [dateString: 1]
                                write(dictionary: dict)
                            }
                        } else {
                            if let newGoalTitle = goalTextField.text {
                                dict.updateValue([dateString: 1], forKey: newGoalTitle)
                                write(dictionary: dict)
                            } else {
                                let ac = UIAlertController(title: "Error", message: "The goal title cannot be empty", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                present(ac, animated: true)
                                return
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                if let oldGoalTitle = existingGoal?.title {
                    write(dictionary: [oldGoalTitle: [dateString: 1]])
                } else if let newGoalTitle = goalTextField.text {
                    write(dictionary: [newGoalTitle: [dateString: 1]])
                }
            }
        }
        
        if let mainVC = (tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? ViewController {
            let dataImporter = DataImporter(goalTitle: nil)
            mainVC.data = dataImporter.loadData(goalTitle: nil)
        }
        
//        let vc = (tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? DetailTableViewController
        
    }
    
}

extension NewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension NewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath!)
        }
        imagePathString = imageName
        
        cameraButton.alpha = 0
        cameraButton.setImage(image, for: .normal)
        
        if image.size.width > image.size.height {
            cameraButton.imageView?.contentMode = .scaleAspectFit
        } else {
            cameraButton.imageView?.contentMode = .scaleAspectFill
        }
        
        dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.cameraButton.alpha = 1
        })
    }
}

extension Sequence where Element: Hashable {
    /// Returns true if no element is equal to any other element.
    func isDistinct() -> Bool {
        var set = Set<Element>()
        for e in self {
            if set.insert(e).inserted == false { return false }
        }
        return true
    }
}


