//
//  Style.swift
//  Hundred
//
//  Created by jc on 2020-08-18.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

extension UIViewController {
    func addHeader(text: String, stackView: UIStackView) {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
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
}
