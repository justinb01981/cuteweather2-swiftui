//
//  ViewModelBase.swift
//  cuteweather
//
//  Created by Justin Brady on 4/27/23.
//

import Foundation
import MapKit

// base protocol
protocol ViewModelBase: NSObject {
    var locationMgr: CLLocationManager { get }
    var weatherApi: WeatherAPI { get }
    
    var navigateHandler: (CLLocationCoordinate2D)->() { get set }
    var annotateHandler: (WeatherAnnotation)->() { get set }
}

extension ViewModelBase {

    func goToUser(thenDo done: @escaping ()->()) {
        
        locationMgr.delegate = self as! any CLLocationManagerDelegate
        
        locationMgr.distanceFilter = 0.1
        locationMgr.desiredAccuracy = 0.1
        
        self.locationMgr.startUpdatingLocation()
    }
    
    func onNavigate(do handle: @escaping (CLLocationCoordinate2D)->()) {
        navigateHandler = handle
    }
    
    func onAnnotate(do handle: @escaping (WeatherAnnotation)->()) {
        annotateHandler = handle
    }
}
