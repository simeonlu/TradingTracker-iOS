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
    func listOfExposingPosition(for ticker: String, from: Date, till to: Date, ascending: Bool) throws -> [Position] {
       []
    }
    
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
    
    func listOfTrades(for ticker: String, from: Date, till to: Date, ascending: Bool = false) throws -> [Trade] {
        try healthCheck()
        
        let predicate = NSPredicate(format: "ticker == %@ AND date > %@ AND date < %@ ", ticker, from as NSDate, to as NSDate)
        let request = createRequest(predicate: predicate, ascending: ascending)
        return fetchTradeResult(request: request)
    }
    
    func listOfTrades(from: Date, till to: Date, ascending: Bool = false) throws -> [Trade] {
        try healthCheck()
        
        let predicate = NSPredicate(format: "date > %@ AND date < %@ ", from as NSDate, to as NSDate)
        let request = createRequest(predicate: predicate, ascending: ascending)
        return fetchTradeResult(request: request)
    }
    
    func storeTrades(_ trades: [Trade]) throws -> Bool {
        try healthCheck()
        
        do {
            try trades.forEach { trade in
                _ = trade.mapToEntity(with: context)
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
    
    private func createRequest(predicate: NSPredicate, ascending: Bool) -> NSFetchRequest<TradeEntity> {
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
    
    private func fetchTradeResult(request: NSFetchRequest<TradeEntity>) -> [Trade] {
        do {
            return try context
                .fetch(request)
                .compactMap { $0.mapToTrade }
        } catch {
            return [] // TO DO print error when debug
        }
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
