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
    static let activeStrokecolor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.9)
    
    let state: OpenSkyState
    let icao24: String
    var path = [[Double]]()
    var marker = GMSMarker()
    var line = GMSPolyline()
    
    private var _isActive = false
    var isActive: Bool {
        get {
            return _isActive
        }
        set(active) {
            _isActive = active
            line.strokeColor = active ? Flight.activeStrokecolor : Flight.normalStrokecolor
        }
    }
    
    init() {
        state = OpenSkyState()
        icao24 = ""
    }
    
    init(state: OpenSkyState) {
        self.state = state
        icao24 = state.icao24
        
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
        for coord in self.path {
            path.add(CLLocationCoordinate2D(latitude: coord[0], longitude: coord[1]))
        }
        line.path = path
    }
}
