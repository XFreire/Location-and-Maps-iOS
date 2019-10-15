//
//  MapViewController.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 13/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    private let repository: RestaurantRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: RestaurantRepositoryProtocol = LocalRestaurantRepository()) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        title = "Map"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        centerMapInACoruna()
        mapView.addAnnotations(repository.all())
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

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("[] Region will change")
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("[] Region has changed visible region")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("[] Region has changed")
    }
}
