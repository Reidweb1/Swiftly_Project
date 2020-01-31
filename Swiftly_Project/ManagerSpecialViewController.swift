//
//  ManagerSpecialViewController.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/29/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit

class ManagerSpecialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var specialItems: NSArray?
    var canvasUnit: Int = 16
    
    private let reuseIdentifier = "SPECIAL_CELL"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        NetworkController.fetchData { (data, error) in
            let dataDictionary = (data as! NSDictionary)
//            self.specialItems = (dataDictionary["managerSpecials"] as! NSArray)
            self.canvasUnit = (dataDictionary["canvasUnit"] as! Int)
            self.saveItems((dataDictionary["managerSpecials"] as! NSArray))
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ManagerSpecialCollectionViewCell
        let item = (self.specialItems![indexPath.row] as! NSDictionary)
        cell.newPriceLabel.text = (item["price"] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.specialItems != nil) ? self.specialItems!.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
    func getFrame(_ item: NSDictionary) -> CGRect {
        return CGRect(x: 20, y: 20, width: 100, height: 100)
    }
    
    func saveItems(_ items: NSArray) {
        
    }
    
}
