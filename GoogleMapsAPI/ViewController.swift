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
        
        //          Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)
        marker.title = "Vancouver"
        marker.snippet = "Canada"
        marker.map = mapView
        navigationItem.title = "Hello VanFlight"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(test))
        //        create compass button
        mapView.settings.compassButton = true
        
        // Create my location button
        mapView.settings.myLocationButton = true
        
        // animate zoom
        mapView.animate(toZoom: 12)
    }
    func test() {
        print("loading...")
        
        let req = OpenSkyRequest()
        req.fetch() {data, res, err in
            if err != nil {
                print("ERR \(err!)")
                return
            }
            
            for s in data! {
                self.printState(s)
            }
        }
    }

    
    func printState(_ s: OpenSkyState) {
        if let long = s.longitude, let lat = s.latitude {
            print("\(s.originCountry) [\(long),\(lat)]")
        }
        else {
            print("\(s.originCountry) (Unknown place)")
        }
    }
}

