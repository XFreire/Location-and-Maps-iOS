//
//  DetailViewController.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 15/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

final class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let restaurant: Restaurant
    private let locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    
    /// Determines if a directions request should take place
    private var shouldRequestDirections: Bool
    
    // MARK: - Initialization
    init(restaurant: Restaurant, locationManager: CLLocationManager) {
        self.restaurant = restaurant
        self.locationManager = locationManager
        currentLocation = nil
        shouldRequestDirections = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        monitorRegion(around: restaurant)
        addAnnotation(in: restaurant)
        mapView.userTrackingMode = .follow
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Setup UI
extension DetailViewController {
    private func addAnnotation(in restaurant: Restaurant) {
        mapView.addAnnotation(restaurant)
    }
    
    private func centerMapBetweenCurrentLocationAndRestaurant() {
        let annotations = mapView.annotations
        mapView.showAnnotations(annotations, animated: true)
    }
}

// MARK: - Location
extension DetailViewController {
    private func monitorRegion(around restaurant: Restaurant) {
        let restaurantCoords = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let region = CLCircularRegion(center: restaurantCoords, radius: 20, identifier: restaurant.name)
        locationManager.startMonitoring(for: region)
    }
    
    private func requestDirectionsIfNeeded() {
        guard shouldRequestDirections else { return }
        guard let currentLocation = currentLocation else { return }
        
        // Creamos el punto de inicio y punto de destino
        let source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))
        
        // Creamos la request
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .walking
        
        // Calculamos las directions
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] directions, error in
            if let error = error {
                // TODO: - Display an error alert
                print("[] Error: \(error)")
                return
            }
            
            guard let route = directions?.routes.first else {
                print("[] We could not find any route between the two provided locations")
                return
            }
            
            print("[] Steps: \(route.distance)")
            print("[] Time: \(route.expectedTravelTime / 60)")
            print("[] Steps: \(route.steps)")
            print("[] Polyine: \(route.polyline)")
            
            // Añadimos la ruta al mapa
            self?.mapView.addOverlay(route.polyline)
            self?.centerMapBetweenCurrentLocationAndRestaurant()

            // Actualizamos la variable para no solicitar la ruta otra vez
            self?.shouldRequestDirections = false
        }
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
        currentLocation = locations.last
        requestDirectionsIfNeeded()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[] \(error.localizedDescription)")
    }
}

// MARK: - MKMapViewDelegatee
extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}
