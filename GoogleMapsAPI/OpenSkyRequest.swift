//
//  OpenSkyRequest.swift
//  OpenSkyAPIDemo
//
//  Created by Ginpei on 2017-06-12.
//  Copyright © 2017 Ginpei. All rights reserved.
//

import Foundation

class OpenSkyRequest {
    
    var range = 2.0
    
    func fetch(coordination: [Double], completionHandler: @escaping ([OpenSkyState]?, URLResponse?, Error?) -> Void) {
        var req = URLRequest(url: URL(string: "https://opensky-network.org/api/states/all")!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) {data, res, err in
            if err != nil {
                completionHandler(nil, res, err)
                return
            }
            
            do {
                let states = try self.pickUpData(from: data, near: coordination)
                completionHandler(states, res, nil)
            } catch let err {
                completionHandler(nil, res, err)
            }
        }.resume()
    }
    
    func pickUpData(from data: Data?, near coordination: [Double]) throws -> [OpenSkyState] {
        var states = [OpenSkyState]()
        
        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
        if let stateList = json["states"] as? [[Any]] {
            for row in stateList {
                let state = OpenSkyState.from(array: row)
                if state != nil && isOpenSkyState(state!, near: coordination) {
                    states.append(state!)
                }
            }
        }
        
        // append dummy data (just in case)
        DummyDataProvider.appendDummy(states: &states)
        
        return states
    }
    
    func isOpenSkyState(_ state: OpenSkyState, near coordination: [Double]) -> Bool {
        if let lat = state.latitude, let long = state.longitude {
            let a = abs(lat - coordination[0]) + abs(long - coordination[1])
            return a < range
        }
        return false
    }
    
    func fetchDetailBy(icao24: String, completionHandler: @escaping (OpenSkyTrack?, URLResponse?, Error?) -> Void) {
        if (icao24.characters.count != 6) {
            return
        }
        
        // return dummy data (just in case)
        if let t = DummyDataProvider.getDummyTrack(icao24: icao24) {
            completionHandler(t, nil, nil)
            return
        }
        
        var req = URLRequest(url: URL(string: "https://opensky-network.org/api/tracks/?icao24=\(icao24)")!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) {data, res, err in
            if err != nil {
                completionHandler(nil, res, err)
                return
            }
            
            do {
                let track = try self.parseTrackApiData(data: data!)
                completionHandler(track, res, nil)
            } catch let err {
                completionHandler(nil, res, err)
            }
        }.resume()
    }
    
    func parseTrackApiData(data: Data) throws -> OpenSkyTrack? {
        let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String : AnyObject]
        
        if let icao24 = json["icao24"] as? String,
            let startTime = json["startTime"] as? Double,
            let endTime = json["endTime"] as? Double,
            let path = json["path"] as? [[Double]]
        {
            let callsign = json["callsign"] as? String
            return OpenSkyTrack(icao24: icao24, callsign: callsign, startTime: startTime, endTime: endTime, path: path)
        }
        else {
            return nil
        }
    }
}

class DummyDataProvider {
    static func appendDummy(states: inout [OpenSkyState]) {
        states.append(OpenSkyState(icao24: "c023bb", callsign: "ACA854", originCountry: "Canada", timePosition: 1498187307, timeVelocity: 1498187307, longitude: -122.389, latitude: 50.0393, altitude: 7520.94, onGround: false, velocity: 237.84, heading: 42.11, verticalRate: 9.43))
        states.append(OpenSkyState(icao24: "a445f2", callsign: "UAL2423", originCountry: "United States", timePosition: 1498187310, timeVelocity: 1498187310, longitude: -123.5151, latitude: 49.0259, altitude: 3185.16, onGround: false, velocity: 156.68, heading: 206.73, verticalRate: 4.23))
        states.append(OpenSkyState(icao24: "c080a9", callsign: "WJA1702", originCountry: "Canada", timePosition: 1498187309, timeVelocity: 1498187309, longitude: -122.9662, latitude: 48.5368, altitude: 5532.12, onGround: false, velocity: 201.47, heading: 157.95, verticalRate: 15.93))
    }
    
