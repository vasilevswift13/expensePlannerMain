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
    var userId: String // uid из Firebase Auth, чтоб каждый пользователь видел только свои задачи, при сохр. в БД доб. uid, при загрузке фильтруем
    var title: String
    var date: Date
    var cost: Int
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date // дата последнего изменения 
    var isSynced: Bool // флаг синхронизации - true — отправлено на сервер

    init(userId: String, title: String, date: Date, cost: Int, isCompleted: Bool, createdAt: Date, updatedAt: Date, isSynced: Bool = false) {
        self.title = title
        self.date = date
        self.cost = cost
        self.isCompleted = isCompleted
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isSynced = isSynced
        
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
