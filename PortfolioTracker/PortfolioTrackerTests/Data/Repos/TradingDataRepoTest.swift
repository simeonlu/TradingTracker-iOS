//
//  TradingDataRepoTest.swift
//  PortfolioTrackerTests
//
//  Created by Shimin lyu on 20/1/2024.
//

import XCTest
@testable import PortfolioTracker

final class TradingDataRepoTest: TradingStoreCommonTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRepoList() throws {
        // Given
        populateDummyTradesData()
        
        // When
        let trades = try repo.tradeList(from: Date(timeInterval: -4 * 24 * 60 * 60, since: Date()), till: Date())
        let trade1 = trades.first!
        // Then
        XCTAssertEqual(trades.count, 3)
        XCTAssertEqual(trade1.ticker, "APPL")
    }
    
    func testRepoLookUp() throws {
        // Given
        populateDummyTradesData()
        
        // When
        let trades = try repo.trades(of: "AMD", from: Date(timeInterval: -4 * 24 * 60 * 60, since: Date()), till: Date())
        let trade1 = trades.first
        
        // Then
        XCTAssertEqual(trades.count, 1)
        XCTAssertNotNil(trade1)
        XCTAssertEqual(trade1!.ticker, "AMD")
        XCTAssertEqual(trade1!.price, 340.89)
        XCTAssertEqual(trade1!.quantity, 500)
        XCTAssertEqual(trade1!.remarks, "Test Stock2")
        XCTAssertEqual(trade1!.type, TradingType.short)
        XCTAssertEqual(trade1!.tradedDate.formatted(date: .abbreviated, time: .shortened),
                       Date(timeInterval: -2 * 24 * 60 * 60, since: Date()).formatted(date: .abbreviated, time: .shortened))
    }
    
    func testRepoStore() throws {
        // Given
        populateDummyTradesData()
        let dummyTrade = generateSingleTradeObject()
        
        // When
        let isStored = try repo.storeTrades([dummyTrade])
        let trades = try repo.trades(of: "Meta", from: Date(timeInterval: -4 * 24 * 60 * 60, since: Date()), till: Date())
        let trade = trades.first!
        // Then
        XCTAssertTrue(isStored)
        XCTAssertEqual(trade.ticker, "Meta")
        XCTAssertEqual(trade.price, 35.1)
        XCTAssertEqual(trade.quantity, 100)
        XCTAssertEqual(trade.remarks, "Test Stock - Meta")
        XCTAssertEqual(trade.type, TradingType.long)
        XCTAssertEqual(trade.tradedDate.formatted(date: .abbreviated, time: .shortened),
                       Date(timeInterval: -3 * 24 * 60 * 60, since: Date()).formatted(date: .abbreviated, time: .shortened))
        
        // When
        try repo.removeTrades([trade])
        let trades2 = try repo.trades(of: "Meta", from: Date(timeInterval: -4 * 24 * 60 * 60, since: Date()), till: Date())
        
        // Then
        XCTAssertTrue(trades2.isEmpty)
    }
}
