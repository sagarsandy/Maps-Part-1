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

    
    // MARK: Segement controller action for value changed
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


    // MARK: Adding annotation to the mapview
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

// MARK: Map view delegate methods extension

extension ViewController : MKMapViewDelegate {
    
    // This method will be called upon updating user location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        // Zooming into current user location
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)

    }
    
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
            
            // This will show basic default callout view(Annotation or pin selected view)
//            coffeeAnnotationView?.canShowCallout = true   // Commented because we are rendering custom callout view in didselect delegate method

            // Changing anootation view(pin popup view) styles
//            configureView(annotationView: coffeeAnnotationView!)
            
            // Displaying picture automatically taken by iPhone at the time of clicking annotation pin(Super cool feature)
//            configureSnapShotView(annotationView: coffeeAnnotationView!)
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
    
    
    // Rendering complete custom callout view(Annotation/pin view), this is delegate method and will be called automatically once you click on annotation(pin)
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Checking annotation type is custom created coffee annotation or not
        guard let annotation = view.annotation as? CoffeeAnnotation else { return }
        
        // Create custom callout view
        let coffeeCalloutView = UIView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y+50, width: 200, height: 70))
        coffeeCalloutView.translatesAutoresizingMaskIntoConstraints = false
        coffeeCalloutView.layer.cornerRadius = 10.0
        coffeeCalloutView.layer.masksToBounds = true
        coffeeCalloutView.backgroundColor = UIColor.blue
        view.addSubview(coffeeCalloutView)
        
        // Setting up auto layout for the callout view based on annotaiton location
        coffeeCalloutView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        coffeeCalloutView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coffeeCalloutView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -5).isActive = true
        coffeeCalloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        // Adding lable to the callout(Annotation) view
        let titleLable = UILabel(frame: CGRect(x: 10, y: 10, width: 70, height: 30))
        titleLable.text = annotation.title
        titleLable.textColor = UIColor.white
        coffeeCalloutView.addSubview(titleLable)
        
        // Setting up autolayout to the title label
        titleLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLable.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLable.bottomAnchor.constraint(equalTo: coffeeCalloutView.topAnchor, constant: -5).isActive = true
        titleLable.centerXAnchor.constraint(equalTo: coffeeCalloutView.centerXAnchor).isActive = true
        
        
    }
    
    
    // This delegate method will be fired once user clicks anywhere in the map, other than annotation(pin)
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        // Deleting custom callout view(Annotation/pin) view
        view.subviews.forEach { (subview) in
            
            subview.removeFromSuperview()
        }
        
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
    
    // Adding a location image to the annotation view(pin view), the image is taken by iphone itself using MKMapSnapShotter
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



// MARK: Location manager delegate methods extension


extension ViewController : CLLocationManagerDelegate {
    
}

