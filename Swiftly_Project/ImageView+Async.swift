//
//  ImageView+Async.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 2/4/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func asyncImage(_ urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
}
