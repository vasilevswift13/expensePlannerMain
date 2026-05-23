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

        let offset = dto.id % 7
        let price = dto.userId * 10
        let date = calendar.date(byAdding: .day, value: offset, to: today) ?? today

        return TodoTask(
            title: dto.title,
            date: date,
            cost: price,
            isCompleted: dto.completed
        )
    }
}
