//
//  NC1_SecretFormulaApp.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 25/04/24.
//

import SwiftUI
import SwiftData

@main
struct NC1_SecretFormulaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
