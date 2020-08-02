//
//  NewEntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-01.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var firstMetricLabel: UILabel!
    @IBOutlet weak var secondMetricLabel: UILabel!
    @IBOutlet weak var firstMetricTextField: UITextField!
    @IBOutlet weak var secondMetricTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var existingGoal: Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Entry"
        
        initializeHideKeyboard()
        
        let addImageButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addFromCamera))
        navigationItem.leftBarButtonItems = [addImageButton, cameraButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareProgress))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if existingGoal != nil {
            
            titleLabel.text = existingGoal?.title
            descriptionLabel.text = existingGoal?.detail
            
            if existingGoal?.metrics == nil {
                firstMetricLabel.isHidden = true
                firstMetricTextField.isHidden = true
                secondMetricLabel.isHidden = true
                secondMetricTextField.isHidden = true
            } else if existingGoal?.metrics?.count == 1 {
                firstMetricLabel.text = existingGoal?.metrics?[0]
                firstMetricLabel.isHidden = false
                
                firstMetricTextField.isHidden = false
                
                secondMetricLabel.isHidden = true
                secondMetricTextField.isHidden = true
            } else if existingGoal?.metrics?.count == 2 {
                firstMetricLabel.text = existingGoal?.metrics?[0]
                firstMetricLabel.isHidden = false
                firstMetricTextField.isHidden = false
                
                secondMetricLabel.text = existingGoal?.metrics?[1]
                secondMetricLabel.isHidden = false
                secondMetricTextField.isHidden = false
            }
        } else {
            titleLabel.text = nil
            descriptionLabel.text = nil
            firstMetricLabel.text = nil
            secondMetricLabel.text = nil
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let button = sender.currentTitle {
            switch button {
            case "New Goal":
                existingGoal = nil
                self.viewDidAppear(true)
            case "Existing Goal":
                if let vc = storyboard?.instantiateViewController(withIdentifier: "ExistingGoalsMenu") as? ExistingGoalsMenuTableViewController {
                    vc.isDismissed = { [weak self] goal in
                        self?.existingGoal = goal
                    }
                    navigationController?.pushViewController(vc, animated: true)
                }
            case "Submit":
                let progress = Progress(context: self.context)
                progress.date = Date()
                progress.comment = commentTextView.text
                
                if let firstMetric = firstMetricTextField.text {
                    progress.firstMetric = Double(firstMetric) ?? 0
                }
                
                if let secondMetric = secondMetricTextField.text {
                    progress.firstMetric = Double(secondMetric) ?? 0
                }
                
//                progress.image
                
            default:
                break
            }
        }
    }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            print("imagePath: \(imagePath)")
        }
        
        
        
        dismiss(animated: true)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
    
    @objc func addImage() {
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

    @objc func addFromCamera() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true)
        } else {
            let ac = UIAlertController(title: "Camera Not Available", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func shareProgress() {
        
    }
}
