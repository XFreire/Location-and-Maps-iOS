//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import CoreLocation
PlaygroundPage.current.needsIndefiniteExecution = true

let location = CLLocation(latitude: 43.370659, longitude: -8.3996518)

let geocoder = CLGeocoder()
geocoder.reverseGeocodeLocation(location) { placemarks, error in

    // Comprobamos si hay errores
    if let error = error {
        print(error)
        return
    }

    // Extraemos el placemark
    guard let placemark = placemarks?.first else {
        print("error")
        return
    }

    // Extraemos la información
    let number = placemark.subThoroughfare ?? ""
    let street = placemark.thoroughfare ?? ""
    let city = placemark.locality ?? ""
    let state = placemark.administrativeArea ?? ""

    let address = "\(street) \(number), \(city), \(state)"
    print(address)
}



let address = "Rúa Magistrado Manuel Artime, 5, 15004 A Coruña, España"
geocoder.geocodeAddressString(address) { placemarks, error in
    // Comprobamos si hay error
    if let error = error {
        print(error)
        return
    }

    // Extraemos el placemark
    guard let placemark = placemarks?.first,
        let location = placemark.location else {
            print("error")
            return
    }

    print("\(location.coordinate.latitude), \(location.coordinate.latitude)")
}


//: [Next](@next)
