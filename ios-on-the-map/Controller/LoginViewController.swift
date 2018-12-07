//
//  ViewController.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 29/10/18.
//  Copyright © 2018 dj. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginView: LoginView!
    
    public func autenticate(user: User){
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(user.name)\", \"password\": \"\(user.password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func displayError(_ error: String) {
                print(error)
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
           
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String:AnyObject]
           
                performUIUpdatesOnMain {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            
            } catch {
                print("Could not parse the data as JSON: '\(String(describing: data))'")
                return
            }
    
        }
        task.resume()
        
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        
        if let user = loginView.userTextField.text, let pass = loginView.passTextField.text {
            
            let user : User = User (name: user, lastName: "", password : pass)
//            autenticate(user: user)
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }
        
    }
    
}

