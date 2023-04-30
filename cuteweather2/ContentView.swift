//
//  ContentView.swift
//  cuteweather2
//
//  Created by Justin Brady on 4/27/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var enteredText: String = ""
    @State var alertVisible = true
    
    @State var session = WeatherSession.shared
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            

            
            CuteMapViewRepresentable().fullScreenCover(isPresented: $alertVisible) {
                PermissionView {
                    // permissions granted
                    $alertVisible.wrappedValue = false
                    
                    WeatherSession.shared.viewModel.goToUser {
                        print("\(self) goToUser done")
                    }
                }
            }
//            .dynamicTypeSize(.large)/
            
            TextField("City", text: $enteredText ) {
                // user taps enter
                print("\($session.wrappedValue.viewModel.locationMgr.delegate.debugDescription)")
                
                $session.wrappedValue.lastQuery = enteredText
                
                $session.wrappedValue.viewModel.navigate(to: enteredText)
            }
//            .dynamicTypeSize(.small)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
