//
//  PermissionViewController.swift
//  cuteweather
//
//  Created by Justin Brady on 4/27/23.
//

import Foundation
import SwiftUI

// modal confirm alert-ish
struct PermissionView: View {
    
    var onSuccessDo: ()->()
    var viewModel = WeatherViewModel()
    
    init(onSuccessDo: @escaping () -> Void) {
        self.onSuccessDo = onSuccessDo
    }
    
    var body: some View {
        HStack {
            VStack {
                Button("request location permissions") {
                    viewModel.tryLocationPermission {
                        onSuccessDo()
                    }
                }
            }
            .padding(120.0)
        }
    }
}
