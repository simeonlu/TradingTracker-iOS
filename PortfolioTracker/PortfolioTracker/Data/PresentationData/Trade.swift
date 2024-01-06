//
//  Trade.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 26/3/2023.
//

import Foundation

struct Trade {
    let tradedDate: Date
    let price: Decimal
    let quantity: UInt32
    let ticker: String
}

extension TradeEntity {
    var mapToTrade: Trade? {
        guard let date = date,
              let price = price?.decimalValue,
              let ticker = ticker else {
            return nil
        }
        return Trade(tradedDate: date, price: price, quantity: quantity, ticker: ticker)
    }
}
