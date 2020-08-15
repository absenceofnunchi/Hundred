//
//  DataImporter.swift
//  Hundred
//
//  Created by jc on 2020-08-11.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class DataImporter {
    lazy var data: [String: UIColor] = loadData()
    
    func loadData() -> [String: UIColor] {
        guard let contributionData = readHeatmap() else { return [:] }
        return mapColours(contributionData: contributionData)
    }
    
    func mapColours(contributionData: [String: Int]) -> [String: UIColor]{
        return contributionData.mapValues { (colorIndex) -> UIColor in
            switch colorIndex {
            case 0:
                return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            case 1:
                return UIColor(red: 204/255, green: 204/255, blue: 255/255, alpha: 1.0)
            case 2:
                return UIColor(red: 153/255, green: 153/255, blue: 255/255, alpha: 1.0)
            case 3:
                return UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
            case 4:
                return UIColor(red: 51/255, green: 51/255, blue: 255/255, alpha: 1.0)
            case 5:
                return UIColor(red: 0, green: 0, blue: 255/255, alpha: 1.0)
            case 6:
                return UIColor(red: 0, green: 0, blue: 204/255, alpha: 1.0)
            case 7:
                return UIColor(red: 0, green: 0, blue: 153/255, alpha: 1.0)
            case 8:
                return UIColor(red: 0, green: 0, blue: 102/255, alpha: 1.0)
            case 9:
                return UIColor(red: 0, green: 0, blue: 51/255, alpha: 1.0)
            default:
                return UIColor(red: 0, green: 0, blue: 15/255, alpha: 1.0)
            }
        }
    }
    
    private func readHeatmap() -> [String: Int]? {
        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Heatmap.plist") else { return nil  }
        if let dict = NSDictionary(contentsOf: url) as? [String: [String: Int]] {
            return dict.flatMap { $0.value }.reduce(into: [:]) { $0[$1.key, default: 0] += $1.value }
        } else {
            return ["0": 1]
        }
    }
}
