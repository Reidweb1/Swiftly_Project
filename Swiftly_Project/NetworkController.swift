//
//  NetworkController.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/30/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit

class NetworkController: NSObject {

    static func fetchData(_ completion: @escaping (_ data: Any?, _ error: Error?) -> Void ) {
        let url = URL(string: "https://prestoq.com/ios-coding-challenge")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if (error != nil) {
                completion(nil, error)
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                completion(jsonResult, nil)
                
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }

        task.resume()
    }
    
}
