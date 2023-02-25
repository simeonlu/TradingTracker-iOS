//
//  PortfolioTrackerApp.swift
//  PortfolioTracker
//
//  Created by Shimin lyu on 25/2/2023.
//

import SwiftUI

@main
struct PortfolioTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
