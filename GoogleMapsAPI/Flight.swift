//
//  Flight.swift
//  GoogleMapsAPI
//
//  Created by Ginpei on 2017-06-21.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import Foundation

class Flight {
    let icao24: String
    var path = [[Double]]()
    
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
}
