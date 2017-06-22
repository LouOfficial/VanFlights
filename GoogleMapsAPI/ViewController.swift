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


class ViewController: UIViewController, GMSMapViewDelegate {

    let originLat = 49.1966913  // YVR
    let originLong = -123.183701
    let req = OpenSkyRequest()
    
    var mapView: GMSMapView?
    var markers = [String: GMSMarker]()
    var flights = [String: Flight]()
    var activeFlight: Flight? = nil
    var timerUpdateFlights = Timer()
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        
        //          Create a GMSCameraPosition that tells the map to display Vancouver position.
        let camera = GMSCameraPosition.camera(withLatitude: originLat, longitude: originLong, zoom: 11.0)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        let mapView = self.mapView!
        mapView.delegate = self
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
                    newFlight.userData = s.icao24
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
      navigationItem.title = "VanFlight"
        
    //    navigationItem.title.titleTextAttribute =
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Request Info", style: .plain, target: self, action: #selector(test))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.110, green: 0.149, blue: 0.318, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        navigationController?.navigationBar.barStyle = .blackOpaque
            
        
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
    
    private func setupNavigationBarItems() {
      
//        let planeButton = UIButton(type: .system)
//        planeButton.setImage(#imageLiteral(resourceName: "Plane1"), for: .normal)
//        planeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        planeButton.tintColor = UIColor.white
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: planeButton)
//        
        let searchButton = UIButton(type: .system)
        searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        searchButton.tintColor = UIColor.white
        searchButton.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let icao24 = marker.userData as? String {
            activate(flight: flights[icao24])
        }
        return false
    }
    
    func activate(flight: Flight?) {
        // deactivate old one
        if let f = activeFlight {
            f.isActive = false
        }
        
        // activate this one
        if let f = flight {
            f.isActive = true
            activeFlight = f
        }
    }
}

