//
//  annotationView.swift
//  Pods
//
//  Created by Justin Brady on 4/30/23.
//

import Foundation
import UIKit
import MapKit

// TODO: move static image-cache table to this class

class CuteMapViewAnnotationView: MKMarkerAnnotationView {

    var cuteImage: UIImage? {
        get {
            return glyphImage
        }
        set {
            glyphImage = newValue
        }
    }

    override func prepareForReuse() {
        super.prepareForDisplay()

        glyphImage = nil
    }
}
