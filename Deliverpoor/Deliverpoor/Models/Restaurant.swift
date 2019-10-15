//
//  Restaurant.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 13/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import Foundation
import MapKit

final class Restaurant: NSObject, Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
}

// MARK: - MKAnnotation
extension Restaurant: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
}
