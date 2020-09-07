//
//  EditEntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-23.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class EditEntryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var progress: Progress!
    var imagePathString: URL?
    var imageBinary: UIImage?
    var imageName: String!
    var delegate: CallBackDelegate? = nil
    
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
            imagePathString = getDocumentsDirectory().appendingPathComponent(image)
            if imagePathString != nil {
                if let data = try? Data(contentsOf: imagePathString!) {
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
        //        textView.textColor = UIColor.gray
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        
        return textView
    }()
    
    var locationText: String? {
        didSet {
            if let locationText = locationText, !locationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                locationLabel.text = locationText
                locationLabel.alpha = 1
            } else {
                locationLabel.alpha = 0
            }
        }
    }
    var locationLabel = CustomLabel()
    
    var location: CLLocationCoordinate2D?
    //    var location: CLLocationCoordinate2D? {
    //        didSet {
    //            if location != nil {
    //                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
    //                    self.locationLabel.alpha = 1
    //                })
    //            } else {
    //                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
    //                    self.locationLabel.alpha = 0
    //                })
    //            }
    //
    //        }
    //    }
    
    var locationPlusButton: UIButton!
    var locationMinusButton: UIButton!
    var mapPanel = UIView()
    
    lazy var metricStackView: UIStackView = {
        let mStackView = UIStackView()
        mStackView.axis = .vertical
        mStackView.alignment = .fill
        mStackView.distribution = .equalSpacing
        mStackView.spacing = 10
        
        if let metrics = progress.goal.metrics {
            if progress.metric.count > 0 {
                for metric in progress.metric {
                    displayMetrics(metricString: nil, metric: metric, mStackView: mStackView)
                }
            } else {
                // this is in case the metrics exist, but no entry was made
                for metric in metrics {
                    displayMetrics(metricString: metric, metric: nil, mStackView: mStackView)
                }
            }
        }
        
        return mStackView
    }()
    
    func displayMetrics(metricString: String?, metric: Metric?, mStackView: UIStackView) {
        let metricView = UIView()
        let metricLabel = UILabel()
        
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
        metricTextField.textAlignment = .center
        metricTextField.font = UIFont.preferredFont(forTextStyle: .body)
        metricTextField.textColor = UIColor.gray
        metricTextField.borderStyle = .roundedRect
        metricTextField.layer.borderColor = borderColor.withAlphaComponent(0.2).cgColor
        metricView.addSubview(metricTextField)
        
        if let metric = metric {
            metricLabel.text = metric.unit
            metricTextField.text = String(describing: metric.value)
        } else if let metricString = metricString {
            metricLabel.text = metricString
            metricTextField.text = ""
        }
        
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
    
    lazy var doneButton: UIButton = {
        let dButton = UIButton()
        dButton.setTitle("Done", for: .normal)
        dButton.layer.cornerRadius = 0
        
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            dButton.frame = CGRect(x: 0, y: view.frame.size.height - CGFloat(tabBarHeight + 50), width: view.frame.size.width, height: 50)
        }
        dButton.backgroundColor = .systemYellow
        dButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        dButton.tag = 2
        dButton.addTarget(self, action: #selector(buttonPressed) , for: .touchUpInside)
        
        return dButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPlusButton = createButton(title: nil, image: "plus.square.fill", cornerRadius: 0, color: UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 30, tag: 3)
        locationMinusButton = createButton(title: nil, image: "minus.square.fill", cornerRadius: 0, color: UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0), size: 30, tag: 4)
        
        initializeHideKeyboard()
        configureView()
        setConstraints()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        navigationController?.delegate = self
        
        //        locationLabel.text = labelText
    }
    
    func configureView() {
        stackView.addArrangedSubview(imageButton)
        stackView.setCustomSpacing(50, after: imageButton)
        
        addHeader(text: "Comment", stackView: stackView)
        stackView.addArrangedSubview(commentTextView)
        stackView.setCustomSpacing(50, after: commentTextView)
        
        addHeader(text: "Location", stackView: stackView)
        mapPanel.addSubview(locationPlusButton)
        mapPanel.addSubview(locationMinusButton)
        stackView.addArrangedSubview(mapPanel)
        
        locationLabel.textAlignment = .left
        locationLabel.font = UIFont.preferredFont(forTextStyle: .body)
        customShadowBorder(for: locationLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.setCustomSpacing(50, after: locationLabel)
        
        addHeader(text: "Metrics", stackView: stackView)
        stackView.addArrangedSubview(metricStackView)
        stackView.setCustomSpacing(50, after: metricStackView)
        
        view.addSubview(doneButton)
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
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapPanel.translatesAutoresizingMaskIntoConstraints = false
        mapPanel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        locationPlusButton.translatesAutoresizingMaskIntoConstraints = false
        locationPlusButton.trailingAnchor.constraint(equalTo: locationMinusButton.leadingAnchor, constant: -15).isActive = true
        
        locationMinusButton.translatesAutoresizingMaskIntoConstraints = false
        locationMinusButton.trailingAnchor.constraint(equalTo: mapPanel.trailingAnchor).isActive = true
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
            
            if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
                doneButton.frame = CGRect(x: 0, y: view.frame.size.height - CGFloat(tabBarHeight + 50), width: view.frame.size.width, height: 50)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - keyboardViewEndFrame.height - 50, width: view.frame.size.width, height: 50)
        }
        
        //        if notification.name == UIResponder.keyboardWillHideNotification {
        //            scrollView.contentInset = .zero
        //            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        //        } else {
        //            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        //            doneButton.frame = CGRect(x: 0, y: view.frame.size.height - keyboardViewEndFrame.height - 50, width: view.frame.size.width, height: 50)
        //        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            let ac = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhoto))
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
            if imageName != nil || progress.image != nil {
                ac.addAction(UIAlertAction(title: "No Image", style: .default, handler: { action in
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                    let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                    self.imageButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                    self.imageButton.setImage(uiImage, for: .normal)
                }))
                self.imagePathString = nil
                //                self.progress.image = nilz
                self.imageName = nil
            }
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
        case 2:
            // completed editing
