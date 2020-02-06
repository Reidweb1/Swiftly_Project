//
//  Swiftly_ProjectTests.swift
//  Swiftly_ProjectTests
//
//  Created by Reid Weber on 2/5/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import XCTest
import CoreData
@testable import Swiftly_Project

class Swiftly_ProjectTests: XCTestCase {

    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()

    func testCreate() {
        let data = getDummyData()

        let specials = data.value(forKey: "managerSpecials") as! Array<Any>
        for item in specials {
            CoreDataController.saveItem(item as! NSDictionary, mockPersistantContainer)
        }

        let fetchedModels = CoreDataController.fetchItems(mockPersistantContainer)
        XCTAssertTrue((fetchedModels.count == 2), "Make sure fetched models contains two records")
    }
    
    func testDelete() {
        let data = getDummyData()

        let specials = data.value(forKey: "managerSpecials") as! Array<Any>
        for item in specials {
            CoreDataController.saveItem(item as! NSDictionary, mockPersistantContainer)
        }

        let fetchedModels = CoreDataController.fetchItems(mockPersistantContainer)
        XCTAssertTrue((fetchedModels.count == 2), "Make sure fetched models contains two records")
        
        CoreDataController.delete(fetchedModels[0], mockPersistantContainer)
        
        let updatedModels = CoreDataController.fetchItems(mockPersistantContainer)
        XCTAssertTrue((updatedModels.count == 1), "Make sure there is only record left")
    }
    
    // Helper function to build dummy data
    private func getDummyData() -> NSMutableDictionary {
        var specials: [Any] = []
        
        let specialOne: NSMutableDictionary = NSMutableDictionary()
        let dummyUrlOne = "https://raw.githubusercontent.com/Swiftly-Systems/code-exercise-ios/master/images/L.png"
        specialOne.setValue(dummyUrlOne, forKey: "imageUrl")
        specialOne.setValue(16, forKey: "width")
        specialOne.setValue(8, forKey: "height")
        specialOne.setValue("Noodle Dish with Roasted Black Bean Sauce", forKey: "display_name")
        specialOne.setValue("2.00", forKey: "original_price")
        specialOne.setValue("1.00", forKey: "price")
        
        let specialTwo: NSMutableDictionary = NSMutableDictionary()
        let dummyUrlTwo = "https://raw.githubusercontent.com/Swiftly-Systems/code-exercise-ios/master/images/J.png"
        specialTwo.setValue(dummyUrlTwo, forKey: "imageUrl")
        specialTwo.setValue(8, forKey: "width")
        specialTwo.setValue(8, forKey: "height")
        specialTwo.setValue("Onion Flavored Rings", forKey: "display_name")
        specialTwo.setValue("2.00", forKey: "original_price")
        specialTwo.setValue("1.00", forKey: "price")
        
        specials.append(specialOne)
        specials.append(specialTwo)
        
        let dummyData: NSMutableDictionary = NSMutableDictionary()
        dummyData.setValue(specials, forKey: "managerSpecials")
        return dummyData
    }

}