    static func getDummyTrack(icao24: String) -> OpenSkyTrack? {
        if icao24 == "c023bb" {
            return OpenSkyTrack(icao24: "c023bb", callsign: "ACA854", startTime: 1.498186554E9, endTime: 1.498187334E9, path: [[1498186554,49.1893,-123.2007,0,279],[1498186572,49.1914,-123.2229,0,277],[1498186599,49.1945,-123.2582,300,278],[1498186624,49.1979,-123.2927,600,279],[1498186642,49.2006,-123.3178,900,280],[1498186645,49.2013,-123.3218,900,284],[1498186651,49.2036,-123.3303,900,296],[1498186655,49.2055,-123.3349,900,307],[1498186660,49.209,-123.3407,900,316],[1498186665,49.213,-123.3454,900,327],[1498186669,49.2175,-123.3491,900,337],[1498186674,49.2218,-123.3512,900,343],[1498186679,49.2273,-123.353,1200,350],[1498186680,49.2289,-123.3534,1200,351],[1498186687,49.2379,-123.355,1200,354],[1498186705,49.2583,-123.3574,1200,356],[1498186728,49.2871,-123.3605,1500,355],[1498186751,49.3155,-123.3642,1800,354],[1498186765,49.3338,-123.3663,2100,357],[1498186769,49.3383,-123.3663,2100,0],[1498186775,49.346,-123.365,2400,10],[1498186778,49.3493,-123.3639,2400,15],[1498186784,49.3569,-123.3594,2400,24],[1498186788,49.3619,-123.3551,2400,33],[1498186792,49.3661,-123.3503,2400,37],[1498186797,49.3709,-123.3439,2400,43],[1498186802,49.3753,-123.3369,2400,46],[1498186861,49.428,-123.2476,2700,47],[1498186882,49.4477,-123.2142,3000,48],[1498186905,49.4682,-123.1789,3300,47],[1498186909,49.4718,-123.1733,3300,44],[1498186914,49.4772,-123.1653,3300,42],[1498186918,49.4823,-123.1584,3300,41],[1498186962,49.5346,-123.0863,3600,41],[1498186994,49.576,-123.0308,3900,41],[1498187016,49.6068,-122.9891,4200,41],[1498187038,49.6365,-122.9484,4500,41],[1498187061,49.6684,-122.9046,4800,41],[1498187087,49.705,-122.854,5100,41],[1498187114,49.7447,-122.7992,5400,41],[1498187135,49.7752,-122.7569,5700,41],[1498187152,49.8005,-122.7217,6000,42],[1498187185,49.8502,-122.6527,6300,41],[1498187217,49.8986,-122.5857,6600,41],[1498187238,49.9302,-122.5416,6900,42],[1498187271,49.9823,-122.4688,7200,42],[1498187303,50.032,-122.3992,7500,42],[1498187334,50.0813,-122.3299,7800,42]])
        }
        else if icao24 == "a445f2" {
            return OpenSkyTrack(icao24: "a445f2", callsign: "UAL2423", startTime: 1.49818703E9, endTime: 1.498187355E9, path: [[1498187030,49.186,-123.172,-300,280],[1498187052,49.1886,-123.1946,-300,280],[1498187075,49.1918,-123.2235,0,280],[1498187084,49.1931,-123.2357,300,279],[1498187088,49.1936,-123.2418,300,275],[1498187093,49.1938,-123.2476,300,272],[1498187097,49.1938,-123.2542,300,270],[1498187102,49.1936,-123.2612,300,268],[1498187111,49.193,-123.2759,300,265],[1498187115,49.1926,-123.2824,300,265],[1498187132,49.1911,-123.3101,600,264],[1498187153,49.1888,-123.3465,900,264],[1498187157,49.1882,-123.3536,900,262],[1498187161,49.1871,-123.361,900,256],[1498187166,49.1853,-123.3687,1200,250],[1498187170,49.1828,-123.3762,1200,243],[1498187174,49.1803,-123.382,1200,234],[1498187178,49.1766,-123.3885,1200,228],[1498187182,49.173,-123.3934,1200,221],[1498187187,49.1687,-123.3983,1500,215],[1498187192,49.1629,-123.4036,1500,210],[1498187200,49.1544,-123.411,1500,209],[1498187221,49.1305,-123.4317,1800,208],[1498187243,49.1054,-123.4523,2100,208],[1498187259,49.0869,-123.4673,2400,208],[1498187280,49.0622,-123.487,2700,207],[1498187305,49.0317,-123.5107,3000,206],[1498187355,48.9632,-123.5631,3300,206]])
        }
        else if icao24 == "c080a9" {
            return OpenSkyTrack(icao24: "c080a9", callsign: "WJA1702", startTime: 1.49818695E9, endTime: 1.498187466E9, path: [[1498186950,49.1876,-123.187,0,277],[1498186966,49.1892,-123.2036,0,278],[1498186975,49.1901,-123.2126,300,278],[1498186980,49.1904,-123.2179,300,272],[1498186985,49.1903,-123.2227,300,266],[1498186994,49.1897,-123.2327,300,264],[1498187003,49.189,-123.2435,300,264],[1498187025,49.1872,-123.2738,600,264],[1498187033,49.1864,-123.286,900,264],[1498187038,49.1859,-123.2925,900,261],[1498187041,49.1851,-123.2981,1200,256],[1498187046,49.1833,-123.3054,1200,246],[1498187051,49.1806,-123.3129,1200,238],[1498187056,49.1776,-123.3185,1200,230],[1498187061,49.1732,-123.3247,1200,217],[1498187065,49.1686,-123.3293,1500,209],[1498187070,49.1638,-123.3328,1500,202],[1498187075,49.1579,-123.3355,1500,194],[1498187080,49.1522,-123.3368,1500,185],[1498187084,49.1474,-123.337,1500,178],[1498187088,49.1412,-123.3358,1800,170],[1498187092,49.1375,-123.3344,1800,164],[1498187097,49.1306,-123.3307,1800,159],[1498187111,49.1144,-123.321,2100,158],[1498187126,49.0947,-123.3098,2400,159],[1498187140,49.0769,-123.2992,2700,158],[1498187157,49.0554,-123.2861,3000,158],[1498187182,49.0206,-123.2654,3300,158],[1498187199,48.9949,-123.2498,3600,158],[1498187217,48.9684,-123.2333,3900,157],[1498187233,48.9427,-123.2167,4200,156],[1498187255,48.9088,-123.195,4500,157],[1498187271,48.8825,-123.1788,4800,158],[1498187284,48.8619,-123.1662,5100,157],[1498187304,48.8281,-123.1455,5400,157],[1498187325,48.7921,-123.1232,5700,157],[1498187346,48.7569,-123.1014,6000,157],[1498187367,48.7206,-123.079,6300,157],[1498187389,48.6802,-123.0542,6600,157],[1498187410,48.6413,-123.0303,6900,157],[1498187432,48.6,-123.0049,7200,157],[1498187453,48.5604,-122.9807,7500,157],[1498187466,48.5368,-122.9662,7800,157]])
        }
        else {
            return nil
        }
    }
}
