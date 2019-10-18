//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import CoreLocation

PlaygroundPage.current.needsIndefiniteExecution = true

// Creamos varios objetos CLLocation

// Estadio de Riazor
let riazor = CLLocation(latitude: 43.3687184, longitude: -8.4174835)

// Pontedeume
let pontedeume = CLLocation(latitude: 43.4011397, longitude: -8.1767528)

// Calculamos la distancia
let distance = pontedeume.distance(from: riazor) // En metros, línea recta

// Transformamos las unidades de longitud
var measurement = Measurement(value: distance, unit: UnitLength.meters)
measurement.convert(to: UnitLength.kilometers)
measurement.convert(to: UnitLength.miles)
measurement.convert(to: UnitLength.feet)


//: [Next](@next)
