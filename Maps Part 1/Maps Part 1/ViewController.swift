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

    // Interface builder connections
    @IBOutlet weak var mapViewOutlet: MKMapView!
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    
    // User defined variables
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing location manager delegate
        locationManager.delegate = self
    
        // Setting up location manager properties
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    
        // Initializing mapview delegate
        mapViewOutlet.delegate = self
        
        // Setting up mapview properties
        mapViewOutlet.showsUserLocation = true
        
        // Adding a target(action) to the segement controller
        segmentedControlOutlet.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
    }

    
    // Segement controller tapped(value changed) action
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

    
    // Add annotation button pressed action
    @IBAction func addAnnotationButtonPressed(_ sender: Any) {
        
        // Adding an annotation to the map
        
        let annotation = CoffeeAnnotation()
        annotation.title = "Coffee Shop at Gateway"
        annotation.subtitle = "Let's grab some coffee !!"
        annotation.imageURL = "coffee-pin.png"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 18.923071, longitude: 72.834183)
        mapViewOutlet.addAnnotation(annotation)
        
    }
}

extension ViewController : MKMapViewDelegate {
    
    // This method will be called upon updating user location
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//
//        // Zooming into current user location
//        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050))
//        mapView.setRegion(region, animated: true)
//
//    }
    
    // This method will be used for rendering annotations with custom properties, in this case, we are adding image to the annotation. IN THIS METHOD WE ARE DEALING WITH THE BASIC ANNOTATION(PIN)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        // This condition will show the user location annotation, if this is not called, then user location annotation will not be displayed.
        if annotation is MKUserLocation {
            return nil
        }

        // This code is basically to render a mapview with annotations, just like rendering tableview cells in a table view

        // Checking for reusable mapview annotation view
        var coffeeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CoffeeAnnotationView")

        // If the annotation view not found, then we are creating a new one
        if coffeeAnnotationView == nil {

            coffeeAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CoffeeAnnotationView")
            coffeeAnnotationView?.canShowCallout = true

            // Changing anootation view(pin popup view) styles
//            configureView(annotationView: coffeeAnnotationView!)
            
            // Displaying picture automatically taken by iPhone at the time of clicking annotation pin(Super cool feature)
            configureSnapShotView(annotationView: coffeeAnnotationView!)
        } else {

            coffeeAnnotationView?.annotation = annotation
        }

        // Type casting annotation as custom created coffeeanotaion so that we can add image to that view
        if let coffeeAnnotation = annotation as? CoffeeAnnotation {

            coffeeAnnotationView?.image = UIImage(named: coffeeAnnotation.imageURL)
        }

        // returing the annotation view
        return coffeeAnnotationView

    }
    
    
//    // MKMarkerView is used for changing annotation(pin) styles.
//
//    // This method is same as above, but here we are dealing with changing the properties of pin(annotation) using MKMarkerView
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        // This condition will show the user location annotation, if this is not called, then user location annotation will not be displayed.
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        // This code is basically to render a mapview with annotations, just like rendering tableview cells in a table view
//
//        // Checking for reusable mapview annotation view
//        var coffeeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CoffeeAnnotationView") as? MKMarkerAnnotationView
//
//        // If the annotation view not found, then we are creating a new one
//        if coffeeAnnotationView == nil {
//
//            coffeeAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CoffeeAnnotationView")
//            coffeeAnnotationView?.canShowCallout = true
//
//            // Annotation(Pin) color
//            coffeeAnnotationView?.markerTintColor = UIColor.blue
//
//            // Mention text in the Annotation(Pin)
//            coffeeAnnotationView?.glyphText = "SS"  // Don't use long texts here
//            // Glyph text color
//            coffeeAnnotationView?.glyphTintColor = UIColor.black
//
//            // Mention emoji in the Annotation(Pin). Control+Command+Space for emoji's
//            coffeeAnnotationView?.glyphText = "☕️"
//
////            configureView(annotationView: coffeeAnnotationView!)
//            configureSnapShotView(annotationView: coffeeAnnotationView!)
//
//        } else {
//
//            coffeeAnnotationView?.annotation = annotation
//        }
//
//        // returing the annotation view
//        return coffeeAnnotationView
//
//    }
    
    
    
    // Changing annotation popup view(pin view) styles and adding subviews
    func configureView(annotationView : MKAnnotationView) {
        
        // Adding image to the title and subtitle view on the left side
        annotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "coffee-pin.png"))
        
        // Adding image to the title and subtitle view on the right side
        annotationView.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "chevron-flat.png"))
        
        // Adding a custom view into the title and subtitle view
        let customView = UIView(frame: CGRect.zero)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        customView.backgroundColor = UIColor.cyan
        
        annotationView.detailCalloutAccessoryView = customView
        
    }
    
    // Adding image to the annotation view(pin view), the image is taken by iphone itself using MKMapSnapShotter
    func configureSnapShotView(annotationView : MKAnnotationView) {
        
        let snapshotSize = CGSize(width: 200, height: 200)
        
        let snapshotView = UIView(frame: CGRect.zero)
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        snapshotView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let options = MKMapSnapshotter.Options()
        options.size = snapshotSize
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: (annotationView.annotation?.coordinate)!, fromDistance: 10, pitch: 65, heading: 0)
        
        let snapShotter = MKMapSnapshotter(options: options)
        
        snapShotter.start { (snapshot, error) in
            
            if let snapshot = snapshot {
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: snapshotSize.width, height: snapshotSize.height))
                imageView.image = snapshot.image
                snapshotView.addSubview(imageView)
            }
        }
        
        annotationView.detailCalloutAccessoryView = snapshotView
        
    }
}

extension ViewController : CLLocationManagerDelegate {
    
}

