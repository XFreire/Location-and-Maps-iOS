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
    let time: String
}

final class RestaurantCell: UITableViewCell {

    
    // MARK: - Properties
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Public interface
extension RestaurantCell {
    func update(with viewModel: RestaurantCellViewModel) {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.distance
        distanceLabel.text = viewModel.distance
        timeLabel.text = viewModel.time
    }
}

extension RestaurantCell {
    private func setupUI() {
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = timeLabel.frame.height / 2
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
