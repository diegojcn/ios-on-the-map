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
    
    var students : [Student]!
    
    var udacityService : UdacityService!
    
    public func reloadTableView(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func newLocation(_ sender: Any) {
        
        performSegue(withIdentifier: "newLocationSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        let student = students[indexPath.row]
        
        cell?.textLabel?.text = "\(student.firstName) \(student.lastName)"
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    
}

extension StudentsTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newLocationSegue" {
            
            let newLocationViewController = segue.destination as! NewLocationViewController
            newLocationViewController.udacityService  = self.udacityService
            
        }
    }
    
}
