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
    
    var udacityService : UdacityService!
    
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
        
        let localSearchRequest : MKLocalSearch.Request = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = newStudentView.locationTxt.text
        let localSearch : MKLocalSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            self.newStudentView.mapView.removeAnnotations(self.newStudentView.mapView.annotations)
             self.newStudentView.msgErrorTxt.text = ""
            if localSearchResponse == nil{
                self.newStudentView.msgErrorTxt.text = "Location not found!"
                self.dismiss(animated: true, completion: nil)
                return
            }
            //3
            let pointAnnotation : MKPointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.newStudentView.locationTxt.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.newStudentView.locationCoordinate = pointAnnotation.coordinate
            
            let pinAnnotationView : MKPinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.newStudentView.mapView.centerCoordinate = pointAnnotation.coordinate
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
        
        guard let lastName : String = newStudentView.lastNameTxt.text,
            let firstName : String = newStudentView.nameTxt.text,
            let mediaURL  : String = newStudentView.linkTxt.text,
            let mapSgtring  : String = newStudentView.locationTxt.text,
            let latitude : Double = newStudentView.locationCoordinate?.latitude,
            let longitude : Double = newStudentView.locationCoordinate?.longitude else {
                newStudentView.msgErrorTxt.text = "Não foi possivel salvar os dados!"
                return
        }
        newStudentView.msgErrorTxt.text = ""
        let student : Student = Student(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mediaURL: mediaURL, mapString: mapSgtring)
        
        udacityService.saveAndPinNewLocation(student: student, resultHandler: {_,_ in })
        
        performSegue(withIdentifier: "back", sender: nil)
    }
    
    
    
}

extension NewLocationViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            
            let controller = segue.destination as! TabBarViewController
            controller.udacityService  = self.udacityService
            
        }
    }
    
}
