//
//  MapViewController.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 18/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Initialization
      init() {
          super.init(nibName: nil, bundle: nil)
        title = "Map"
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapInACoruna()
    }
    
    // MARK: - Actions
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        enum MapType: Int {
            case standard, satellite, hybrid
        }
        
        guard let selectedType = MapType(rawValue: sender.selectedSegmentIndex) else { return }
        switch selectedType {
        
        case .standard:
            mapView.mapType = .standard
        case .satellite:
            mapView.mapType = .satellite
        case .hybrid:
            mapView.mapType = .hybrid
        }
    }
}

// MARK: - Utils
extension MapViewController {
    private func centerMapInACoruna() {
        let coruna = CLLocation(latitude: 43.3713500, longitude: -8.3960000)
        let region = MKCoordinateRegion(center: coruna.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
    }
}
