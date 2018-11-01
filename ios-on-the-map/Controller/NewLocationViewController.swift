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
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    
    @IBOutlet weak var linkTxt: UITextField!
    
    @IBOutlet weak var locationTxt: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        localSearchRequest.naturalLanguageQuery = locationTxt.text
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
            pointAnnotation.title = self.locationTxt.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            var pinAnnotationView : MKPinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = pointAnnotation.coordinate
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
        
        
        
        }
    }
    
    @objc func keyboardChange(_ notification:Notification) {
//        view.frame.origin.y = 0
//        if(notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification ){
//
//            view.frame.origin.y -= getKeyboardHeight(notification)
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(self.hideKeyboard))
            tapGesture.cancelsTouchesInView = false
            
            self.view.addGestureRecognizer(tapGesture)
            
//        }else {
//            view.frame.origin.y = 0
//        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height/2
    }
    
    @objc func hideKeyboard()
    {
        self.nameTxt.resignFirstResponder()
        self.lastNameTxt.resignFirstResponder()
        self.linkTxt.resignFirstResponder()
    }
    
    
}
