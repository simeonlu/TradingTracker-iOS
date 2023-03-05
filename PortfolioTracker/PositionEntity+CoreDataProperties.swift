//
//  PositionEntity+CoreDataProperties.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 5/3/2023.
//
//

import Foundation
import CoreData


extension PositionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PositionEntity> {
        return NSFetchRequest<PositionEntity>(entityName: "PositionEntity")
    }

    @NSManaged public var maxRisk: Float
    @NSManaged public var quantity: Int32
    @NSManaged public var stopLossPrice: NSDecimalNumber?
    @NSManaged public var custStopLoss: NSDecimalNumber?
    @NSManaged public var openingDate: Date?
    @NSManaged public var closedDate: Date?
    @NSManaged public var ticker: String?
    @NSManaged public var type: Int16

}

extension PositionEntity : Identifiable {

}
