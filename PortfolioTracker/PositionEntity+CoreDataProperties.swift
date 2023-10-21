//
//  PositionEntity+CoreDataProperties.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 21/10/2023.
//
//

import Foundation
import CoreData


extension PositionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PositionEntity> {
        return NSFetchRequest<PositionEntity>(entityName: "PositionEntity")
    }

    @NSManaged public var closedDate: Date?
    @NSManaged public var maxRisk: Float
    @NSManaged public var quantity: Int16
    @NSManaged public var startedDate: Date?
    @NSManaged public var stopLossPrice: NSDecimalNumber?
    @NSManaged public var ticker: String?
    @NSManaged public var trades: NSSet?

}

// MARK: Generated accessors for trades
extension PositionEntity {

    @objc(addTradesObject:)
    @NSManaged public func addToTrades(_ value: TradeEntity)

    @objc(removeTradesObject:)
    @NSManaged public func removeFromTrades(_ value: TradeEntity)

    @objc(addTrades:)
    @NSManaged public func addToTrades(_ values: NSSet)

    @objc(removeTrades:)
    @NSManaged public func removeFromTrades(_ values: NSSet)

}

extension PositionEntity : Identifiable {

}
