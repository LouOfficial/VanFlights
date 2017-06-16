//
//  OpenSkyState.swift
//  OpenSkyAPIDemo
//
//  Created by Ginpei on 2017-06-07.
//  Copyright © 2017 Ginpei. All rights reserved.
//

import Foundation

class OpenSkyState {
    static func from(array row: [Any]) -> OpenSkyState? {
        let icao24 = row[0] as! String
        let callsign = row[1] as? String
        let originCountry = row[2] as! String
        let timePosition = row[3] as? Double
        let timeVelocity = row[4] as? Double
        let longitude = row[5] as? Double
        let latitude = row[6] as? Double
        let altitude = row[7] as? Double
        let onGround = row[8] as! Bool
        let velocity = row[9] as? Double
        let heading = row[10] as? Double
        let verticalRate = row[11] as? Double

        return OpenSkyState(
            icao24: icao24,
            callsign: callsign,
            originCountry: originCountry,
            timePosition: timePosition,
            timeVelocity: timeVelocity,
            longitude: longitude,
            latitude: latitude,
            altitude: altitude,
            onGround: onGround,
            velocity: velocity,
            heading: heading,
            verticalRate: verticalRate
        )
    }
    
    let icao24: String
    let callsign: String?
    let originCountry: String
    let timePosition: Double?
    let timeVelocity: Double?
    let longitude: Double?
    let latitude: Double?
    let altitude: Double?
    let onGround: Bool
    let velocity: Double?
    let heading: Double?
    let verticalRate: Double?

    init(icao24: String, callsign: String?, originCountry: String, timePosition: Double?, timeVelocity: Double?, longitude: Double?, latitude: Double?, altitude: Double?, onGround: Bool, velocity: Double?, heading: Double?, verticalRate: Double?) {
        self.icao24 = icao24
        self.callsign = callsign
        self.originCountry = originCountry
        self.timePosition = timePosition
        self.timeVelocity = timeVelocity
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
        self.onGround = onGround
        self.velocity = velocity
        self.heading = heading
        self.verticalRate = verticalRate
    }
}
