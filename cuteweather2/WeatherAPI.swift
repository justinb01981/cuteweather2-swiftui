//
//  WeatherAPI.swift
//  cuteweather2
//
//  Created by Justin Brady on 4/29/23.
//

import Foundation
import UIKit
import MapKit
import OpenWeatherMapAPIConsumer

class WeatherResult {
    var temp: Double = 0
    var wind: Double = 0
    
    var atLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var owResp: CurWeatherCodable!
}

class WeatherQuery {
    var city: String!
    var location: CLLocationCoordinate2D!
    
    var results: [WeatherResult] = []
}

class WeatherAPI {
    
    private let jsonDeoder = JSONDecoder()
    
    // TODO: relocate to plist
    private let apiKey = "7472f295f6592cef94bc541defcec63a"
    
    func query(_ query: WeatherQuery, then call: @escaping (WeatherQuery)->()) {
        let res = WeatherResult()
        
        let cQuery = query
        
        let consumer = RequestOpenWeatherMap(withType: .Current, andParameters:
                                                [
                                                    RequestParametersKey.apiKey.rawValue: apiKey,
                                                    RequestParametersKey.cityName.rawValue: query.city
                                                ])
        
        consumer.request {
            [weak self] data, response, err in
            
            let res = WeatherResult()
            
            guard let strong = self else {
                return
            }
            
            guard let data = data, err == nil else {
                print("\(self.debugDescription) open weather response err \(err.debugDescription)")
                return
            }
            
            strong.jsonDeoder.keyDecodingStrategy = .useDefaultKeys
            
            res.owResp = try? strong.jsonDeoder.decode(CurWeatherCodable.self, from: data)// pod broken casting to dict
            
            cQuery.results = [res]
            
            print("\(self.debugDescription) received:\n\(String(bytes:data, encoding:.utf8) ?? "")")
            
            call(cQuery)
            
        }
    }
}
