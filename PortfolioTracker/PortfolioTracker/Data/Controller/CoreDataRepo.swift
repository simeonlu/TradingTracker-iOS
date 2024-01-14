//
//  CoreDataRepo.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 6/1/2024.
//

import Foundation
import LVFoundation
import CoreData

class CoreDataRepo: TradingRepo {
    enum Status {
        case normal
        case fatal
    }
    private let status: Status
    private let persistenceController: PersistenceController

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
        false
    }

    func removeTrade(_ trade: Trade) -> Bool {
        false
    }

    func updateTrades(_ trades: [Trade]) -> Bool {
        false
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
            return try persistenceController
                .container
                .viewContext
                .fetch(request)
                .compactMap { $0.mapToTrade }
        } catch {
            return [] // TODO print error when debug
        }
    }
}
