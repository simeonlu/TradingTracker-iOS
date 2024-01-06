//
//  Persistence.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 25/2/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for num in 0..<10 {
            let newItem = TradeEntity(context: viewContext)
            newItem.date = Date()
            newItem.ticker = "stock_\(num)"
            newItem.price = 10.1
            newItem.quantity = 100
            newItem.type = TradingType.long
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. 
            // You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false, modelName: String = "Trading") {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't load \(modelName).momd from main Bundle")
        }
        container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
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
              #if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
              #endif
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}