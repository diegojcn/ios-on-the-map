//
//  CollectionStudentsViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 31/10/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation
import UIKit

class StudentsTableViewController : UITableViewController {
    
    public var json : NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        let student = json?[indexPath.item] as! [String : Any]
        
        if let first = student["firstName"] as? String,
            let last = student["lastName"] as? String,
            let mediaURL = student["mediaURL"]  as? String {
            
             cell?.textLabel?.text = "\(first) \(last)"
            
        }
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return json?.count ?? 0
    }
    
}
