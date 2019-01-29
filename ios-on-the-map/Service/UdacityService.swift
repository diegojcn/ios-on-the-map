//
//  UdacityService.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 27/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import Foundation


class UdacityService {
    
    public func autenticate(user: User, resultHandler: @escaping (_: [String:AnyObject]?, _ : Error?) -> Void ){
        
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
                    
                    throw NSError(domain: "Usuário ou senha inválida", code: 171, userInfo: ["userName":user.name])
                }
                
                resultHandler(parsedResult, error)
                
            } catch {
                
                resultHandler(nil, error)
                return
            }
            
        }
        task.resume()
        
    }
    
    func getUser(id : String, resultHandler: @escaping (_: [String:AnyObject]?, _ : Error?) -> Void ){
        
        let request = NSMutableURLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(id)")!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            do {
                guard let parsedResult: [String:AnyObject] = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String:AnyObject] else {
                    throw NSError(domain: "Problema em recuperar o usuário! ", code: 171, userInfo: ["user id":id])
                }
                
                
                resultHandler(parsedResult, error)
                
            } catch {
                resultHandler(nil, error)
                return
            }
            
        }
        task.resume()
        
    }
    
    func searchAllStudentsLocation(resultHandler: @escaping (_: [String:AnyObject]?, _ : Error?) -> Void ) {
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            do {
                if error != nil {
                    throw NSError(domain: "Nenhuma Localização encontratada!", code: 171, userInfo: ["":""])
                    
                }
                
                guard let parsedResult: [String:AnyObject] = try (JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]) else {
                    throw NSError(domain: "Nenhuma Localização encontratada!", code: 171, userInfo: ["":""])
                }
                
                resultHandler(parsedResult, error)
                
            } catch {
                resultHandler(nil, error)
                return
            }
            
            
        }
        task.resume()
        
        
    }
    
    func saveAndPinNewLocation(student: Student, resultHandler: @escaping (_: [String:AnyObject]?, _ : Error?) -> Void ) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let firstName : String = student.firstName,
            let lastName : String = student.lastName,
            let mapString : String =  student.mapString,
            let mediaURL : String = student.mediaURL,
            let latitude : Double = student.latitude ,
            let longitude : Double  = student.longitude else {
                print("Erro")
                return
        }
        let uniqueKey = Int(arc4random_uniform(UInt32(99999)))
        let body = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            do {
                let parsedResult: [String:AnyObject] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                
                resultHandler(parsedResult, error)
                
            } catch {
                print(error)
                return
            }
            
        }
        task.resume()
    }
    
}

