//
//  Trade.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 26/3/2023.
//

import Foundation
import CoreData

struct Trade {
    let tradedDate: Date
    let price: Decimal
    let quantity: Int32
    let ticker: String
    let remarks: String
    let type: TradingType
    let id: NSManagedObjectID
}

extension TradeEntity {
    var mapToTrade: Trade? {
        guard let date = date,
              let price = price?.decimalValue,
              let ticker = ticker else {
            return nil
        }
        return Trade(tradedDate: date,
                     price: price,
                     quantity: quantity,
                     ticker: ticker,
                     remarks: remarks ?? .empty,
                     type: TradingType(rawValue: type) ?? .long,
                     id: objectID
        )
    }
}

extension Trade {
    func mapToEntity(with context: NSManagedObjectContext) -> TradeEntity {
        let entity = TradeEntity(context: context)
        entity.date = tradedDate
        entity.price = price as NSDecimalNumber
        entity.quantity = quantity
        entity.ticker = ticker
        entity.type = type.rawValue
        entity.remarks = remarks
        return entity
    }
}
