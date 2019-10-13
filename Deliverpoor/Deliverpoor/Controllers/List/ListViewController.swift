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
    
    // MARK: - Initialization
    init(
        repository: RestaurantRepositoryProtocol = LocalRestaurantRepository(),
        locationManager: CLLocationManager = CLLocationManager()
    ) {
        self.repository = repository
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
        title = "List"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleCurrentLocationAuthorizationStatus()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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
            locationManager.requestWhenInUseAuthorization()
            // locationManager.requestAlwaysAuthorization()
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
}

// MARK: - CLLocationManagerDelegate
extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - UITableView DataSource
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
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
        let cellViewModel = RestaurantCellViewModel(
            name: restaurant.name,
            address: "Lat: \(restaurant.latitude); Long: \(restaurant.longitude)",
            distance: "Distance: unknown",
            time: "¿?"
        )
        
        cell.update(with: cellViewModel)
        
        return cell
    }
}
