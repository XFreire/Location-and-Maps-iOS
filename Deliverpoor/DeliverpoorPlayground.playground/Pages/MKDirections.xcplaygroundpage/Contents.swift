//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import CoreLocation
import MapKit

PlaygroundPage.current.needsIndefiniteExecution = true

let tower = CLLocation(latitude: 43.3834033, longitude: -8.4078867)
let restaurant = CLLocation(latitude: 43.3687184, longitude: -8.4174835)

// Creamos el punto de inicio y punto de destino
let source = MKMapItem(placemark: MKPlacemark(coordinate: tower.coordinate))
let destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))

// Creamos la request
let request = MKDirections.Request()
request.source = source
request.destination = destination
request.transportType = .walking

// Calculamos las directions
let directions = MKDirections(request: request)
directions.calculate { directions, error in
    if let error = error {
        // TODO: - Display an error alert
        print("[] Error: \(error)")
        return
    }
    
    guard let route = directions?.routes.first else {
        print("[] We could not find any route between the two provided locations")
        return
    }
    
    print("[] Distance: \(route.distance)")
    print("[] Time: \(route.expectedTravelTime / 60) min")
    route.steps.forEach {
        print("[] \($0.instructions)")
    }
}

//: [Next](@next)
