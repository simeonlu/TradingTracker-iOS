//
//  TradingStoreCommonTest.swift
//  PortfolioTrackerTests
//
//  Created by Shimin lyu on 20/1/2024.
//

import XCTest
import CoreData
@testable import PortfolioTracker

class TradingStoreCommonTest: XCTestCase {
    var context: NSManagedObjectContext {
        repo.persistenceController.sharedContext
    }
    
    var repo: TradingDataRepo!
    
    override func setUpWithError() throws {
        repo = TradingDataRepo(inMemory: true)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}

extension TradingStoreCommonTest {
    func populateDummyData() {
        let now = Date()
        let entity = TradeEntity(context: context)
        entity.date = now
        entity.price = NSDecimalNumber(10.023)
        entity.quantity = 100
        entity.ticker = "APPL"
        entity.type = 0
        entity.remarks = "Test Stock"
        
        let date1 = Date(timeInterval: -24 * 60 * 60, since: Date())
        let entity1 = TradeEntity(context: context)
        entity1.date = date1
        entity1.price = NSDecimalNumber(110.023)
        entity1.quantity = 1000
        entity1.ticker = "TSLA"
        entity1.type = 0
        entity1.remarks = "Test Stock1"
        
        let date2 = Date(timeInterval: -2 * 24 * 60 * 60, since: Date())
        let entity2 = TradeEntity(context: context)
        entity2.date = date2
        entity2.price = NSDecimalNumber(340.89)
        entity2.quantity = 500
        entity2.ticker = "AMD"
        entity2.type = 1
        entity2.remarks = "Test Stock2"
        
        try? context.save()
    }
    
    func generateSingleEntity() -> TradeEntity {
        let date2 = Date(timeInterval: -3 * 24 * 60 * 60, since: Date())
        let entity = TradeEntity(context: context)
        entity.date = date2
        entity.price = NSDecimalNumber(35.1)
        entity.quantity = 100
        entity.ticker = "Meta"
        entity.type = 0
        entity.remarks = "Test Stock - Meta"
        return entity
    }
    
    func generateSingleTradeObject() -> Trade {
        let date = Date(timeInterval: -3 * 24 * 60 * 60, since: Date())
        return Trade(tradedDate: date,
                     price: 35.1,
                     quantity: 100,
                     ticker: "Meta",
                     remarks: "Test Stock - Meta",
                     type: .long,
                     id: NSManagedObjectID())
        
    }
}
