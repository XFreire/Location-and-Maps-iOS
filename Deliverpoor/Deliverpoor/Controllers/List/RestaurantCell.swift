//
//  RestaurantCell.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 13/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit

struct RestaurantCellViewModel {
    let name: String
    let address: String
    let distance: String
}

final class RestaurantCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
}

// MARK: - Public interface
extension RestaurantCell {
    func update(with viewModel: RestaurantCellViewModel) {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        distanceLabel.text = viewModel.distance
    }
}

extension RestaurantCell {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}
