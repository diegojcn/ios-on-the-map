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
    
    var udacityService : UdacityService!
    
    var user : User?
    
    override func viewDidLoad() {
        self.loginView.userTextField.text = "diegojcn@gmail.com"
         self.loginView.passTextField.text = "digao171"
    }

    @IBAction func login(_ sender: UIButton) {
        
        self.loginView.msgLbl.text = ""
        let alert = displayLoading(customMessage: "Please Wait")
        present(alert, animated: true)
        
        if let user = loginView.userTextField.text, let pass = loginView.passTextField.text {
            
            let user : User = User (name: user, lastName: "", password : pass)
            autenticate(user: user)
            
            
        }
        
    }
    
}

extension LoginViewController {
    
    private func autenticate(user: User) {
        
        udacityService.autenticate(user: user) { (result, error) in
            
            guard let dictionarySession = result!["session"] else {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: {
                        self.loginView.msgLbl.text = "Usuário ou Senha inválido!"
                    })
                    
                }
                return
            }
            
            if let userId : String = dictionarySession["id"] as? String  {
                
                self.udacityService.getUser(id: userId) { (result, error) in
                    
                    if let result = result {
                        
                        if let firstName = result["first_name"] as? String, let lastName = result["last_name"] as? String {
                            self.user = User (name: firstName, lastName: lastName, password : "")
                            
                            performUIUpdatesOnMain {
                                
                                self.dismiss(animated: true, completion: {
                                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                })
                                
                            }
                            
                        }
                        
                    }
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: {
                            self.loginView.msgLbl.text = "Usuário ou Senha inválido!"
                        })
                    }
                    
                    
                }
                
            }
            
        }
        
    }

}

extension LoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            
            let topViewController = segue.destination as! TabBarViewController
            
            topViewController.udacityService  = self.udacityService
            topViewController.userLogedIn = self.user
            
        }
    }
}

