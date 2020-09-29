//
//  DataImporter.swift
//  Hundred
//
//  Created by jc on 2020-08-11.
//  Copyright © 2020 J. All rights reserved.
//

import CalendarHeatmap

struct DataImporter {
    lazy var data: [String: UIColor] = loadData(goalTitle: self.goalTitle)
    var goalTitle: String?
    
    init(goalTitle: String?) {
        self.goalTitle  = goalTitle
    }
    
    func loadData(goalTitle: String?) -> [String: UIColor] {
        guard let contributionData = readHeatmap(goalTitle: goalTitle) else { return [:] }
        if goalTitle != nil {
            return singleEntryMapColours(contributionData: contributionData)
        } else {
            return mapColours(contributionData: contributionData)
        }
    }
    
    //    private func readHeatmap(goalTitle: String?) -> [String: Int]? {
    //        print("goalTitle in readHeatmap: \(goalTitle)")
    //        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Heatmap.plist") else { return nil  }
    //        if let dict = NSDictionary(contentsOf: url) as? [String: [String: Int]] {
    ////            return dict.flatMap { $0.value }.reduce(into: [:]) { $0[$1.key, default: 0] += $1.value }
    //            return .init(dict.flatMap(\.value), uniquingKeysWith: +)
    //        } else {
    //            return ["0": 1]
    //        }
    //    }
    
    // [goalTitle: [date: count]]
    private func readHeatmap(goalTitle: String?) -> [String: Int]? {
        let keyValStore = NSUbiquitousKeyValueStore.default
        if let dict = keyValStore.dictionary(forKey: "heatmap") as? [String : [String : Int] ] {
//            dict.removeAll()
//            keyValStore.set(dict, forKey: "heatmap")
//            keyValStore.synchronize()
            if let goalTitle = goalTitle {
                if let newDict = dict[goalTitle] {
                    return newDict
                } else {
                    return nil
                }
            } else {
                return .init(dict.flatMap(\.value), uniquingKeysWith: +)
            }
        } else {
            return nil
        }
    }
    
    private func mapColours(contributionData: [String: Int]) -> [String: UIColor]{
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
    
    private func singleEntryMapColours(contributionData: [String: Int]) -> [String: UIColor] {
        return contributionData.mapValues { (colorIndex) -> UIColor in
            switch colorIndex {
            case 0:
//                return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                return .darkGray
            case 1:
                return UIColor(red: 255/255, green: 235/255, blue: 220/255, alpha: 1.0)
            case 2:
                return UIColor(red: 255/255, green: 216/255, blue: 213/255, alpha: 1.0)
            case 3:
                return UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1.0)
            case 4:
                return UIColor(red: 255/255, green: 177/255, blue: 177/255, alpha: 1.0)
            case 5:
                return UIColor(red: 255/255, green: 157/255, blue: 157/255, alpha: 1.0)
            case 6:
                return UIColor(red: 255/255, green: 137/255, blue: 137/255, alpha: 1.0)
            case 7:
                return UIColor(red: 255/255, green: 118/255, blue: 118/255, alpha: 1.0)
            case 8:
                return UIColor(red: 255/255, green: 98/255, blue: 98/255, alpha: 1.0)
            case 9:
                return UIColor(red: 255/255, green: 78/255, blue: 78/255, alpha: 1.0)
            case 10:
                return UIColor(red: 216/255, green: 0/255, blue: 0/255, alpha: 1.0)
            case 11:
                return UIColor(red: 196/255, green: 0, blue: 0, alpha: 1.0)
            case 12:
                return UIColor(red: 157/255, green: 0, blue: 0, alpha: 1.0)
            default:
//                return UIColor(red: 0, green: 0, blue: 15/255, alpha: 1.0)
                return .darkGray
            }

        }
    }
}


