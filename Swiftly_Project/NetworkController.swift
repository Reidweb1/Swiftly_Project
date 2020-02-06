//
//  NetworkController.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/30/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit

enum FetchDataError: Error {
    case MissingData
}

class NetworkController: NSObject {

    static func fetchData(_ completion: @escaping (_ data: Any?, _ error: Error?) -> Void ) {
        let url = URL(string: "https://raw.githubusercontent.com/Swiftly-Systems/code-exercise-ios/master/backup")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if (error != nil) {
                completion(nil, error)
            }
            
            do {
                if (data != nil) {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                    completion(jsonResult, nil)
                } else {
                    throw FetchDataError.MissingData
                }
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }

        task.resume()
    }
    
}
