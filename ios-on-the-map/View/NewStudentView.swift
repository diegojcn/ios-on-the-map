//
//  NewStudentView.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 01/11/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class NewStudentView : UIView {
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    
    @IBOutlet weak var linkTxt: UITextField!
    
    @IBOutlet weak var locationTxt: UITextField!
    
    @IBOutlet weak var msgErrorTxt: UILabel!
    
    @IBOutlet weak var mapView : MKMapView!
    
    var locationCoordinate: CLLocationCoordinate2D?
    
    @objc func hideKeyboard()
    {
        self.nameTxt.resignFirstResponder()
        self.lastNameTxt.resignFirstResponder()
        self.linkTxt.resignFirstResponder()
        self.locationTxt.resignFirstResponder()
    }
    
}
