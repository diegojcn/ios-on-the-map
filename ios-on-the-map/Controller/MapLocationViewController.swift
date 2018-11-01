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

class MapLocationViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var json: NSArray!
    
    
    override func viewDidLoad() {
        
      super.viewDidLoad()

       getStudentLocation()
       
    }
    
    private func getStudentLocation(){
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print(error)
                return
            }
          
            if let json : NSArray = parsedResult?["results"] as! NSArray {
                
                self.json = json
                self.populateMapAndList(json: self.json)
                
                let extractedExpr : StudentsTableViewController = navigationController?.pushViewController(StudentsTableViewController, animated: false)
                
                
                
            } else{
               print("Nenhum resultado retornado")
            }
            
        }
        task.resume()
        
    }
    
    
    private func populateMapAndList(json: NSArray){

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
                
                print("\(first) \(last)")
            }
           
        }

        self.mapView.addAnnotations(annotations)
        
    }
    
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



