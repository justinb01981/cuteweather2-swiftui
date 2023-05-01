//
//  WeatherAnnotation.swift
//  Pods
//
//  Created by Justin Brady on 4/29/23.
//

import Foundation
import MapKit

// MARK: -- todo - move these associated types to separate files
struct WeatherAnnotation {
    var coord = CLLocationCoordinate2D()
    var main = String()
    var temp = 0.0
    var icon = "10d"
}
