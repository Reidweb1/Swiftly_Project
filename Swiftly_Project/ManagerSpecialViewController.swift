//
//  ManagerSpecialViewController.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/29/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit
import CoreData

class ManagerSpecialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var refreshControl = UIRefreshControl()
    
    var specialItems: [NSManagedObject]?
    var canvasUnit: Int16 = 16
    
    private let reuseIdentifier = "SPECIAL_CELL"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ManagerSpecialCollectionViewCell
        let item = (self.specialItems![indexPath.row] as! SpecialItem)
        
        if (item.imageUrl != nil) {
            cell.imageView.asyncImage(item.imageUrl!)
        }
        
        let original = (item.originalPrice != nil) ? "$" + item.originalPrice! : ""
        let strikePrice: NSMutableAttributedString =  NSMutableAttributedString(string: original)
        strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikePrice.length))
        cell.originalPriceLabel.attributedText = strikePrice
        
        cell.newPriceLabel.text =  (item.price != nil) ? "$" + item.price! : ""
        cell.productLabel.text = item.displayName
        
        self.sizeLabels(item, cell)
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SECTION_HEADER", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.specialItems != nil) ? self.specialItems!.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
    func sizeLabels(_ item: SpecialItem, _ cell: ManagerSpecialCollectionViewCell) {
        let unit = (UIScreen.main.bounds.width - 24) / CGFloat(canvasUnit)
        let width = unit * CGFloat(item.width)
        let height = unit * CGFloat(item.height)
        
        let imageConstant = (width > height) ? height * 0.25 : width * 0.25
        cell.imageWidth.constant = imageConstant
        cell.imageHeight.constant = imageConstant
        
        print("THE VALUE??? \(height - (imageConstant + 24))")
        cell.productLabelHeight.constant = height - (imageConstant + 24)
        
//        cell.newPriceLabel.font = cell.newPriceLabel.font.withSize(10)
//        cell.originalPriceLabel.font = cell.originalPriceLabel.font.withSize(10)
//
//        cell.productLabel.font = cell.productLabel.font.withSize(6)
    }
    
    func getSize(_ item: SpecialItem) -> CGSize {
        let unit = (UIScreen.main.bounds.width - 24) / CGFloat(canvasUnit)
        let width = unit * CGFloat(item.width)
        let height = unit * CGFloat(item.height)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = (self.specialItems![indexPath.row] as! SpecialItem)
        return self.getSize(item)
    }
    
    func showAlert() {
        let title: String = "An Error Occurred"
        let message: String = "Sorry there was a problem fetching the special data. Try again"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func reloadData() {
        NetworkController.fetchData { (data, error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.fetchLocalItems()
                    self.showAlert()
                }
                return
            }
            let dataDictionary = (data as! NSDictionary)
            self.canvasUnit = (dataDictionary["canvasUnit"] as! Int16)
            DispatchQueue.main.async {
                self.refreshItems((dataDictionary["managerSpecials"] as! NSArray))
            }
        }
    }
    
    func refreshItems(_ items: NSArray) {
        self.saveItems(items)
        self.fetchLocalItems()
    }
    
    func fetchLocalItems() {
        self.specialItems = CoreDataController.fetchItems()
        self.collectionView.reloadData()
        self.collectionView.refreshControl!.endRefreshing()
    }
    
    func saveItems(_ items: NSArray) {
        CoreDataController.deleteAllItems()
        for item in items {
            CoreDataController.saveItem(item as! NSDictionary)
        }
    }
    
}
