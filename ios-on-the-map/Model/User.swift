//
//  User.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 02/11/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation

struct User {
    
    var name : String
    
    var lastName : String
    
    var password : String
    
    init(name : String, lastName : String,  password : String) {
    
        self.name = name
        self.lastName = lastName
        self.password = password
    }
    
}
