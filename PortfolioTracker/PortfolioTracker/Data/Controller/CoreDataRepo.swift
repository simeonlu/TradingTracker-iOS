//
//  CoreDataRepo.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 6/1/2024.
//

import Foundation
class CoreDataRepo: TradingRepo {
    private let status: Status
    private let persistenceController: PersistenceController
    
    init() {
        persistenceController = PersistenceController.shared
        self.status = .normal
    }
    
    func listOfTrades(for ticker: String, from: Date, till to: Date) -> [Trade] {
        [] // TODO
    }
    
    func listOfTrades(from: Date, till to: Date) -> [Trade] {
        [] // TODO
    }
    
    func storeTrades(_ trades: [Trade]) -> Bool {
       false // TODO
    }
    
    func removeTrade(_ trade: Trade) -> Bool {
        false // TODO
    }
    
    enum Status {
        case normal
        case fatal
    }
}
