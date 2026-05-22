//
//  TodoTask.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import Observation
import Foundation
import SwiftData

@Model
final class TodoTask: Identifiable {
    @Attribute(.unique) var id = UUID()
    var title: String
    var date: Date
    var cost: Int
    var isCompleted: Bool

    init(title: String, date: Date, cost: Int, isCompleted: Bool) {
        self.title = title
        self.date = date
        self.cost = cost
        self.isCompleted = isCompleted
    }
}

extension Int {
    var moneyText: String {
        formatted(.currency(code: "USD"))
    }
}

extension String {
    var intValue: Int {
        Int(Double(self.replacingOccurrences(of: " $", with: "").replacingOccurrences(of: ",", with: ".")) ?? 0)
    }
}
