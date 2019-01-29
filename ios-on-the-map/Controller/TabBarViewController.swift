//
//  TabBarViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 08/11/18.
//  Copyright © 2018 dj. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var students : [Student]?
    
    var udacityService : UdacityService!
    
    var userLogedIn : User!
    
    var map : MapLocationViewController?
    
    var std : StudentsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchAllStudentsLocation()
        
         if let navMapLocationViewController : UINavigationController = self.viewControllers?[0] as? UINavigationController, let navStudentLocationViewController  : UINavigationController = self.viewControllers?[1] as? UINavigationController {
            
            self.map = navMapLocationViewController.topViewController as? MapLocationViewController
            self.std = navStudentLocationViewController.topViewController as? StudentsTableViewController
            
            self.map!.udacityService = self.udacityService
            self.map!.udacityService = self.udacityService
         }
        
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        
        searchAllStudentsLocation()
    }
    
    
    func populateStudentList(list : NSArray) -> [Student]{
        
        var lisfOfStudents : [Student] = []
        
        for dictionary  in list {
            
            let student = dictionary as! [String : Any]
            
            if let latitude = student["latitude"] as? Double, let longitude =  student["longitude"]  as? Double, let first = student["firstName"] as? String, let last = student["lastName"] as? String, let mediaURL = student["mediaURL"]  as? String {
                
                let newStudent = Student(firstName: first, lastName: last, latitude: latitude, longitude: longitude, mediaURL: mediaURL, mapString: "")
                lisfOfStudents.append(newStudent)
                
            }
            
        }
        return lisfOfStudents
    }
    
    
    private func searchAllStudentsLocation(){
        
        udacityService.searchAllStudentsLocation(resultHandler: {result,error in
            
            if let result = result {
                
                if let results : NSArray = result["results"] as? NSArray {
                    
                    self.students = self.populateStudentList(list: results)
                    self.map!.students = self.students
                    self.std!.students = self.students
                    performUIUpdatesOnMain {
                        self.map!.populateMap(studentsList: self.students!)
                        self.std!.reloadTableView()
                    }
                    
                    
                    
                }
            }
        })
        
    }
    
}


