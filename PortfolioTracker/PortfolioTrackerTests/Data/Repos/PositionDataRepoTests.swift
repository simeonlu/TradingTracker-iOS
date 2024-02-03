//
//  PositionDataRepoTests.swift
//  PortfolioTrackerTests
//
//  Created by Shimin lyu on 3/2/2024.
//

import XCTest
import CoreData
@testable import PortfolioTracker

final class PositionDataRepoTests: TradingStoreCommonTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    override func tearDownWithError() throws {
      
    }
       
    func testPositionRepoList() throws {
            // Given
            populateDummyPositionData()
            let range = Date(timeInterval: -5 * 24 * 60 * 60, since: Date())..<Date()
            // When
            let positions = try repo.positionList(between: range, ascending: true)
            let position = positions.first!
            // Then
            XCTAssertEqual(positions.count, 3)
            XCTAssertEqual(position.ticker, "AMD")
        }
    func testRepoLookUp() throws {
        // Given
        populateDummyPositionData()
        let range = Date(timeInterval: -5 * 24 * 60 * 60, since: Date())..<Date()
        // When
        let positions = try repo.positions(of: "AMD", dateRange: range, ascending: true)
        let position = positions.first
        
        // Then
        XCTAssertEqual(positions.count, 1)
        XCTAssertNotNil(position)
        XCTAssertEqual(position!.ticker, "AMD")
        XCTAssertEqual(position!.type, TradingType.short)
        XCTAssertEqual(position!.startedDate.formatted(date: .abbreviated, time: .shortened),
                       Date(timeInterval: -2 * 24 * 60 * 60, since: Date()).formatted(date: .abbreviated, time: .shortened))
    }
    
    func testRepoStorePosition() throws {
        // Given
        populateDummyPositionData()
        let dummyTrade = generateSingleTradeObject()
        let rawPos = Position(asset: .stock,
                                closedDate: nil,
                                startedDate: dummyTrade.tradedDate,
                                type: dummyTrade.type,
                                quantity: UInt32(dummyTrade.quantity),
                                ticker: dummyTrade.ticker,
                                trades: [dummyTrade],
                                id: NSManagedObjectID())
             
        // When
        let isStored = try repo.storePositions([rawPos])
        let positions = try repo.positions(of: "Meta",
                                        dateRange: Date(timeInterval: -4 * 24 * 60 * 60, since: Date())..<Date(),
                                        ascending: true)
        let position = positions.first!
        // Then
        XCTAssertTrue(isStored)
        XCTAssertEqual(position.ticker, "Meta")
        XCTAssertEqual(position.type, TradingType.long)
        XCTAssertEqual(position.startedDate.formatted(date: .abbreviated, time: .shortened),
                       Date(timeInterval: -3 * 24 * 60 * 60, since: Date()).formatted(date: .abbreviated, time: .shortened))
        
        // When
        try repo.removePositions([position])
        let result = try repo.positions(of: "Meta",
                                        dateRange: Date(timeInterval: -5 * 24 * 60 * 60, since: Date())..<Date(),
                                        ascending: true)
        // Then
        XCTAssertTrue(result.isEmpty)
    }
}
