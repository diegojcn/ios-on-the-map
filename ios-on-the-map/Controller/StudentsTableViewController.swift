//
//  CollectionStudentsViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 31/10/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation
import UIKit

class StudentsTableViewController : UITableViewController{
    
    var jsonResults : NSArray?
    
    @IBOutlet weak var nameTld : UITextField?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        let student = jsonResults?[indexPath.item] as! [String : Any]
        
        let first = student["firstName"] as? String
        let last = student["lastName"] as? String
        let mediaURL = student["mediaURL"]  as? String
    
        cell?.textLabel?.text = "\(first) \(last)"
        cell?.imageView?.image = nil
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return jsonResults?.count ?? 0
    }
    
}
