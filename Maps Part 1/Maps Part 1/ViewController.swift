//
//  ViewController.swift
//  Maps Part 1
//
//  Created by Sagar Sandy on 22/11/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapViewOutlet: MKMapView!
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    
        mapViewOutlet.delegate = self
        
        mapViewOutlet.showsUserLocation = true
        
        segmentedControlOutlet.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
    }

    
    @objc func mapTypeChanged(segementedControl : UISegmentedControl) {
        
        switch segementedControl.selectedSegmentIndex {
            case 0:
                mapViewOutlet.mapType = .standard
            case 1:
                mapViewOutlet.mapType = .satellite
            case 2:
                mapViewOutlet.mapType = .hybrid
            default:
                mapViewOutlet.mapType = .standard
        }
    }

}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        // Zooming into current user location
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050))
        mapView.setRegion(region, animated: true)
        
    }
}

extension ViewController : CLLocationManagerDelegate {
    
}

