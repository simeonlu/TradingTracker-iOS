//
//  TradingType.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 14/1/2024.
//

import Foundation
enum TradingType: Int16 {
    case long, short
}

enum PositionCategory: String {
    case stock, stockOption, currency, future, cryptoCurrency, unknown
}
