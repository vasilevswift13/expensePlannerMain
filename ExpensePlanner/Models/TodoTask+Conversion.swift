//
//  TodoTask+Conversion.swift
//  ExpensePlanner
//
//  Created by Dmitry on 17.06.26.
//

import Foundation

// MARK: = TodoTask -> TodoTaskDTO
extension TodoTaskDTO {
    init(from task: TodoTask) {
        self.id = task.id.uuidString      // UUID → String
        self.userId = task.userId
        self.title = task.title
        self.completed = task.isCompleted
        self.date = task.date
        self.cost = task.cost
        self.createdAt = task.createdAt
        self.updatedAt = task.updatedAt
        self.category = task.category
        self.description = task.taskDescription
    }
}

extension TodoTask {
    convenience init(from dto: TodoTaskDTO) {
        guard let uuid = UUID(uuidString: dto.id) else {
            fatalError("Invalid UUID string") // или обработка ошибки
        }
        self.init(
            userId: dto.userId,
            title: dto.title,
            date: dto.date,
            cost: dto.cost,
            isCompleted: dto.completed,
            createdAt: dto.createdAt,
            updatedAt: dto.updatedAt,
            isSynced: true,
            category: dto.category,
            taskDescription: dto.description
        )
    }
}
