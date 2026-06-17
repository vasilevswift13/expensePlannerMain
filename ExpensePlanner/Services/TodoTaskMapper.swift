//
//  TodoTaskMapper.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 30.04.2026.
//

import Foundation

enum TodoTaskMapper {
    static func map(from dto: TodoTaskDTO) -> TodoTask {
        let calendar = Calendar.current
        let today = Date()
        let now = Date()

        // id и userId уже строки, используем их как есть
        let userId = dto.userId
        let title = dto.title
        let isCompleted = dto.completed
        let date = dto.date // используем дату из DTO
        let cost = dto.cost
        let createdAt = dto.createdAt
        let updatedAt = dto.updatedAt

        return TodoTask(
            userId: userId,
            title: title,
            date: date,
            cost: cost,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: true // данные с сервера считаем синхронизированными
        )
    }
}
