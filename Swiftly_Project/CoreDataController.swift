//
//  CoreDataController.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/31/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit
import CoreData

public let idKey: String = "id"
public let dateKey: String = "createdAt"
public let widthKey: String = "width"
public let heightKey: String = "height"
public let priceKey: String = "price"
public let imageUrlKey: String = "imageUrl"
public let originalPriceKey: String = "originalPrice"
public let displayNameKey: String = "displayName"

class CoreDataController: NSObject {

    /**
     * Save a new record with the values provided.
     */
    class func saveItem(_ data: NSDictionary, _ persistentContainer: NSPersistentContainer? = nil) {
        let managedContext: NSManagedObjectContext = CoreDataController.getContext(persistentContainer)
        let entity = NSEntityDescription.entity(forEntityName: "SpecialItem", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        let uuid = UUID()
        
        item.setValue(Date(), forKeyPath: dateKey)
        item.setValue(uuid.uuidString, forKeyPath: idKey)
        item.setValue(data["display_name"], forKey: displayNameKey)
        item.setValue(data["original_price"], forKey: originalPriceKey)
        item.setValue(data["width"], forKey: widthKey)
        item.setValue(data["height"], forKey: heightKey)
        item.setValue(data["imageUrl"], forKey: imageUrlKey)
        item.setValue(data["price"], forKey: priceKey)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /**
     * Fetch and return all existing records.
     */
    class func fetchItems(_ persistentContainer: NSPersistentContainer? = nil) -> [NSManagedObject] {
        let managedContext: NSManagedObjectContext = CoreDataController.getContext(persistentContainer)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SpecialItem")
        
        do {
            let templates = try managedContext.fetch(fetchRequest)
            return templates
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    /**
     * Fetch and return a single record.
     */
    class func fetchItem(_ id: String, _ persistentContainer: NSPersistentContainer? = nil) -> NSManagedObject? {
        let managedContext: NSManagedObjectContext = CoreDataController.getContext(persistentContainer)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SpecialItem")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let template = try managedContext.fetch(fetchRequest)
            return template.first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    /**
     * Delete the record provided.
     */
    class func delete(_ item: NSManagedObject, _ persistentContainer: NSPersistentContainer? = nil) {
        let managedContext: NSManagedObjectContext = CoreDataController.getContext(persistentContainer)
        managedContext.delete(item)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func deleteAllItems() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SpecialItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print ("Error on delete all items. \(error)")
        }
    }
    
    /**
     * Get the relevant NSManagedObjectContext based on whether or not we're in the
     * test suite.
     */
    class func getContext(_ persistentContainer: NSPersistentContainer? = nil) -> NSManagedObjectContext {
        /**
         * This is used for the mocked CoreData stack in the Test Suite.
         */
        if (persistentContainer != nil) {
            return persistentContainer!.viewContext
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not access AppDelegate from CoreDataController")
        }
        
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
}
