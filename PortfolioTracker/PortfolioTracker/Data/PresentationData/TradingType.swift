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

enum PositionAssetType: String {
    case stock, stockOption, currency, future, cryptoCurrency, unknown
}
