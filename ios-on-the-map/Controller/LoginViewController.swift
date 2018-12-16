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
        
        let request = NSMutableURLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(user.name)\", \"password\": \"\(user.password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
           
            do {
                guard let parsedResult: [String:AnyObject] = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String:AnyObject] else {
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                guard let dictionarySession = parsedResult["session"] else {
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                guard let userId : String = dictionarySession["id"] as! String else {
                    performUIUpdatesOnMain {
                       self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                
                self.getUser(id: userId)
                
            
            } catch {
                print("Could not parse the data as JSON: '\(String(describing: data))'")
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
    
        }
        task.resume()
        
    }
    
    private func getUser(id : String){
        
        let request = NSMutableURLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(id)")!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            
            do {
                guard let parsedResult: [String:AnyObject] = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String:AnyObject] else {
                    performUIUpdatesOnMain {
                       self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                guard let name = parsedResult["first_name"] as? String, let lastName = parsedResult["last_name"] as? String else {
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                let user : User = User (name: name, lastName: lastName, password : "")
                performUIUpdatesOnMain {
                    
                    self.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    })
                    
                    
                }
                
                
            } catch {
                print("Could not parse the data as JSON: '\(String(describing: data))'")
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
        }
        task.resume()
        
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        
       
        let alert = displayLoading(customMessage: "Please Wait")
        present(alert, animated: true)
        
        if let user = loginView.userTextField.text, let pass = loginView.passTextField.text {
            
            let user : User = User (name: user, lastName: "", password : pass)
            autenticate(user: user)
        
            
        }
        
    }
    
}

