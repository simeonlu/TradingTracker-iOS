//
//  TradingPersistence.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 20/1/2024.
//

import Foundation
import CoreData

enum StoreStatus {
    case unInit
    case normal
    case fatal(NSError)
}

struct TradingPersistenceController {
    
    let container: NSPersistentCloudKitContainer
    
    var sharedContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(inMemory: Bool, modelName: String = "Trading") {
        
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't load \(modelName).momd from main Bundle")
        }
        container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: model)
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
       
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func initPersistentStore(storeReadinessCompletion: ((NSError?) -> Void)? = nil) {
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                storeReadinessCompletion?(error)
              #if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
              #endif
            }
            storeReadinessCompletion?(nil)
        })
    }
}
