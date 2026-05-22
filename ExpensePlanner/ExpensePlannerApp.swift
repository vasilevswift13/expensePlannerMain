//
//  ExpensePlannerApp.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 31.03.26.
//

import FirebaseCore
import SwiftData
import SwiftUI

@main
struct ExpensePlannerApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
//            ExpenseContentView()
            FirebaseDemoView()
        }
        .modelContainer(for: [TodoTask.self]) // контейнер базы данных, тут все хранится
    }
}
