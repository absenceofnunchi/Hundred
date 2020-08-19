//
//  NewViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-16.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
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
    
    var goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Goal Title"
        textField.borderStyle = .roundedRect
        let borderColor = UIColor.gray
        textField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        return textField
    }()
    
    lazy var goalButton: UIButton = {
        let gButton = UIButton()
        gButton.setTitle("Get existing goals", for: .normal)
        gButton.tag = 5
        gButton.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
        gButton.layer.cornerRadius = 10
        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        return gButton
    }()
    
    var existingGoal: Goal? {
        didSet {
            if existingGoal == nil {
                goalButton.setTitle("Get existing goals", for: .normal)
                goalButton.tag = 5
            } else {
                goalButton.setTitle("Start a new goal", for: .normal)
                goalButton.tag = 6
            }
        }
    }
    
    var commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.text = "Comment"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        
        return textView
    }()
    
    var plusButton: UIButton!
    var minusButton: UIButton!
    var metricPanel = UIView()
    //    lazy var metricPanel: UIView = {
    //        let metricView = UIView()
    //        metricView.addSubview(plusButton)
    //        metricView.addSubview(minusButton)
    //        return metricView
    //    }()
    
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
        dButton.layer.cornerRadius = 0
        dButton.backgroundColor = .systemYellow
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            dButton.frame = CGRect(x: 0, y: view.frame.size.height - CGFloat(tabBarHeight + 50), width: view.frame.size.width, height: 50)
        }
        dButton.tag = 4
        return dButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        initializeHideKeyboard()
        
        
        plusButton = createButton(title: nil, image: "plus.square.fill", cornerRadius: 0, color: UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 30, tag: 2)
        minusButton = createButton(title: nil, image: "minus.square.fill", cornerRadius: 0, color: UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 30, tag: 3)
        
        configureStackView()
        
        view.addSubview(doneButton)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if existingGoal == nil {
            metricPanel.addSubview(plusButton)
            metricPanel.addSubview(minusButton)
            stackView.addArrangedSubview(metricPanel)
            stackView.addArrangedSubview(metricStackView)
            stackView.setCustomSpacing(60, after: metricStackView)
            setConstraints()
        } else {
            UIView.animate(withDuration: 1.5, animations: {
                self.plusButton.alpha = 0
                self.minusButton.alpha = 0
            })
            plusButton.removeFromSuperview()
            minusButton.removeFromSuperview()
            stackView.removeArrangedSubview(metricPanel)
            
            for singleSubview in metricStackView.arrangedSubviews {
                metricStackView.removeArrangedSubview(singleSubview)
                singleSubview.removeFromSuperview()
            }
            
            if let existingGoalMetrics = existingGoal?.metrics {
                for metric in existingGoalMetrics {
                    
                    
                    let metricView = UIView()
                    metricView.alpha = 0
                    
                    let metricLabel = UILabel()
                    metricLabel.text = metric
                    metricLabel.textAlignment = .center
                    let borderColor = UIColor.gray
                    metricLabel.layer.borderColor = borderColor.withAlphaComponent(0.4).cgColor
                    metricLabel.layer.borderWidth = 1
                    metricLabel.layer.masksToBounds = true
                    metricLabel.layer.cornerRadius = 5
                    metricView.addSubview(metricLabel)
                    
                    let metricTextField = UITextField()
                    metricTextField.placeholder = "Metrics"
                    metricTextField.textAlignment = .center
                    metricTextField.borderStyle = .roundedRect
                    metricTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
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
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        metricView.alpha = 1
                    })
                }
            }
        }
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(cameraButton)
        stackView.setCustomSpacing(40, after: cameraButton)
        
        addHeader(text: "Goal Title", stackView: stackView)
        stackView.addArrangedSubview(goalTextField)
        stackView.addArrangedSubview(goalButton)
        stackView.setCustomSpacing(60, after: goalButton)
        
        addHeader(text: "Comment", stackView: stackView)
        stackView.addArrangedSubview(commentTextView)
        stackView.setCustomSpacing(60, after: commentTextView)
        
        addHeader(text: "Metrics", stackView: stackView)
        //        metricPanel.addSubview(plusButton)
        //        metricPanel.addSubview(minusButton)
        //        stackView.addArrangedSubview(metricPanel)
        //        stackView.addArrangedSubview(metricStackView)
        //        stackView.setCustomSpacing(60, after: metricStackView)
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalButton.translatesAutoresizingMaskIntoConstraints = false
        goalButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
            present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
            
        case 2:
            let metricView = UIView()
            metricView.alpha = 0
            
            let metricUnitTextField = UITextField()
            metricUnitTextField.placeholder = "Metrics Unit"
            metricUnitTextField.textAlignment = .center
            metricUnitTextField.borderStyle = .roundedRect
            let borderColor = UIColor.gray
            metricUnitTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            metricView.addSubview(metricUnitTextField)
            
            let metricTextField = UITextField()
            metricTextField.placeholder = "Metrics"
            metricTextField.textAlignment = .center
            metricTextField.borderStyle = .roundedRect
            metricTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            metricView.addSubview(metricTextField)
            
            metricView.translatesAutoresizingMaskIntoConstraints = false
            metricStackView.addArrangedSubview(metricView)
            UIView.animate(withDuration: 1, animations: {
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
                UIView.animate(withDuration: 1, animations: {
                    metricSubview.alpha = 0
                }, completion: { finished in
                    self.metricStackView.removeArrangedSubview(metricSubview)
                    metricSubview.removeFromSuperview()
                })
            }
            
        case 4:
            print("4")
            
        case 5:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ExistingGoalsMenu") as? ExistingGoalsMenuTableViewController {
                vc.isDismissed = { [weak self] goal in
                    self?.existingGoal = goal
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        case 6:
            for singleSubview in metricStackView.arrangedSubviews {
                UIView.animate(withDuration: 1.5, animations: {
                    singleSubview.alpha = 0
                })
                metricStackView.removeArrangedSubview(singleSubview)
                singleSubview.removeFromSuperview()
            }
            
            stackView.removeArrangedSubview(metricStackView)
            metricStackView.removeFromSuperview()
                        
            UIView.animate(withDuration: 1.5, animations: {
                self.plusButton.alpha = 1
                self.minusButton.alpha = 1
            })
            metricPanel.addSubview(plusButton)
            metricPanel.addSubview(minusButton)
            stackView.addArrangedSubview(metricPanel)
            stackView.addArrangedSubview(metricStackView)
            stackView.setCustomSpacing(60, after: metricStackView)
            setConstraints()
            
            goalButton.setTitle("Get existing goals", for: .normal)
            goalButton.tag = 5
        
            existingGoal = nil
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
            if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
                doneButton.frame = CGRect(x: 0, y: view.frame.size.height - CGFloat(tabBarHeight + 50), width: view.frame.size.width, height: 50)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - keyboardViewEndFrame.height - 50, width: view.frame.size.width, height: 50)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
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
        cameraButton.alpha = 0
        dismiss(animated: true, completion: nil)
        cameraButton.setImage(image, for: .normal)
        
        if image.size.width > image.size.height {
            cameraButton.imageView?.contentMode = .scaleAspectFit
        } else {
            cameraButton.imageView?.contentMode = .scaleAspectFill
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.cameraButton.alpha = 1
        })
    }
}



