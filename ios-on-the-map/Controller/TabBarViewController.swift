//
//  TabBarViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 08/11/18.
//  Copyright © 2018 dj. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var json : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.searchAllStudentsLocation()
        
       
        
        print("viewDidLoad TabBarViewController")
    }
    
    private func searchAllStudentsLocation(){
        
       
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print(error)
                return
            }
            
            if let json : NSArray = parsedResult?["results"] as? NSArray {
                
                self.json = json
               
                if let navMapLocationViewController : UINavigationController = self.viewControllers?[0] as? UINavigationController, let navStudentLocationViewController  : UINavigationController = self.viewControllers?[1] as? UINavigationController {
                    
                    let map : MapLocationViewController =  navMapLocationViewController.topViewController as! MapLocationViewController
                    
                    let std : StudentsTableViewController =  navStudentLocationViewController.topViewController as! StudentsTableViewController
                    
                    map.json = json
                    std.json = json
                    map.viewDidLoad()
                    std.viewDidLoad()
                    
                }
                
                
                
            } else{
                print("Nenhum resultado retornado")
            }
            
        }
        task.resume()
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        print("willBeginCustomizing")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        

    }
    
}


