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
    
    var mapView: GMSMapView!
    var yvrMarker: GMSMarker!
    var popoverView = PopoverView()
    var markers = [String: GMSMarker]()
    var flights = [String: Flight]()
    var activeFlight: Flight? = nil
    var timerUpdateFlights = Timer()
    var popoverViewTrailingConstraint = NSLayoutConstraint()
    var popoverViewTopConstraint = NSLayoutConstraint()
    var popoverViewHeightConstraint = NSLayoutConstraint()
    var popoverOpened = false
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //          Create a GMSCameraPosition that tells the map to display YVR position.
        let camera = GMSCameraPosition.camera(withLatitude: originLat, longitude: originLong, zoom: 11.0)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        let mapView = self.mapView!
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.padding.top = navigationController!.navigationBar.frame.height
        view = mapView
        
        updateFlights()
        
        //          Creates a marker in the center of the map.
        let marker = GMSMarker()
        yvrMarker = marker
        marker.position = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        marker.title = "Vancouver International Airport"
        marker.snippet = "Canada"
        marker.map = mapView
        navigationItem.title = "Hello VanFlight"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(test))
        //        create compass button
        mapView.settings.compassButton = true
        
        // Create my location button
        mapView.settings.myLocationButton = true
        
        // animate zoom
        mapView.animate(toZoom: 12)
        
        startUpdateFlightTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        preparePopover()
    }
    
    func rotated() {
        updatePopoverConstraint()
    }
    
    func preparePopover() {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        popoverView = PopoverView(frame: frame)
        popoverView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(popoverView)
        
        let popoverViewLeadingConstraint = popoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        popoverViewLeadingConstraint.isActive = true
        popoverViewTrailingConstraint = popoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        popoverViewTrailingConstraint.isActive = true

        popoverViewTopConstraint = popoverView.topAnchor.constraint(equalTo: view.bottomAnchor)
        popoverViewTopConstraint.isActive = true
        popoverViewHeightConstraint = popoverView.heightAnchor.constraint(equalToConstant: 0)
        popoverViewHeightConstraint.isActive = true
        
        updatePopoverConstraint()
    }
    
    func updatePopoverConstraint() {
        let displayWidth = view.frame.width
        let displayHeight = view.frame.height - navigationController!.navigationBar.frame.height
        
        let isPortlate = displayHeight >= displayWidth
        if (isPortlate) {
            let height = displayHeight / 2
            popoverViewTrailingConstraint.constant = 0
            popoverViewTopConstraint.constant = popoverOpened ? -height : 0
            popoverViewHeightConstraint.constant = height
            
            mapView.padding.left = 0
            mapView.padding.bottom = popoverOpened ? height : 0
        }
        else {
            let width = displayWidth / 2
            popoverViewTrailingConstraint.constant = -width
            popoverViewTopConstraint.constant = popoverOpened ? -displayHeight : 0
            popoverViewHeightConstraint.constant = displayHeight
            
            mapView.padding.left = popoverOpened ? width : 0
            mapView.padding.bottom = 0
        }
    }
    
    func openPopover(flight: Flight?) {
        activate(flight: flight)
        popoverView.set(flight: activeFlight)
        
        UIView.animate(withDuration: 0.3) {
            self.popoverOpened = true
            self.updatePopoverConstraint()
            self.view.layoutIfNeeded()
        }
    }
    
    func closePopover() {
        activate(flight: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.popoverOpened = false
            self.updatePopoverConstraint()
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func test() {
        updateFlights()
    }
    
    func startUpdateFlightTimer() {
        stopUpdateFlightTimer()
        
        timerUpdateFlights = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateFlights), userInfo: nil, repeats: true)
    }
    
    func stopUpdateFlightTimer() {
        timerUpdateFlights.invalidate()
    }
    
    func updateFlights() {
        print("updateFlights()")
        req.fetch(coordination: [originLat, originLong]) {data, res, err in
            if err != nil {
                print("ERR \(err!)")
                return
            }
            
            DispatchQueue.main.async {
                self.updateMarkers(states: data!)
            }
        }
    }
    
    func updateMarkers(states: [OpenSkyState]) {
        var oldMarkers = markers
        var oldFlights = flights
        
        markers = [String: GMSMarker]()
        flights = [String: Flight]()
        
        for s in states {
            // still available
            if let m = oldMarkers[s.icao24] {
                oldMarkers.removeValue(forKey: s.icao24)
                markers[s.icao24] = m
                
                m.position.latitude = s.latitude!
                m.position.longitude = s.longitude!
                m.rotation = s.heading!
                
                let flight = oldFlights[s.icao24]!
                flights[s.icao24] = flight
                
                flight.stretchPath(lat: s.latitude!, long: s.longitude!)
                flight.updateLine()
            }
            // new commer
            else {
                let planePosition = CLLocationCoordinate2D(latitude: s.latitude!, longitude: s.longitude!)
                let newFlight = GMSMarker(position: planePosition)
                newFlight.title = s.icao24
                newFlight.icon = UIImage(named: "Plane1")
                newFlight.rotation = s.heading!
                newFlight.userData = s.icao24
                newFlight.map = mapView
                
                markers[s.icao24] = newFlight
                buildFirstPath(state: s)
            }
        }
        
        // they have gone
        for (icao24, m) in oldMarkers {
            if icao24 == activeFlight?.icao24 {
                closePopover()
            }
            
            m.map = nil
            oldFlights[icao24]!.line.map = nil
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
        let flight = Flight(state: state)
        
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
        if marker == yvrMarker {
            closePopover()
        }
        else {
            var flight: Flight? = nil
            
            if let icao24 = marker.userData as? String {
                flight = flights[icao24]
            }
            
            openPopover(flight: flight)
        }
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        closePopover()
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
        else {
            activeFlight = nil
        }
    }
}

