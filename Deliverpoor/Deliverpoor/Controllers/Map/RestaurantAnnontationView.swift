//
//  RestaurantAnnontationView.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 18/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import MapKit

final class RestaurantAnnontationView: MKMarkerAnnotationView {
    
    static var defaultIdentifier: String {
        return String(describing: self)
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            glyphText = "🍽"
            
            canShowCallout = true
            clusteringIdentifier = "RestaurantCluster"
            
            let imageView = UIImageView(image: UIImage(named: "placeholder-food.jpg"))
            imageView.contentMode = .scaleAspectFill
            detailCalloutAccessoryView = imageView
            clusteringIdentifier = RestaurantClusterView.defaultIdentifier
        }
    }
}
