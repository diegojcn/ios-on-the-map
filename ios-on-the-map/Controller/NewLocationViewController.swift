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
    
    @IBAction func findInTheMap(_ sender: UIButton) {
        
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
            
            
            var pinAnnotationView : MKPinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.newStudentView.mapView.centerCoordinate = pointAnnotation.coordinate
            self.newStudentView.mapView.removeAnnotations(self.newStudentView.mapView.annotations)
            self.newStudentView.mapView.addAnnotation(pinAnnotationView.annotation!)
        
        
        
        }
    }
    
    @objc func keyboardChange(_ notification:Notification) {
        
        if(notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification ){

            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self.newStudentView, action: #selector(self.newStudentView.hideKeyboard))
            tapGesture.cancelsTouchesInView = false
            
            self.view.addGestureRecognizer(tapGesture)
        }
        
    }

}
