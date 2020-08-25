//
//  EditEntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-23.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var progress: Progress!
    var imagePathString: String?
    var delegate: CallBackDelegate?
    
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
    
    lazy var imageButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        
        if let image = progress.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(image)
            if let data = try? Data(contentsOf: imagePath) {
                if let uiImage = UIImage(data: data) {
                    button.setImage(uiImage, for: .normal)
                    if uiImage.size.width > uiImage.size.height {
                        button.imageView?.contentMode = .scaleAspectFit
                    } else {
                        button.imageView?.contentMode = .scaleAspectFill
                    }
                }
            } else {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                
                button.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                button.setImage(uiImage, for: .normal)
            }
        } else {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
            let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
            
            button.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
            button.setImage(uiImage, for: .normal)
        }
        
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.text = progress.comment
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.gray
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        
        return textView
    }()
    
    lazy var metricStackView: UIStackView = {
        let mStackView = UIStackView()
        mStackView.axis = .vertical
        mStackView.alignment = .fill
        mStackView.distribution = .equalSpacing
        mStackView.spacing = 10
        
        for metric in progress.metric {
            let metricView = UIView()
            let metricLabel = UILabel()
            metricLabel.text = metric.unit
            metricLabel.textAlignment = .center
            metricLabel.font = UIFont.preferredFont(forTextStyle: .body)
            metricLabel.textColor = UIColor.gray
            let borderColor = UIColor.gray
            metricLabel.layer.borderColor = borderColor.withAlphaComponent(0.4).cgColor
            metricLabel.layer.borderWidth = 1
            metricLabel.layer.masksToBounds = true
            metricLabel.layer.cornerRadius = 5
            metricView.addSubview(metricLabel)
            
            let metricTextField = UITextField()
            metricTextField.keyboardType = UIKeyboardType.decimalPad
            metricTextField.text = String(describing: metric.value)
            metricTextField.textAlignment = .center
            metricTextField.font = UIFont.preferredFont(forTextStyle: .body)
            metricTextField.textColor = UIColor.gray
            metricTextField.borderStyle = .roundedRect
            metricTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
            metricView.addSubview(metricTextField)
            
            mStackView.addArrangedSubview(metricView)
            
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
        dButton.tag = 2
        dButton.addTarget(self, action: #selector(buttonPressed) , for: .touchUpInside)
        
        return dButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        configureView()
        setConstraints()
        
        view.addSubview(doneButton)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        navigationController?.delegate = self
    }
    
    func configureView() {
        stackView.addArrangedSubview(imageButton)
        stackView.setCustomSpacing(50, after: imageButton)
        
        addHeader(text: "Comment", stackView: stackView)
        stackView.addArrangedSubview(commentTextView)
        stackView.setCustomSpacing(50, after: commentTextView)
        
        stackView.addArrangedSubview(metricStackView)
        stackView.setCustomSpacing(50, after: metricStackView)
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
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
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            let ac = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhoto))
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
            if imagePathString != nil || progress.image != nil {
                ac.addAction(UIAlertAction(title: "No Image", style: .default, handler: { action in
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                    let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                    self.imageButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                    self.imageButton.setImage(uiImage, for: .normal)
                }))
                self.imagePathString = nil
                self.progress.image = nil
            }
            present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
        case 2:
            let progressRequest = Progress.createFetchRequest()
            let goalTitlePredicate = NSPredicate(format: "goal.title == %@", progress.goal.title)
            let datePredicate = NSPredicate(format: "date == %@", progress.date as CVarArg)
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [goalTitlePredicate, datePredicate])
            progressRequest.predicate = andPredicate
            if let fetchedProgress = try? self.context.fetch(progressRequest) {
                if fetchedProgress.count > 0 {
                    progress = fetchedProgress.first
                    if imagePathString != nil {
                        progress?.image = imagePathString
                    } else if imagePathString == nil && progress.image == nil {
                        progress?.image = nil
                    }
                    
                    progress?.comment = commentTextView.text
                                        
                    if let metrics = progress?.metric {
                        for metric in metrics {
                            let metricSubview = metricStackView.arrangedSubviews.first { (metricSubview) -> Bool in
                                let label = metricSubview.subviews[0] as! UILabel

                                return label.text! == metric.unit
                            }
                            
                            if let metricSubview = metricSubview {
                                let textField = metricSubview.subviews[1] as! UITextField
                                let formatter = NumberFormatter()
                                formatter.generatesDecimalNumbers = true
                                metric.value = formatter.number(from: textField.text ?? "0") as? NSDecimalNumber ?? 0
                            }
                        }
                    }
                    
                    self.saveContext()
                    
                    delegate?.callBack(value: progress)
                    _ = navigationController?.popViewController(animated: true)
                }
            }
        default:
            print("default")
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
    
}

extension EditEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        imagePathString = imageName
        
        imageButton.alpha = 0
        imageButton.setImage(image, for: .normal)
        
        if image.size.width > image.size.height {
            imageButton.imageView?.contentMode = .scaleAspectFit
        } else {
            imageButton.imageView?.contentMode = .scaleAspectFill
        }
        
        dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageButton.alpha = 1
        })
    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        print("progress: \(progress)")
//        (viewController as? EntryViewController)?.EntryViewControllerDelegate?.progress = progress
//    }
}
