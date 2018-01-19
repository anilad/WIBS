//
//  GameViewController.swift
//  WIBS
//
//  Created by Team-Uno on 1/18/18.
//  Copyright © 2018 Team-Uno. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GameViewController: UIViewController, CLLocationManagerDelegate  {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var foundButton: UIButton!
    
    let locationManager = CLLocationManager()

    var playerLocation : CLLocation?
    var playerLatMax: CLLocationDegrees?
    var playerLatMin: CLLocationDegrees?
    var playerLongMax: CLLocationDegrees?
    var playerLongMin: CLLocationDegrees?
    var playerName: String?
    
    var counter = 0
    var brendanLocation: CLLocationCoordinate2D?
    //    var eliLocation: [Double]?
    //    var pointsOfInterest = ["gameRoom": [37.37554088,-121.91023318], "lovelace": [37.375573178, -121.91022820], "kitchen": [37.37575393, -121.91031510], "matsumoto": [37.37541758, -121.91017262], "table": [37.37542329, -121.91007052], "openSpace": [37.37548103, -121.91002319]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        foundButton.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        scoreLabel.text = "0"
        playerNameLabel.text = playerName
        
        let tempLocation = CLLocationCoordinate2DMake(CLLocationDegrees(37.37554088), CLLocationDegrees(-121.91023318))
        brendanLocation = tempLocation
        
        locationManager.startUpdatingLocation()
        monitorRegionAtLocation(center: brendanLocation!, identifier: "Brendan")
        
//        change later to not hardcode coordinates
//        brendanLocation = setTargetCoordinates()
//        eliLocation = setTargetCoordinates()
//        while eliLocation! == brendanLocation! {
//             eliLocation = setTargetCoordinates()
//        }
//        print("Brendan Location: ", brendanLocation)
//        print("Eli Location: ", eliLocation)
    }
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
            break
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
            break
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func disableMyLocationBasedFeatures(){
        print("disableMyLocationBasedFeatures")
    }
    
    func enableMyWhenInUseFeatures(){
        print("enableMyWhenInUseFeaatures")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30.0  // In meters.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        playerLocation = location
        print ("PlayerLocation: \(playerLocation!.coordinate.latitude), \(playerLocation!.coordinate.longitude)")
    }
    
    @IBAction func foundButtonPressed(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        performSegue(withIdentifier: "brendanSegue", sender: self)
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the app is authorized.
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Make sure region monitoring is supported.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                let maxDistance = locationManager.maximumRegionMonitoringDistance
                let region = CLCircularRegion(center: center,
                                              radius: maxDistance, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = false
                
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
    
}
