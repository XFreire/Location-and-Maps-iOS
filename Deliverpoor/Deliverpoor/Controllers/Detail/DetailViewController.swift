//
//  DetailViewController.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 15/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import CoreLocation

final class DetailViewController: UIViewController {

    private let restaurant: Restaurant
    private let locationManager: CLLocationManager
    
    // MARK: - Initialization
    init(restaurant: Restaurant, locationManager: CLLocationManager) {
        self.restaurant = restaurant
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        monitorRegion(around: restaurant)
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location
extension DetailViewController {
    private func monitorRegion(around restaurant: Restaurant) {
        let restaurantCoords = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let region = CLCircularRegion(center: restaurantCoords, radius: 20, identifier: restaurant.name)
        locationManager.startMonitoring(for: region)
    }
}

// MARK: - CLLocationManagerDelegate
extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("[] The user has almost arrive to the restaurant")
        locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("[] User is walking...")
        print("[] \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[] \(error.localizedDescription)")
    }
}
