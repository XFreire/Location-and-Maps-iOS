//
//  ListViewController.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 12/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let repository: RestaurantRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: RestaurantRepositoryProtocol = LocalRestaurantRepository()) {
        self.repository = repository
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
