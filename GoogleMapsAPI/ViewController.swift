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

    let originLat = 49.1966913  // YVR
    let originLong = -123.183701
    let req = OpenSkyRequest()
    
    var mapView: GMSMapView?
    var markers = [String: GMSMarker]()
    var flights = [String: Flight]()
    var timerUpdateFlights = Timer()
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //          Create a GMSCameraPosition that tells the map to display Vancouver position.
        let camera = GMSCameraPosition.camera(withLatitude: originLat, longitude: originLong, zoom: 11.0)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        let mapView = self.mapView!
        mapView.isMyLocationEnabled = true
        view = mapView
        print("loading...")
        
        req.fetch(coordination: [originLat, originLong]) {data, res, err in
            if err != nil {
                print("ERR \(err!)")
                return
            }
            
            let queue = DispatchQueue.main
            
            queue.async {
                for s in data! {
                    let planePosition = CLLocationCoordinate2D(latitude: s.latitude!, longitude: s.longitude!)
                    let newFlight = GMSMarker(position: planePosition)
                    newFlight.title = s.icao24
                    newFlight.icon = UIImage(named: "Plane1")
                    newFlight.rotation = s.heading!
                    newFlight.map = mapView
                    
                    self.markers[s.icao24] = newFlight
                    
                    self.buildFirstPath(state: s)
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
        marker.position = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
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
        
        startUpdateFlightTimer()
    }
    func test() {
        print("button")
//        print("loading...")
//        
//        let req = OpenSkyRequest()
//        req.fetch(coordination: [originLat, originLong]) {data, res, err in
//            if err != nil {
//                print("ERR \(err!)")
//                return
//            }
//            
//            print("There are \(data?.count ?? 0) airplane(s) near here!")
//            for s in data! {
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
    
    func startUpdateFlightTimer() {
        stopUpdateFlightTimer()
        
        timerUpdateFlights = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateFlights), userInfo: nil, repeats: true)
    }
    
    func stopUpdateFlightTimer() {
        timerUpdateFlights.invalidate()
    }
    
    func updateFlights() {
        print("updateFlights")
        for (icao24, flight) in flights {
            // TODO
            print("\(icao24), \(flight.recentPath.count)")
//            marker.position.latitude += 0.0
//            marker.position.longitude += 0.0
        }
    }
    
    func buildFirstPath(state: OpenSkyState) {
        req.fetchDetailBy(icao24: state.icao24) {data, res, err in
            if let track = data {
                DispatchQueue.main.async {
                    let flight = self.createFlightFromApiData(state: state, track: track)
                    self.flights[state.icao24] = flight
                
                    flight.line.map = self.mapView
                    flight.updateLine()
                }
            }
        }
    }
    
    func createFlightFromApiData(state: OpenSkyState, track: OpenSkyTrack) -> Flight {
        let flight = Flight(icao24: state.icao24)
        
        let coordinations = track.path.map{c in [c[1], c[2]]}
        flight.initPath(coordinations)
        
        if let lat = state.latitude, let long = state.longitude {
            flight.stretchPath(lat: lat, long: long)
        }
        
        return flight
    }
}

