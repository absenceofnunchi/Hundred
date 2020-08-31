//
//  Style.swift
//  Hundred
//
//  Created by jc on 2020-08-18.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addCard<T: UIView>(text: String, subItem: T, stackView: UIStackView, containerHeight: CGFloat? = 20, bottomSpacing: CGFloat? = 60) {
        let container = UIView()
        customShadowBorder(for: container)
        stackView.addArrangedSubview(container)
        if let height = containerHeight {
            container.translatesAutoresizingMaskIntoConstraints = false
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        }
        
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .left
        
        container.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9).isActive = true
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        
        container.addSubview(subItem)
        
        subItem.backgroundColor = .white
        subItem.translatesAutoresizingMaskIntoConstraints = false
        subItem.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
        subItem.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.8).isActive = true
        subItem.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30).isActive = true

        subItem.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        if let bottomSpacing = bottomSpacing {
            stackView.setCustomSpacing(bottomSpacing, after: container)
        }
    }

    
    func addHeader(text: String, stackView: UIStackView) {
        let label = UILabel()
        label.text = text
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.addArrangedSubview(label)
        stackView.setCustomSpacing(10, after: label)

        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
        l.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(l)

        stackView.setCustomSpacing(20, after: l)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func pListURL() -> URL? {
        guard let result = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Heatmap.plist") else { return nil  }
        return result
    }
    
    func write(dictionary: [String: [String: Int]]) {
        if let url = pListURL() {
            do {
                let plistData = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
                try plistData.write(to: url)
            } catch {
                print(error)
            }
        }
    }
    
    func dateForPlist(date: Date) -> String {
           let calendar = Calendar.current
           let year = calendar.component(.year, from: date)
           let month = calendar.component(.month, from: date)
           let day = calendar.component(.day, from: date)
           return "\(year).\(month).\(day)"
    }
    
    func customShadowBorder<T: UIView>(for object: T) {
        let borderColor = UIColor.gray
        object.layer.borderWidth = 1
        object.layer.masksToBounds = false
        object.layer.cornerRadius = 7.0;
        object.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowOffset = CGSize(width: 0, height: 0)
        object.layer.shadowOpacity = 0.2
        object.layer.shadowRadius = 4.0
        object.layer.backgroundColor = UIColor.white.cgColor
    }

    func dayVariance(date: Date, value: Int) -> Date {
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding: .day, value: -1, to: date) {
            var components = calendar.dateComponents([.day, .year, .month, .hour, .minute, .second], from: tomorrow)
            components.hour = 23
            components.minute = 59
            components.second = 59
            
            guard let convertedDate = calendar.date(from: components) else {
                return date
            }
            
            return convertedDate
        }
        
        return date
    }
    
    
    func showSpinner<T: UIView>(container: T) {
        grayBackground = UIView(frame: self.view.bounds)
        grayBackground?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        grayBackground?.layer.cornerRadius = 10
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        grayBackground?.addSubview(activityIndicator)
        self.view.addSubview(grayBackground!)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        grayBackground?.translatesAutoresizingMaskIntoConstraints = false
        grayBackground?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        grayBackground?.heightAnchor.constraint(equalToConstant: 150).isActive = true
        grayBackground?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        grayBackground?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func removeSpinner() {
        grayBackground?.removeFromSuperview()
        grayBackground = nil
    }
    
}

fileprivate var grayBackground: UIView?


class CustomTextField: UITextField {
    let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let cells = self.visibleCells
        var delayCounter = 0
        
        for cell in cells {
            cell.alpha = 0
//            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.5, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }, completion: nil)
            delayCounter += 1
        }
    }
}
