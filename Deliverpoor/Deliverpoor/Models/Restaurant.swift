//
//  Restaurant.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 13/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import Foundation

final class Restaurant: NSObject, Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
}
