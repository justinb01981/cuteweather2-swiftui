//
//  CurWeatherCodable.swift
//  cuteweather2
//
//  Created by Justin Brady on 4/29/23.
//

import Foundation


// replacing OpenWeatherMap types which fail to deserialize
// (for reasons I don't care to chase down)

struct CurWeatherCodable:  Codable {
    struct M: Codable {
        var temp: Double
        var temp_max: Double
        var temp_min: Double
        
        // TODO:
    }
    
    struct W : Codable {
        var main: String
        var description: String
        var icon: String
    }
    
    struct Coord : Codable {
        var lon: Double
        var lat: Double
    }
    
    var coord: Coord
    var weather: [W]
    var main: M
}

