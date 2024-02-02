//
//  PositionExtTests.swift
//  PortfolioTrackerTests
//
//  Created by Shimin lyu on 2/2/2024.
//

import XCTest
import CoreData
@testable import PortfolioTracker

final class PositionExtTests: XCTestCase {
    var context: NSManagedObjectContext!
    override func setUpWithError() throws {
        let persistence = TradingPersistenceController(inMemory: true)
        persistence.initPersistentStore()
        context = persistence.container.viewContext
    }
    
    func testEntityMapToPositionModel() throws {
        // GIVEN
        let now = Date()
        let entity = PositionEntity(context: context)
        entity.startedDate = now
        entity.category = "stock"
        entity.quantity = 100
        entity.ticker = "APPL"
        entity.type = 0
        entity.addToTrades(dummyTrade.mapToEntity(with: context))
        // When
        try context.save()
        let position = entity.mapToPosition
        let trade = position?.trades.first
        
        // Then
        XCTAssertEqual(position?.quantity, 100)
        XCTAssertEqual(position?.category, PositionCategory.stock)
        XCTAssertEqual(position?.ticker, "APPL")
        XCTAssertEqual(position?.startedDate, now)
        XCTAssertEqual(position?.type, TradingType(rawValue: 0))
        XCTAssertNotNil(trade)
        XCTAssertEqual(trade!.ticker, "TSLA")
        XCTAssertEqual(position?.id, entity.objectID)
    }
    
    func testEntityMapToPositionModel_nil_ticker() throws {
        // GIVEN
        let now = Date()
        let entity = PositionEntity(context: context)
        entity.startedDate = now
        entity.category = "stock"
        entity.quantity = 100
        entity.type = 0
        entity.addToTrades(dummyTrade.mapToEntity(with: context))
        // When
        // Then
        XCTAssertThrowsError(try context.save()) { _ in
            XCTAssertTrue(true)
        }
    }
    
    func testEntityMapToPositionModel_nil_startDate() throws {
        // GIVEN
        let entity = PositionEntity(context: context)
        entity.category = "stock"
        entity.startedDate = nil
        entity.quantity = 100
        entity.type = 0
        entity.ticker = "APPL"
        entity.addToTrades(dummyTrade.mapToEntity(with: context))
        // When
        // Then
        XCTAssertThrowsError(try context.save()) { _ in
            XCTAssertTrue(true)
        }
    
    }
    
    func testPositionModelMapToEntity() throws {
        // GIVEN
        let now = Date()
        let position = Position(category: .cryptoCurrency,
                                closedDate: nil,
                                startedDate: now,
                                type: .long,
                                quantity: 100,
                                ticker: "TSLA",
                                trades: [dummyTrade],
                                id: NSManagedObjectID()
        )
        // When
        let entity = position.mapToEntity(with: context)
        // Then
        XCTAssertEqual(entity.quantity, 100)
        XCTAssertNil(entity.closedDate)
        XCTAssertEqual(entity.ticker, "TSLA")
        XCTAssertEqual(entity.startedDate, now)
        XCTAssertEqual(entity.type, TradingType.long.rawValue)
        XCTAssertEqual(entity.trades?.count, 1)
        XCTAssertTrue(entity.objectID.isTemporaryID)
    }
    
}

let dummyTrade = Trade(tradedDate: Date(),
                       price: Decimal(0.01),
                       quantity: 120,
                       ticker: "TSLA",
                       remarks: "EV Uptrend",
                       type: .long,
                       id: NSManagedObjectID())
