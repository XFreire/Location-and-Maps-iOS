//
//  RestaurantRepository.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 13/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import Foundation

protocol RestaurantRepositoryProtocol {
    var count: Int { get }
    func restaurant(at index: Int) -> Restaurant?
}

final class RestaurantRepository {
    private var restaurants: [Restaurant] {
        let path = Bundle(for: RestaurantRepository.self).path(forResource: "restaurant-list", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        return try! decoder.decode([Restaurant].self, from: data)
    }
}

extension RestaurantRepository: RestaurantRepositoryProtocol {
    var count: Int {
        return restaurants.count
    }
    
    func restaurant(at index: Int) -> Restaurant? {
        guard index < count else { return nil }
        return restaurants[index]
    }
}
