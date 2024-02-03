//
//  Position.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 2/2/2024.
//

import Foundation
import CoreData
/*
 //
@NSManaged public var category: String?
@NSManaged public var closedDate: Date?
@NSManaged public var quantity: Int16
@NSManaged public var startedDate: Date?
@NSManaged public var ticker: String?
@NSManaged public var type: Int16
@NSManaged public var trades: NSSet?
*/

struct Position {
    
    /// refer to different asset, like: Stock, future or currency
    let asset: PositionAssetType
    /// The date when position is closed.
    let closedDate: Date?
    /// The date when position is opened.
    let startedDate: Date
    ///  Two type for trading now, long/short
    let type: TradingType
    let quantity: UInt32
    let ticker: String
    let trades: [Trade]
    let id: NSManagedObjectID
}

extension Position {
    var isClosed: Bool {
        guard let date = closedDate else {
            return false
        }
        return date < Date()
    }
}

extension PositionEntity {
    var mapToPosition: Position? {
        let tradeSet = tradeModels
        guard let date = startedDate,
              let ticker = ticker,
              tradeSet.isNotEmpty else {
            return nil
        }
    
        let quantity = tradeSet.reduce(0) { partialResult, item in
            partialResult + item.quantity
        }
        return Position(asset: categoryPresenting,
                        closedDate: closedDate,
                        startedDate: date,
                        type: TradingType(rawValue: type) ?? .long,
                        quantity: UInt32(quantity),
                        ticker: ticker,
                        trades: tradeSet,
                        id: objectID
        )
    }
    
    var categoryPresenting: PositionAssetType {
        guard let categoryStored = assetType,
              let categoryPresented = PositionAssetType(rawValue: categoryStored) else {
            return .unknown
        }
        return categoryPresented
    }
    var tradeModels: [Trade] {
        guard let tradeSet = trades else { return [] }
        return tradeSet.compactMap { item in
            guard let tradeEntity = item as? TradeEntity else { return nil }
            return tradeEntity.mapToTrade
        }
    }
}

extension Position {
    func mapToEntity(with context: NSManagedObjectContext) -> PositionEntity {
        let entity = PositionEntity(context: context)
        let tradeEntities = trades.compactMap {
            $0.mapToEntity(with: context)
        }
        entity.startedDate = startedDate
        entity.closedDate = closedDate
        entity.assetType = asset.rawValue
        entity.ticker = ticker
        entity.type = type.rawValue
        entity.trades = NSSet(array: tradeEntities)
        return entity
    }
}
