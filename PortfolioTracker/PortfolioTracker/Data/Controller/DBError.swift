//
//  DBError.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 20/1/2024.
//

import Foundation

enum DBError: Error {
    case storeNotReady
    case storeError(NSError)
}
