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
       
        // Create a GMSCameraPosition that tells the map to display position
        let camera = GMSCameraPosition.camera(withLatitude: 49.2827, longitude: -123.1207, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)
        marker.title = "Vancouver"
        marker.snippet = "Canada"
        marker.map = mapView
        
        // Create my location button
        mapView.settings.myLocationButton = true
        
        mapView.animate(toZoom: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func fetch_touchUpInside(_ sender: UIButton) {
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

