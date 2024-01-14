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
    enum Status {
        case uninit
        case normal
        case fatal(NSError)
    }

    private var status: Status
    private let persistenceController: PersistenceController
    private var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    init() {
        persistenceController = PersistenceController.shared
        self.status = .normal
    }

    func listOfTrades(for ticker: String, from: Date, till to: Date, ascending: Bool = false) -> [Trade] {
        let predicate = NSPredicate(format: "ticker == %@ AND date > %@ AND date < %@ ", ticker, from as NSDate, to as NSDate)
        let request = createRequest(predicate: predicate, ascending: ascending)
        return fetchTradeResult(request: request)
    }

    func listOfTrades(from: Date, till to: Date, ascending: Bool = false) -> [Trade] {
        let predicate = NSPredicate(format: "date > %@ AND date < %@ ", from as NSDate, to as NSDate)
        let request = createRequest(predicate: predicate, ascending: ascending)
        return fetchTradeResult(request: request)
    }

    func storeTrades(_ trades: [Trade]) -> Bool {
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

    func removeTrades(_ trades: [Trade]) {
        trades
            .compactMap { $0.id }
            .forEach { id in
                if let entity = try? context.existingObject(with: id) {
                    context.delete(entity)
                }
            }
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
}
