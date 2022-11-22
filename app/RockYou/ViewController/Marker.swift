//
//  Marker.swift
//  RockYou
//
//  Created by 이선호 on 2022/11/22.
//

import UIKit
import MapKit

class Marker: NSObject, MKAnnotation{
    let coordinate: CLLocationCoordinate2D?
    
    init(
        coordinate: CLLocationCoordinate2D
    ) {
        self.coordinate = coordinate
        super.init()
    }
    
}
