//
//  Constants.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 01/11/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation

struct Constants {
    
    static let APIScheme = "https://"
    
    // MARK: Flickr
    struct ParseAPI {
        
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes"
        
        static let MethodStudentLocation = "StudentLocation"
        
        static let ParameterAPIKey = "X-Parse-REST-API-Key"
        static let ParameterApplicationId = "X-Parse-REST-API-Key"
        
        static func getURL(method : String) -> String {
            
            return "\(Constants.APIScheme.description) \(APIHost.description) \(APIPath.description) \(method)"
            
        }
        
    }
    
    
    
}


