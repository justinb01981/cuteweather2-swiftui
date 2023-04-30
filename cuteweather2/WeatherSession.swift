//
//  WeatherSession.swift
//  cuteweather
//
//  Created by Justin Brady on 4/27/23.
//

import Foundation
import SwiftUI

class WeatherSession {
    static var shared = WeatherSession()
    
    private init() {}
    
    var lastQuery: String {
        get {
            return UserDefaults.standard.value(forKey: WeatherConstPref) as! String? ?? "Unknown"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: WeatherConstPref)
        }
    }
    
    var viewModel = WeatherViewModel()
}
