//
//  ListViewController.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 12/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit
import CoreLocation

final class ListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let repository: RestaurantRepositoryProtocol
    private let locationManager: CLLocationManager
    
    private var currentLocation: CLLocation!
    
    // MARK: - Initialization
    init(
        repository: RestaurantRepositoryProtocol = LocalRestaurantRepository(),
        locationManager: CLLocationManager = CLLocationManager()
    ) {
        self.repository = repository
        self.locationManager = locationManager
        self.currentLocation = nil
        super.init(nibName: nil, bundle: nil)
        title = "List"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleCurrentLocationAuthorizationStatus()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

// MARK: - Setup UI
extension ListViewController {
    private func setupUI() {
        tableView.register(UINib(nibName: RestaurantCell.nibName, bundle: nil), forCellReuseIdentifier: RestaurantCell.defaultIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Location
extension ListViewController {
    private func handleCurrentLocationAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            // TODO: Mostrar alerta
            // No sirve de nada volver a preguntar al usuario, ya que ha denegado el acceso.
            // Es mejor mostrar una alerta diciendo que vayan a la app de Settings y lo habiliten
            break
        case .authorizedAlways, .authorizedWhenInUse:
            // Ya tenemos permiso
            break
        @unknown default:
            break
        }
    }
    
    private func distance(to location: CLLocation) -> String {
        guard let currentLocation = currentLocation else { return "Distance: unknown" }
        
        let distanceValueInMeters = location.distance(from: currentLocation)
        let measurement = Measurement(value: distanceValueInMeters, unit: UnitLength.meters)
            .converted(to: .kilometers)
        
        // Formateamos el valor para tener sólo dos decimales
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = numberFormatter
        measurementFormatter.unitOptions = .providedUnit // Para que use la unidad del measurement
        
        return measurementFormatter.string(from: measurement)
    }
    
    private func address(of restaurant: Restaurant, completion: @escaping (Result<String, Error>) -> Void) {
        let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(restaurantLocation) { placemarks, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            guard let placemark = placemarks?.first else {
                completion(.failure(CLError.geocodeFoundNoResult as! Error))
                return
            }
            
            let number = placemark.subThoroughfare ?? ""
            let street = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            
            let address = "\(street) \(number), \(city), \(state)"
            completion(.success(address))
            return
        }
    }
    
    private func location(of address: String, completion: @escaping (Result<CLLocation, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            guard let placemark = placemarks?.first,
                let location = placemark.location else {
                completion(.failure(CLError.geocodeFoundNoResult as! Error))
                return
            }
            
            completion(.success(location))
            return
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[] \(error.localizedDescription)")
    }
}

// MARK: - UITableView Delegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let restaurant = repository.restaurant(at: indexPath.row) else { return }
        let detailViewController = DetailViewController(restaurant: restaurant, locationManager: locationManager)
        navigationController?.pushViewController(detailViewController, animated: true) 
    }
}

// MARK: - UITableView DataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.defaultIdentifier) as! RestaurantCell
        
        guard let restaurant = repository.restaurant(at: indexPath.row) else { return cell }

        // Obtenemos la dirección del restaurante
        address(of: restaurant) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let address):
                // Calculamos la distancia. Es un poco redundante pero es para practicar
                self.location(of: address) { result in
                    switch result {
                    case .success(let location):
                        let cellViewModel = RestaurantCellViewModel(
                            name: restaurant.name,
                            address: address,
                            distance: self.distance(to: location)
                        )
                        
                        cell.update(with: cellViewModel)
                    case .failure:
                        break
                    }
                }
            case .failure:
                break
            }
        }

        return cell
    }
}
