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
        self.id = task.id.uuidString
        self.userId = task.userId
        self.title = task.title
        self.completed = task.isCompleted
        self.date = task.date
        self.cost = task.cost
        self.createdAt = task.createdAt
        self.updatedAt = task.updatedAt
    }
}


// MARK: - TodoTaskDTO -> TodoTask

extension TodoTask {
    convenience init(from dto: TodoTaskDTO) {
        self.init(
            userId: dto.userId,
            title: dto.title,
            date: dto.date,
            cost: dto.cost,
            isCompleted: dto.completed,
            createdAt: dto.createdAt,
            updatedAt: dto.updatedAt,
            isSynced: true
        )
    }
}
