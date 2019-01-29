//
//  MapLocationViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 29/10/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapLocationViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var udacityService : UdacityService!
    
    var students : [Student]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let studentsWraped = self.students {
            
            populateMap(studentsList: studentsWraped)
        }
        
    }
    
    @IBAction func newLocation(_ sender: Any) {
        
        performSegue(withIdentifier: "newLocationSegue", sender: nil)
    }
    
    public func populateMap(studentsList: [Student]){
        if self.mapView != nil {
            var annotations = [MKPointAnnotation]()
            
            for studentItem  in studentsList {
                
                
                let annotation = MKPointAnnotation()
                
                let lat = CLLocationDegrees(studentItem.latitude)
                let long = CLLocationDegrees(studentItem.longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                annotation.coordinate = coordinate
                annotation.title = "\(studentItem.firstName) \(studentItem.lastName)"
                annotation.subtitle = studentItem.mediaURL
                
                annotations.append(annotation)
                
                
                
            }
            
            
            self.mapView.addAnnotations(annotations)
            
        }
    }
    
}


extension MapLocationViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newLocationSegue" {
            
            let newLocationViewController = segue.destination as! NewLocationViewController
            newLocationViewController.udacityService  = self.udacityService
            
        }
    }
    
}

extension MapLocationViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}



