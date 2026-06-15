//
//  ExpensePlannerApp.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 31.03.26.
//

import Firebase
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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            RegistrationView()
//            ExpenseContentView()
            AppRootView()
        }
        .modelContainer(for: [TodoTask.self]) // контейнер базы данных, тут все хранится
    }
}
