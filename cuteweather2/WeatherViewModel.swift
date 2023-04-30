//
//  WeatherViewModel.swift
//  cuteweather
//
//  Created by Justin Brady on 4/27/23.
//

import Foundation
import SwiftUI
import MapKit


// TODO: -- move as much as possible into ViewModelBase protocol
class WeatherViewModel: NSObject, ViewModelBase, CLLocationManagerDelegate {
    
    // TODO: -- use this publisher instead of xxxHandler closures
    @Published var weatherAnnot = [WeatherAnnotation]() // debug
    
    var geoCoder = CLGeocoder()
    var locationMgr = CLLocationManager()
    var weatherApi =  WeatherAPI()
    var navigateHandler: (CLLocationCoordinate2D)->() = { _ in }
    var annotateHandler: (WeatherAnnotation) -> () = { _ in }
    var locationPHandler: () -> () = {}
    
    private var startAboveUser = true
    
    func navigate(to city: String) {
        locationMgr.delegate = self
        
//        geoCoder.geocodeAddressString(city) {
//            // don't retain self during this escaped closure
//            [weak self](result, err) in
//
//            guard let strong = self else {
//                return
//            }
//
//            guard var dstLatLng = result?.first?.location?.coordinate, err == nil
//            else {
//                print("\(self) \(#function) failed geoCoding: \(err)")
//                return
//            }
//
//            strong.navigateHandler(dstLatLng)
//        }
        
        // launch OWMap query
        let q = WeatherQuery()
        q.city = city
        
        weatherApi.query(q) {
            [weak self](resp) in
            
            guard let strong = self else {
                return
            }
            
            // TODO: add annotations around origin to indicate weather
            print("\(self) \(q.results)")
            
            guard let firstTemp = q.results.first?.owResp else {
                print("\(self) failed reading result")
                return
            }
            
            var an = WeatherAnnotation()
            
            an.temp = Double(firstTemp.main.temp)
            an.coord = CLLocationCoordinate2D(latitude: firstTemp.coord.lat, longitude: firstTemp.coord.lon)
            
            strong.annotateHandler(an)
            
            strong.navigateHandler(an.coord)
            
        }
    }
    
    func tryLocationPermission(_ then: @escaping ()->()) {
        locationPHandler = then
        
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
        
        locationMgr.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("\(self) location updated!")
        
        // this was set by permissionview to dismiss
        locationPHandler()
        
        if startAboveUser, let co = locations.last?.coordinate {
            
            // only first time -- todo: add a "home" button
            startAboveUser = false
            navigateHandler(co)
        }
    }
    
//    private func parseAnnotations(from query: WeatherQuery) {
//
//    }

}
