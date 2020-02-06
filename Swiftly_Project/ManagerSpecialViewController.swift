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
    
    /**
     * Instance Variables and IBOutlets
     */
    
    var refreshControl = UIRefreshControl()
    
    var specialItems: [NSManagedObject]?
    var canvasUnit: Int16 = 16
    
    private let reuseIdentifier = "SPECIAL_CELL"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    /**
     * View Controller LifeCycle
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        reloadData()
    }
    
    /**
     * UICollectionView Delegate and Data Source
     */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ManagerSpecialCollectionViewCell
        let item = (self.specialItems![indexPath.row] as! SpecialItem)
        
        // If the imageUrl is present, begin loading the image asynchronously
        if (item.imageUrl != nil) {
            cell.imageView.asyncImage(item.imageUrl!)
        }
        
        // Format the price Strings
        let original = (item.originalPrice != nil) ? "$" + item.originalPrice! : ""
        let strikePrice: NSMutableAttributedString =  NSMutableAttributedString(string: original)
        strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikePrice.length))
        cell.originalPriceLabel.attributedText = strikePrice
        
        cell.newPriceLabel.text =  (item.price != nil) ? "$" + item.price! : ""
        cell.productLabel.text = item.displayName
        
        // Size labels basedw off of CanvasUnit
        self.sizeLabels(item, cell)
        
        // Create drop shadow and border for the cell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = (self.specialItems![indexPath.row] as! SpecialItem)
        return self.getSize(item)
    }
    
    /**
     * Helper Functions
     */
    
    func sizeLabels(_ item: SpecialItem, _ cell: ManagerSpecialCollectionViewCell) {
        // Create the size unit based off of the Canvas Unit and the device screen size
        let unit = (UIScreen.main.bounds.width - 24) / CGFloat(canvasUnit)
        let width = unit * CGFloat(item.width)
        let height = unit * CGFloat(item.height)
        
        // Create sizeConstant used for the image and price labels
        let sizeConstant = (width > height) ? height * 0.25 : width * 0.25
        cell.imageWidth.constant = sizeConstant
        cell.imageHeight.constant = sizeConstant
        
        cell.productLabelHeight.constant = height - (sizeConstant + 24)
        
        cell.oldPriceHeight.constant = sizeConstant*0.5
        cell.oldPriceWidth.constant = sizeConstant
        cell.newPriceHeight.constant = sizeConstant*0.5
        cell.newPriceWidth.constant = sizeConstant
    }
    
    // Get the cell size used in the `collectionViewLayout` delegate method
    func getSize(_ item: SpecialItem) -> CGSize {
        let unit = (UIScreen.main.bounds.width - 24) / CGFloat(canvasUnit)
        let width = unit * CGFloat(item.width)
        let height = unit * CGFloat(item.height)
        
        return CGSize(width: width, height: height)
    }
    
    // Show a simple `UIAlertController` on an error.
    func showAlert() {
        let title: String = "An Error Occurred"
        let message: String = "Sorry there was a problem fetching the special data. Try again"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Save new items to CoreData and reload the local store
    func refreshItems(_ items: NSArray) {
        self.saveItems(items)
        self.fetchLocalItems()
    }
    
    // Fetch items from the local store and refresh the collectionView
    func fetchLocalItems() {
        self.specialItems = CoreDataController.fetchItems()
        self.collectionView.reloadData()
        self.collectionView.refreshControl!.endRefreshing()
    }
    
    // Delete existing items and save new ones to the local store.
    func saveItems(_ items: NSArray) {
        CoreDataController.deleteAllItems()
        for item in items {
            CoreDataController.saveItem(item as! NSDictionary)
        }
    }
    
    // Fetch, store and reload all data - this is used as the `RefreshControl` selector funtion
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
    
}
