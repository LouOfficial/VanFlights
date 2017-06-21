//
//  ViewController.swift
//  GoogleMapsAPI
//
//  Created by Luis Alfredo Ramirez on 2017-06-15.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class ViewController: UIViewController {

    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //          Create a GMSCameraPosition that tells the map to display Vancouver position.
        let camera = GMSCameraPosition.camera(withLatitude: 49.2827, longitude: -123.1207, zoom: 11.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        print("loading...")
        
        let req = OpenSkyRequest()
        req.fetch(coordination: [49.2827, -123.1207]) {data, res, err in
            if err != nil {
                print("ERR \(err!)")
                return
            }
            
            let queue = DispatchQueue.main
            
            queue.async {
            
                print("There are \(data?.count ?? 0) airplane(s) near here!")
                for s in data! {
                    self.printState(s)
                    let planePosition = CLLocationCoordinate2D(latitude: s.latitude!, longitude: s.longitude!)
                    let newFlight = GMSMarker(position: planePosition)
                    newFlight.title = s.icao24
                    newFlight.icon = UIImage(named: "Plane1")
                    newFlight.map = mapView
                    
                    print("the \(newFlight) is here")
                }
            }
            
            
        }
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        //          Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)
        marker.title = "Vancouver"
        marker.snippet = "Canada"
        marker.map = mapView
        navigationItem.title = "Hello VanFlight"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Request Info", style: .plain, target: self, action: #selector(test))
        //        create compass button
        mapView.settings.compassButton = true
        
        // Create my location button
        mapView.settings.myLocationButton = true
        
        // animate zoom
        mapView.animate(toZoom: 12)
    }
    func test() {
        print("loading...")
        
//        let req = OpenSkyRequest()
//        req.fetch(coordination: [49.2827, -123.1207]) {data, res, err in
//            if err != nil {
//                print("ERR \(err!)")
//                return
//            }
//            
//            print("There are \(data?.count ?? 0) airplane(s) near here!")
//            for s in data! {
//                self.printState(s)
//                let planePosition = CLLocationCoordinate2D(latitude: s.latitude!, longitude: s.longitude!)
//                let newFlight = GMSMarker(position: planePosition)
//                newFlight.title = s.icao24
//                newFlight.icon = UIImage(named: "1498012390_one_way.png")
//                newFlight.map = GMSMapView()
//                                
//                print("the \(newFlight) is here")
//            }
//        }
    }

    
    func printState(_ s: OpenSkyState) {
        var message = s.originCountry
        
        if let long = s.longitude, let lat = s.latitude {
            message += " [\(long),\(lat)]"
        }
        else {
            message += " (Unknown place)"
        }
        
        if let a = s.airline {
            message += " by \(a)"
        }
        else {
            message += " by Unknown Airline"
            
            if let c = s.callsign {
                if !c.isEmpty {
                    message += " (\(c))"
                }
            }
        }
        
        print(message)
    }
}

