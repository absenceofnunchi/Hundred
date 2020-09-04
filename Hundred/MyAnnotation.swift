//
//  MyAnnotation.swift
//  Hundred
//
//  Created by jc on 2020-09-03.
//  Copyright © 2020 J. All rights reserved.
//

import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    // Marker Tint Color for discipline
    var marketTintColor: UIColor {
        switch discipline {
        case "A":
            return .red
        case "B":
            return .blue
        default:
            return .black
        }
    }
    
}
