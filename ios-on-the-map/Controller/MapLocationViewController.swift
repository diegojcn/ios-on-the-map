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
    
    public var json: NSArray!
    
    
    override func viewDidLoad() {
        
      super.viewDidLoad()
        
        print("viewDidLoad MapLocationViewController")
        if let jsonWrap = self.json {
            
            populateMap(json: jsonWrap)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear MapLocationViewController")
        
    }
    
    
    private func populateMap(json: NSArray){

        var annotations = [MKPointAnnotation]()

        for dictionary  in json {
            
            let student = dictionary as! [String : Any]
            let annotation = MKPointAnnotation()
            
            if let latitude = student["latitude"], let longitude =  student["longitude"], let first = student["firstName"] as? String, let last = student["lastName"] as? String, let mediaURL = student["mediaURL"]  as? String{
                
                let lat = CLLocationDegrees(student["latitude"] as! Double)
                let long = CLLocationDegrees(student["longitude"] as! Double)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
            
                annotations.append(annotation)
                
            }
           
        }

        self.mapView.addAnnotations(annotations)
        
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



