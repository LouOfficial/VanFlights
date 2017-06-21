//
//  Flight.swift
//  GoogleMapsAPI
//
//  Created by Ginpei on 2017-06-21.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import Foundation
import GoogleMaps

class Flight {
    static let normalStrokecolor = UIColor(colorLiteralRed: 0.3, green: 0.5, blue: 1.0, alpha: 0.5)
    
    let icao24: String
    var path = [[Double]]()
    var marker = GMSMarker()
    var line = GMSPolyline()
    
    var recentPath: [[Double]] {
        get  {
            let maxCount = 10
            let startIndex = path.endIndex - min(maxCount, path.count)
            let recents = path[startIndex ..< path.endIndex]
            return Array(recents)
        }
    }
    
    init() {
        icao24 = ""
    }
    
    init(icao24: String) {
        self.icao24 = icao24
        
        line.strokeColor = Flight.normalStrokecolor
    }
    
    func initPath(_ coordinations: [[Double]]) {
        path.removeAll()
        for coord in coordinations {
            path.append(coord)
        }
    }
    
    func stretchPath(lat: Double, long: Double) {
        path.append([lat, long])
    }
    
    func updateLine() {
        let path = GMSMutablePath()
        for coord in recentPath {
            path.add(CLLocationCoordinate2D(latitude: coord[0], longitude: coord[1]))
        }
        line.path = path
    }
}
