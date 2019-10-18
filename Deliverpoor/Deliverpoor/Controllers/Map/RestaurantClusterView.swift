//
//  RestaurantClusterView.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 18/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import MapKit

final class RestaurantClusterView: MKMarkerAnnotationView {
    
    static var defaultIdentifier: String {
        return String(describing: self)
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .orange
        }
    }
}
