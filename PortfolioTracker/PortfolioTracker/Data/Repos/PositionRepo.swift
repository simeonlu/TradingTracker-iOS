//
//  PositionRepo.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 26/3/2023.
//

import Foundation
protocol TradingRepo {
    
    /// fetch trade data from DB
    /// - Parameters:
    ///   - ticker: stock ticker
    ///   - from: from which date to search
    ///   - to: to which date to search
    ///   - ascending: if it is true then sort by Asc, Des otherwise
    /// - Returns: array of trade that match those criteria
    func trades(of ticker: String, from: Date, till to: Date, ascending: Bool) throws -> [Trade]
    
    /// fetch trade data from DB
    /// - Parameters:
    ///   - from: from which date to search
    ///   - to: to which date to search
    ///   - ascending: true then sort by Asc, Des otherwise
    /// - Returns: array of trade items that match those criteria
    func tradeList(from: Date, till to: Date, ascending: Bool) throws -> [Trade]
    
    /// Save trades
    /// - Parameter trades: Trades to save
    /// - Returns: true if success, false otherwise
    func storeTrades(_ trades: [Trade]) throws -> Bool
    
    /// remove trades
    /// - Parameter trade: trades to be removed
    func removeTrades(_ trade: [Trade]) throws
    
    /// fetch positions from DB
    /// - Parameters:
    ///   - ticker: stock ticker/name
    ///   - dateRange: searching time range
    ///   - ascending: true then sort by Asc, Des otherwise
    /// - Returns: array of Positions
    func positions(of ticker: String, dateRange: Range<Date>, ascending: Bool) throws -> [Position]
    
    /// fetch positions data from DB
    /// - Parameters:
    ///   - between: searching time range
    ///   - ascending: true then sort by Asc, Des otherwise
    /// - Returns: array of positions items that match those criteria
    ///
    func positionList(between: Range<Date>, ascending: Bool) throws -> [Position]
    
    /// Save trades
    /// - Parameter positions: Position to save
    /// - Returns: true if success, false otherwise
    func storePositions(_ positions: [Position]) throws -> Bool
    
    /// remove trades
    /// - Parameter trade: Position to be removed
    func removePositions(_ positions: [Position]) throws
}
