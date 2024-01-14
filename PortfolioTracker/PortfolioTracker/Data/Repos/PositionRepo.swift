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
    /// - Returns: array of trade that match those criterias
    func listOfTrades(for ticker: String, from: Date, till to: Date, ascending: Bool) -> [Trade]
    
    /// fetch trade data from DB
    /// - Parameters:
    ///   - from: from which date to search
    ///   - to: to which date to search
    ///   - ascending: true then sort by Asc, Des otherwise
    /// - Returns: array of trade items that match those criterias
    func listOfTrades(from: Date, till to: Date, ascending: Bool) -> [Trade]
    
    /// Save trades
    /// - Parameter trades: Trades to save
    /// - Returns: true if success, false otherwise
    func storeTrades(_ trades: [Trade]) -> Bool
    
    /// remove trades
    /// - Parameter trade: trades to be removed
    func removeTrades(_ trade: [Trade])
    
}