//            let progressRequest = Progress.createFetchRequest()
            let progressRequest = NSFetchRequest<Progress>(entityName: "Progress")
            let progressPredicate = NSPredicate(format: "id == %@", progress.id as CVarArg)
            progressRequest.predicate = progressPredicate
            if let fetchedProgress = try? self.context.fetch(progressRequest) {
                if fetchedProgress.count > 0 {
                    progress = fetchedProgress.first
                    // setting a new image
                    if let imagePathString = imagePathString, let imageBinary = imageBinary {
                        print("imagePathString is not nil: \(imagePathString)")
                        
                        // write the new image to disk
                        if let jpegData = imageBinary.jpegData(compressionQuality: 0.8) {
                            try? jpegData.write(to: imagePathString)
                        }
                        
                        // delete the previous image from the directory
                        if let fetchedImagePath = fetchedProgress.first?.image {
                            print("fetchedImagePath1: \(fetchedImagePath)")
                            let imagePath = getDocumentsDirectory().appendingPathComponent(fetchedImagePath)
                            do {
                                print("image deleted: \(imagePath)")
                                try FileManager.default.removeItem(at: imagePath)
                            } catch {
                                print("The image could not be deleted from the directory: \(error.localizedDescription)")
                            }
                        }
                        
                        progress?.image = imageName!
                        
                        // if there's no newly selected image && no image pre-existing image
                    } else if imagePathString == nil && progress.image == nil {
                        progress?.image = nil
                        
                        // getting rid of the pre-existing image without setting a new image
                    } else if imagePathString == nil && progress.image != nil {
                        let imagePath = getDocumentsDirectory().appendingPathComponent(progress.image!)
                        do {
                            print("image deleted: \(imagePath)")
                            try FileManager.default.removeItem(at: imagePath)
                        } catch {
                            print("The image could not be deleted from the directory: \(error.localizedDescription)")
                        }
                        
                        progress.image = nil
                    }
                    
                    progress?.comment = commentTextView.text
                    
                    if let location = location {
                        progress?.longitude = NSDecimalNumber(value: location.longitude)
                        progress?.latitude = NSDecimalNumber(value: location.latitude)
                    }
                    
                    if let metricsArr = progress.goal.metrics, metricsArr.count > 0 {
                        // update the existing metric pertaining to this instance of progress
                        if let metrics = progress?.metric, metrics.count > 0 {
                            print("metrics: \(metrics)")
                            
                            for metric in metrics {
                                let metricSubview = metricStackView.arrangedSubviews.first { (metricSubview) -> Bool in
                                    let label = metricSubview.subviews[0] as! UILabel
                                    
                                    return label.text! == metric.unit
                                }
                                print("metricSubview: \(metricSubview)")
                                
                                if let metricSubview = metricSubview {
                                    let textField = metricSubview.subviews[1] as! UITextField
                                    let formatter = NumberFormatter()
                                    formatter.generatesDecimalNumbers = true
                                    let result = formatter.number(from: textField.text ?? "0") as? NSDecimalNumber ?? 0
                                    print("results: \(result)")
                                    metric.value = result
                                }
                            }
                        } else {
                            // if the metrics have been created, but no instance of Metric has been created
                            var metricDict: [String: String] = [:]
                            for metricPair in metricStackView.arrangedSubviews {
                                print("metricPair: \(metricPair)")
                                let unitLabel = metricPair.subviews[0] as! UILabel
                                let valueTextField = metricPair.subviews[1] as! UITextField
                                if let textContent = unitLabel.text, let valueTextContent = valueTextField.text {
                                    let trimmedValue = valueTextContent.trimmingCharacters(in: .whitespacesAndNewlines)
                                    print("trimmedValue: \(trimmedValue)")
                                    metricDict.updateValue(trimmedValue, forKey: textContent)
                                }
                            }
                            
                            // create an array of instances of Metric
                            var metricArr: [Metric] = []
                            for singleMetricPair in metricDict {
                                let newMetric = Metric(context: self.context)
                                newMetric.date = Date()
                                newMetric.unit = singleMetricPair.key
                                newMetric.id = UUID()
                                newMetric.value = stringToDecimal(string: singleMetricPair.value)
                                print("newMetric: \(newMetric)")
                                
                                metricArr.append(newMetric)
                            }
                            
                            // add the new instances to progress before saving
                            for item in metricArr {
                                print("item: \(item)")
                                
                                progress.metric.insert(item)
                                progress.goal.goalToMetric.insert(item)
                            }
                        }
                    }
                    print("final: \(progress)")
                    
                    self.saveContext()
                    
                    if let mainVC = (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? ViewController {
                        let dataImporter = DataImporter(goalTitle: nil)
                        mainVC.data = dataImporter.loadData(goalTitle: nil)
                        
                        let mainDataImporter = MainDataImporter()
                        mainVC.goals = mainDataImporter.loadData()
                    }
                    
                    if previousViewController is EntryViewController {
                        delegate?.callBack(value: progress, location: location, locationLabel: locationLabel.text)
                    }
                    
                    _ = navigationController?.popViewController(animated: true)
                }
            }
        case 3:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Map") as? MapViewController {
                vc.editPlacemarkDelegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
        case 4:
            location = nil
            locationText = ""
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
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
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
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(ac, animated: true)
        }
    }
    
    @objc func alertClose(_ alert:UIAlertController) {
        self.dismiss(animated: true, completion: nil)
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
}

extension EditEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        imageBinary = image
        imageName = UUID().uuidString
        imagePathString = getDocumentsDirectory().appendingPathComponent(imageName)
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
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? DetailTableViewController)?.tableView.reloadData()
    }
}

extension EditEntryViewController: HandleLocation {
    func fetchPlacemark(placemark: MKPlacemark) {
        print("placemark \(placemark)")
        locationText = placemark.title
        location = placemark.coordinate
    }
}
