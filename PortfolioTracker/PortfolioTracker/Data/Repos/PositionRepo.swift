//
//  PositionRepo.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 26/3/2023.
//

import Foundation
protocol TradingRepo {
    func listOfTrades(for ticker: String) -> [Trade]
}
