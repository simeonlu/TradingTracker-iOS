//
//  TradeExtensionTest.swift
//  PortfolioTrackerTests
//
//  Created by Shimin lyu on 14/1/2024.
//

import XCTest
import CoreData
@testable import PortfolioTracker

final class TradeExtensionTest: XCTestCase {

    var context: NSManagedObjectContext!
    override func setUpWithError() throws {
        let persistence = TradingPersistenceController(inMemory: true)
        persistence.initPersistentStore()
        context = persistence.container.viewContext
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEntityMapToTradeModel() throws {
        // GIVEN
        let now = Date()
        let entity = TradeEntity(context: context)
        entity.date = now
        entity.price = NSDecimalNumber(10.023)
        entity.quantity = 100
        entity.ticker = "APPL"
        entity.type = 0
        entity.remarks = "Test Stock"
        // When
        try context.save()
        let trade = entity.mapToTrade

        // Then
        XCTAssertEqual(trade?.quantity, 100)
        XCTAssertEqual(trade?.price, Decimal(10.023))
        XCTAssertEqual(trade?.ticker, "APPL")
        XCTAssertEqual(trade?.tradedDate, now)
        XCTAssertEqual(trade?.type, TradingType(rawValue: 0))
        XCTAssertEqual(trade?.remarks, "Test Stock")
        XCTAssertEqual(trade?.id, entity.objectID)
    }

    func testTradeModelMapToEntity() throws {
        // GIVEN
        let now = Date()
        let trade = Trade(tradedDate: now,
                          price: Decimal(0.01),
                          quantity: 120,
                          ticker: "TSLA",
                          remarks: "EV Uptrend",
                          type: .long,
                          id: NSManagedObjectID())
        // When
        let entity = trade.mapToEntity(with: context)
        // Then
        XCTAssertEqual(entity.quantity, 120)
        XCTAssertEqual(entity.price?.doubleValue, 0.01)
        XCTAssertEqual(entity.ticker, "TSLA")
        XCTAssertEqual(entity.date, now)
        XCTAssertEqual(entity.type, TradingType.long.rawValue)
        XCTAssertEqual(entity.remarks, "EV Uptrend")
        XCTAssertTrue(entity.objectID.isTemporaryID)
    }

}
