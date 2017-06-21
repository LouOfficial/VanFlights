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
        return states
    }
    
    func isOpenSkyState(_ state: OpenSkyState, near coordination: [Double]) -> Bool {
        if let lat = state.latitude, let long = state.longitude {
            let a = abs(lat - coordination[0]) + abs(long - coordination[1])
            return a < range
        }
        return false
    }
}
