//
//  NewLocationViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 01/11/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NewLocationViewController: UIViewController{
    
    @IBOutlet weak var newStudentView: NewStudentView!
    
    override func viewWillAppear(_ animated: Bool) {
       subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewLocationViewController.keyboardChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewLocationViewController.keyboardChange(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewLocationViewController.keyboardChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func saveNewLocation(_ sender: UIButton) {
        
       saveAndPinNewLocation(newStudentView: self.newStudentView)
        
        performSegue(withIdentifier: "back", sender: nil)
        
        
    }
    
    
    @IBAction func findInTheMap(_ sender: UIButton) {
        
        let alert = displayLoading(customMessage: "Finding location ...")
         present(alert, animated: true)
        
        var localSearchRequest : MKLocalSearch.Request = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = newStudentView.locationTxt.text
        var localSearch : MKLocalSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            var pointAnnotation : MKPointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.newStudentView.locationTxt.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.newStudentView.locationCoordinate = pointAnnotation.coordinate
            
            var pinAnnotationView : MKPinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.newStudentView.mapView.centerCoordinate = pointAnnotation.coordinate
        self.newStudentView.mapView.removeAnnotations(self.newStudentView.mapView.annotations)
        self.newStudentView.mapView.addAnnotation(pinAnnotationView.annotation!)
            
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
           

        }
    }
    
    @objc func keyboardChange(_ notification:Notification) {
        
        if(notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification ){

            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self.newStudentView, action: #selector(self.newStudentView.hideKeyboard))
            tapGesture.cancelsTouchesInView = false
            
            self.view.addGestureRecognizer(tapGesture)
        }
        
    }
    
    func saveAndPinNewLocation(newStudentView: NewStudentView){
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let firstName = newStudentView.nameTxt.text, let lastName = newStudentView.lastNameTxt.text, let mapString =  newStudentView.locationTxt.text, let mediaURL = newStudentView.linkTxt.text, let latitude = newStudentView.locationCoordinate?.latitude, let longitude = newStudentView.locationCoordinate?.longitude else{
            print("Erro")
            return
        }
        let uniqueKey = Int(arc4random_uniform(UInt32(99999)))
        let body = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        request.httpBody = body.data(using: String.Encoding.utf8)
    
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print(error)
                return
            }
            
        }
        task.resume()
        
    }
    
    

}
