//
//  OpenSkyTrack.swift
//  GoogleMapsAPI
//
//  Created by Ginpei on 2017-06-20.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import Foundation

class OpenSkyTrack {
    var icao24: String
    var callsign: String?
    var startTime: Double
    var endTime: Double
    var path: [[Double]]
    
    init(icao24: String, callsign: String?, startTime: Double, endTime: Double, path: [[Double]]) {
        self.icao24 = icao24
        self.callsign = callsign
        self.startTime = startTime
        self.endTime = endTime
        self.path = path
    }
}
