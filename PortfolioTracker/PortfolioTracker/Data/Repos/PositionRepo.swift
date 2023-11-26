//
//  PositionRepo.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 26/3/2023.
//

import Foundation
protocol TradingRepo {
    //fetch data from data store
    func listOfTrades(for ticker: String, from: Date, till to: Date) -> [Trade]
    func listOfTrades(from: Date, till to: Date)
    func storeTrades(_ trades: [Trade])
    func removeTrade(_ trade: Trade)
    func insertTrade(_ trade: Trade)
}
