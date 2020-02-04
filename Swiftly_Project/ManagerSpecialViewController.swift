//
//  ManagerSpecialViewController.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/29/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit
import CoreData

class ManagerSpecialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var specialItems: [NSManagedObject]?
    var canvasUnit: Int = 16
    
    private let reuseIdentifier = "SPECIAL_CELL"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let size = UIScreen.main.bounds
            flowLayout.estimatedItemSize = CGSize(width: size.width - 16, height: 100)
        }
        
        NetworkController.fetchData { (data, error) in
            let dataDictionary = (data as! NSDictionary)
            self.canvasUnit = (dataDictionary["canvasUnit"] as! Int)
            DispatchQueue.main.async {
                self.refreshItems((dataDictionary["managerSpecials"] as! NSArray))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ManagerSpecialCollectionViewCell
        let item = (self.specialItems![indexPath.row] as! SpecialItem)
        
        cell.newPriceLabel.text = item.price
        cell.letterLabel.text = "A"
        cell.originalPriceLabel.text = item.originalPrice
        cell.productLabel.text = item.displayName
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        
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
    
    func refreshItems(_ items: NSArray) {
        self.saveItems(items)
        self.specialItems = CoreDataController.fetchItems()
        self.collectionView.reloadData()
    }
    
    func saveItems(_ items: NSArray) {
        CoreDataController.delteAllItems()
        for item in items {
            CoreDataController.saveItem(item as! NSDictionary)
        }
    }
    
}
