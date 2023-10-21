//
//  TradeEntity+CoreDataProperties.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 21/10/2023.
//
//

import Foundation
import CoreData


extension TradeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TradeEntity> {
        return NSFetchRequest<TradeEntity>(entityName: "TradeEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var quantity: Int32
    @NSManaged public var ticker: String?
    @NSManaged public var type: Int16
    @NSManaged public var position: PositionEntity?

}

extension TradeEntity : Identifiable {

}
