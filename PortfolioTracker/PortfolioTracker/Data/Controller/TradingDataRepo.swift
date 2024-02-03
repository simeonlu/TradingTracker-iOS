//
//  CoreDataRepo.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 6/1/2024.
//

import Foundation
import LVFoundation
import CoreData

class TradingDataRepo: TradingRepo {
    
    private var status: StoreStatus
    private var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    let persistenceController: TradingPersistenceController
    
    init(inMemory: Bool = false) {
        self.status = .unInit
        persistenceController = TradingPersistenceController(inMemory: inMemory)
        persistenceController.initPersistentStore { error in
            if let error = error {
                self.status = .fatal(error)
            } else {
                self.status = .normal
            }
        }
    }
    
    // MARK: - Trade functions
    func trades(of ticker: String, from: Date, till to: Date, ascending: Bool = false) throws -> [Trade] {
        try healthCheck()
        
        let predicate = NSPredicate(format: "ticker == %@ AND date > %@ AND date < %@ ", ticker, from as NSDate, to as NSDate)
        let request = createTradeRequest(predicate: predicate, ascending: ascending)
        return fetchTradeResult(request: request)
    }
    
    func tradeList(from: Date, till to: Date, ascending: Bool = false) throws -> [Trade] {
        try healthCheck()
        
        let predicate = NSPredicate(format: "date > %@ AND date < %@ ", from as NSDate, to as NSDate)
        let request = createTradeRequest(predicate: predicate, ascending: ascending)
        return fetchTradeResult(request: request)
    }
    
    func storeTrades(_ trades: [Trade]) throws -> Bool {
        try healthCheck()
        
        do {
            try trades.forEach { trade in
                let tradeEntity = trade.mapToEntity(with: context)
                if let posEntity = try getOpeningPositionEntity(of: trade) {
                    posEntity.addToTrades(tradeEntity)
                } else {
                    let entity = PositionEntity(context: context)
                    entity.startedDate = trade.tradedDate
                    entity.type = trade.type.rawValue
                    entity.ticker = trade.ticker
                    entity.trades = NSSet(object: tradeEntity)
                    entity.assetType = PositionAssetType.stock.rawValue
                }
            }
            
            try context.save()
            
        } catch {
#if DEBUG
            print("unexpected error when save object in core data: \(error)")
#endif
            return false
        }
        return true
    }
    
    func removeTrades(_ trades: [Trade]) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TradeEntity")
        fetchRequest.predicate = NSPredicate(
            format: "self in %@",
            trades.compactMap { $0.id }
        )
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.executeAndMergeChanges(using: batchDeleteRequest)
    }
    
    func removeTrade(_ trade: Trade) throws {
        let entity = try context.existingObject(with: trade.id)
        context.delete(entity)
    }
    
    // MARK: - Position functions
    func positions(of ticker: String,
                   dateRange: Range<Date>,
                   ascending: Bool) throws -> [Position] {
        try healthCheck()
        let from = dateRange.lowerBound
        let to = dateRange.upperBound
        let predicate = NSPredicate(format: "ticker == %@ AND startedDate > %@ AND startedDate < %@ ", ticker, from as NSDate, to as NSDate)
        let request = createPositionRequest(predicate: predicate, ascending: ascending)
        return fetchPositionResult(request: request)
    }
    
    func positionList(between dateRange: Range<Date>, ascending: Bool) throws -> [Position] {
        try healthCheck()
        
        let predicate = NSPredicate(format: "startedDate > %@ AND startedDate < %@ ",
                                    dateRange.lowerBound as NSDate, dateRange.upperBound as NSDate)
        let request = createPositionRequest(predicate: predicate, ascending: ascending)
        return fetchPositionResult(request: request)
    }
    
    func storePositions(_ positions: [Position]) throws -> Bool {
        try healthCheck()
        
        do {
            try positions.forEach { item in
                _ = item.mapToEntity(with: context)
                try context.save()
                
            }
        } catch {
#if DEBUG
            print("unexpected error when save object in core data: \(error)")
#endif
            return false
        }
        return true
    }
    
    func removePositions(_ positions: [Position]) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PositionEntity")
        fetchRequest.predicate = NSPredicate(
            format: "self in %@",
            positions.compactMap { $0.id }
        )
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.executeAndMergeChanges(using: batchDeleteRequest)
    }
    
}
// MARK: - Helper functions
extension TradingDataRepo {
    private func getOpeningPositionEntity(of trade: Trade) throws -> PositionEntity? {
        let predicate = NSPredicate(format: "ticker == %@ AND closedDate != nil", trade.ticker)
        let request = createPositionRequest(predicate: predicate, ascending: false)
        let positions = fetchPositionEntity(request: request)
        guard positions.count < 2 else {
            throw DataError.multipleOpeningPositionForOneAsset
        }
        return positions.first
}

private func createPositionRequest(predicate: NSPredicate, ascending: Bool) -> NSFetchRequest<PositionEntity> {
    let request = PositionEntity.fetchRequest()
    request.sortDescriptors = [
        NSSortDescriptor(
            keyPath: \PositionEntity.startedDate,
            ascending: ascending)
    ]
    request.fetchLimit = 100
    request.predicate = predicate
    return request
}

private func fetchPositionEntity(request: NSFetchRequest<PositionEntity>) -> [PositionEntity] {
    do {
        return try context.fetch(request)
    } catch {
        return [] // TO DO print error when debug
    }
}

private func fetchPositionResult(request: NSFetchRequest<PositionEntity>) -> [Position] {
    fetchPositionEntity(request: request).compactMap { $0.mapToPosition }
}

private func createTradeRequest(predicate: NSPredicate, ascending: Bool) -> NSFetchRequest<TradeEntity> {
    let request = TradeEntity.fetchRequest()
    request.sortDescriptors = [
        NSSortDescriptor(
            keyPath: \TradeEntity.date,
            ascending: ascending)
    ]
    request.fetchLimit = 100
    request.predicate = predicate
    return request
}

private func fetchTradeEntity(request: NSFetchRequest<TradeEntity>) -> [TradeEntity] {
    do {
        return try context.fetch(request)
    } catch {
        return [] // TO DO print error when debug
    }
}

private func fetchTradeResult(request: NSFetchRequest<TradeEntity>) -> [Trade] {
    fetchTradeEntity(request: request).compactMap { $0.mapToTrade }
}

private func healthCheck() throws {
    switch status {
    case .unInit:
        throw DBError.storeNotReady
    case .normal:
        return
    case .fatal(let error):
        throw DBError.storeError(error)
    }
}
}
