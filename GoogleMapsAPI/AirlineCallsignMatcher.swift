//
//  AirlineCallsignMatcher.swift
//  GoogleMapsAPI
//
//  Created by Ginpei on 2017-06-20.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import Foundation

class AirlineCallsignMatcher {
    
    // https://en.wikipedia.org/wiki/List_of_airline_codes
    static let dictionary = [
        "AAL": "American Airlines",
        "AAR": "Asiana Airlines",
        "ABW": "AirBridge Cargo",
        "ANA": "All Nippon Airways",
        "ASA": "Alaska Airlines, Inc.",
        "BAW": "British Airways",
        "BOE": "Boeing",
        "BYF": "San Carlos Flight Center",
        "CCA": "Air China",
        "CES": "China Eastern Airlines",
        "CFE": "BA CityFlyer",
        "CGE": "Nelson Aviation College",
        "CGX": "United States Coast Guard Auxiliary",
        "CHH": "Hainan Airlines",
        "CKK": "China Cargo Airlines",
        "CPZ": "Compass Airlines",
        "DAL": "Delta Air Lines",
        "DLH": "Lufthansa",
        "EJA": "NetJets",
        "EVA": "EVA Air",
        "FDX": "Federal Express",
        "FIN": "Finnair",
        "ICE": "Icelandair",
        "JAL": "Japan Airlines",
        "KAL": "Korean Air",
        "KLM": "KLM",
        "PAL": "Philippine Airlines",
        "PCM": "Westair Industries",
        "SKW": "SkyWest Airlines",
        "SWA": "Southwest Airlines",
        "SWR": "China Eastern Airlines",
        "THY": "Turkish Airlines",
        "TSC": "Air Transat",
        "UAL": "United Airlines",
        "UPS": "United Parcel Service",
        "VIR": "Virgin Atlantic Airways",
        "VRD": "Virgin America",
        "WJA": "WestJet",
        ]
    
    static func findBy(callsign: String?) -> String? {
        if let c = callsign {
            if c.characters.count > 3 {
                let index = c.index(c.startIndex, offsetBy: 3)
                let prefix = c.substring(to: index)
                if let name = dictionary[prefix] {
                    return name
                }
            }
        }
        
        return nil
    }
}
