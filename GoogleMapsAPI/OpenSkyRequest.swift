//
//  OpenSkyRequest.swift
//  OpenSkyAPIDemo
//
//  Created by Ginpei on 2017-06-12.
//  Copyright © 2017 Ginpei. All rights reserved.
//

import Foundation

class OpenSkyRequest {
    func fetch(completionHandler: @escaping ([OpenSkyState]?, URLResponse?, Error?) -> Void) {
        var req = URLRequest(url: URL(string: "https://opensky-network.org/api/states/all")!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) {data, res, err in
            if err != nil {
                completionHandler(nil, res, err)
                return
            }
            
            do {
                let states = try self.pickUpData(from: data)
                completionHandler(states, res, nil)
            } catch let err {
                completionHandler(nil, res, err)
            }
        }.resume()
    }
    
    func pickUpData(from data: Data?) throws -> [OpenSkyState] {
        var states = [OpenSkyState]()
        
        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
        if let stateList = json["states"] as? [[Any]] {
            for row in stateList {
                if let state = OpenSkyState.from(array: row) {
                    print("yay \(state.originCountry)")
                    states.append(state)
                }
            }
        }
        return states
    }
}
