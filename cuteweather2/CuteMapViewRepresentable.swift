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
    
    typealias View = CuteMapView
    
    func makeUIView(context: Context) -> View {
        View()
    }

    func updateUIView(_ uiView: View, context: Context) {
        // TODO:
        print("\(self) updateUIView")
    }
}

class CuteMapView: UIView
{
    var session: WeatherSession {
        WeatherSession.shared
    }

    private var layout = true

    let mapView = MKMapView()

    // TODO: add URLSession ctx to get caching "for free"
    var Timages: [String: UIImage] = [:]

    @Published var weatherAnnot = [CLLocationCoordinate2D]() // todo - see base protocol

    init() {
        super.init(frame: CGRect.zero)

        addSubview(mapView)
        mapView.delegate = self

        session.viewModel.onNavigate {
            let co = $0

            DispatchQueue.main.async {  // don't crash - this is on another queue, bounce to main

                self.mapView.camera.centerCoordinate = co

                // TODO: preserve user selected zoom level instead
                self.mapView.camera.centerCoordinateDistance = WeatherConstAltitudeInitial
            }
        }

        session.viewModel.onAnnotate(do: {
            [weak self] an in
            guard let strong = self else {
                return
            }

            let convertK: (Double)->(Double) = {
                // round
                return round(100.0*($0-273.15))/100.0
            }

            let title = "\(an.main)\n\(convertK(an.temp))C"

            var mkptannt = MKAnnotationPlus()
            mkptannt.title = title
            mkptannt.coordinate = an.coord
            mkptannt.icon = an.icon

            // TODO: -- when to remove still unhandled
            strong.mapView.addAnnotation(mkptannt)

            // TODO: fetch icon from https://openweathermap.org/img/wn/10d@2x.png + $response.main.icon @2x.png
            // TODO: -- THEN

            // register class - were about to init one
            strong.mapView.register(CuteMapViewAnnotationView.self, forAnnotationViewWithReuseIdentifier: an.icon)

            if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(an.icon)@2x.png") {

                if let iconData = try? Data(contentsOf: iconURL) {
                    // TODO: weak self

                    if let view = strong.mapView.dequeueReusableAnnotationView(withIdentifier: an.icon) as? CuteMapViewAnnotationView
                    {
                        let img: UIImage

                        if let cachedImg = strong.Timages[an.icon] {

                            img = cachedImg
                        }
                        else {
                            // first time using this icon I
                            if let i = UIImage(data: iconData) {
                                strong.Timages[an.icon] = i
                                img = i
                            }
                            else {
                                img = UIImage() // placeholder so img cannot be nil
                                print("\(self) failed parsing image data")
                            }

                            // annot has not been added yet
                            print("\(strong) adding annotation image \(an.icon) to table")
                        }

                        view.cuteImage = img // glyphImage
                    }
                }
                else {
                    print("\(strong) failed to retrieve icon \(iconURL)")
                    // add naked annotation anyway
                }
            }
            print("\(strong) adding annotation @ \(mkptannt.coordinate)")
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

extension CuteMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var key: String

        guard let wAnnotation = annotation as? MKAnnotationPlus else {
            fatalError("\(self) cast failed")
        }

        if let found = Timages[wAnnotation.icon] {

            guard let v = mapView.dequeueReusableAnnotationView(withIdentifier: wAnnotation.icon) as? CuteMapViewAnnotationView
            else {
                return nil
            }

            v.cuteImage = found
            return v
        }
        return nil
    }
}

class MKAnnotationPlus: MKPointAnnotation {
    var icon: String!
}
