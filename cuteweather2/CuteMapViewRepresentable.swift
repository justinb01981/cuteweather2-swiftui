//
//  File.swift
//  cuteweather2
//
//  Created by Justin Brady on 4/27/23.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

struct CuteMapViewRepresentable: UIViewRepresentable {
    
    class View: UIView {
        
        var session: WeatherSession {
            WeatherSession.shared
        }
        
        private var layout = true
        
        let mapView = MKMapView()
        
        @Published var weatherAnnot = [CLLocationCoordinate2D]() // todo - see base protocol

        init() {
            super.init(frame: CGRect.zero)
            
            addSubview(mapView)
            
            session.viewModel.onNavigate {
                let co = $0
                
                DispatchQueue.main.async {  // don't crash - this is on another queue, bounce to main
                    
                    self.mapView.camera.centerCoordinate = co
                    
                    // TODO: preserve user selected zoom level instead
                    self.mapView.camera.centerCoordinateDistance = WeatherConstAltitudeInitial
                }
            }
    
            session.viewModel.onAnnotate(do: { an in
                
                let mka = MKPointAnnotation()
                mka.coordinate = an.coord
                mka.title = "\(an.main)\n\(an.temp)"
                
                // TODO: -- add mka.image - fetch from owmap
                let MainWeathers: [String: UIImage?] = [
                    "Clouds": UIImage(named: "Clouds.jpg"),
                    "Sun": UIImage(named: "Sun.jpg")
                ]
                
                // TODO: -- when to remove still unhandled
                
                self.mapView.addAnnotation(mka)
                
                // TODO: fetch icon from https://openweathermap.org/img/wn/10d@2x.png + $response.main.icon @2x.png
                
                print("\(self) adding annotation @ \(mka.coordinate)")
            })
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            guard let sView = superview
            else {
                fatalError("\(self): no superview - cannot layoutSubViews")
            }
            
            frame = sView.frame
            mapView.frame = frame
        }
    }
    
    func makeUIView(context: Context) -> View {
        View()
    }

    func updateUIView(_ uiView: View, context: Context) {
        // TODO:
        print("\(self) updateUIView")
    }
}
