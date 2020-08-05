//
//  NewEntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-01.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var existingGoal: Goal?
    var imagePathString: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var firstMetricLabel: UILabel!
    @IBOutlet weak var secondMetricLabel: UILabel!
    @IBOutlet weak var firstMetricTextField: UITextField!
    @IBOutlet weak var secondMetricTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
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
                
                let formatter = NumberFormatter()
                formatter.generatesDecimalNumbers = true
                
                if let firstMetric = firstMetricTextField.text {
                    progress.firstMetric = formatter.number(from: firstMetric) as? NSDecimalNumber ?? 0
                }
                
                if let secondMetric = secondMetricTextField.text {
                    progress.firstMetric = formatter.number(from: secondMetric) as? NSDecimalNumber ?? 0
                }
                
                progress.image = imagePathString
                
                var goalForProgress: Goal!
                
                let goalRequest = Goal.createFetchRequest()
                goalRequest.predicate = NSPredicate(format: "title == %@", titleLabel.text!)
                
                if let goal = try? self.context.fetch(goalRequest) {
                    if goal.count > 0 {
                        goalForProgress = goal[0]
                    }
                }
                
                goalForProgress.progress.insert(progress)
                savePList()
                saveContext()
                
                
                
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
        }
        
        imagePathString = imageName
        
        dismiss(animated: true)
    }
    
    func saveContext() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                print("An error occurred while saving: \(error.localizedDescription)")
            }
        }
    }
    
    func pListURL() -> URL? {
        guard let result = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Heatmap.plist") else { return nil }
        return result
    }
    
    func savePList() {
        var data: [String: Int] = [:]
        
        if let url = pListURL() {
            do {
                let dataContent = try Data(contentsOf: url)
                if let dict = try PropertyListSerialization.propertyList(from: dataContent, format: nil) as? [String: Int] {
                    print("dict: \(dict)")
                    data = dict
                }
            } catch {
                print(error)
            }
        }
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dateString = "\(year).\(month).\(day)"
        if var count = data[dateString] {
            count += 1
            data[dateString] = count
        } else {
            data[dateString] = 1
        }
        
        if let path = pListURL() {
            do {
                let plistData = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
                try plistData.write(to: path)
            } catch {
                print(error)
            }
        }
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
