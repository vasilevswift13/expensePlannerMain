//
//  ModelContext+Extensions.swift
//  ExpensePlanner
//
//  Created by Dmitry on 17.06.26.
//

import Foundation
import SwiftData

extension ModelContext {
    // сохраняем изменения, если они есть
    
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
    
    // загружаем задачи конкретного пользователя отсортированные по дате
    
    func fetchTasks(for userId: String) throws -> [TodoTask] {
        let predicate = #Predicate<TodoTask> { $0.userId == userId }
        let descriptor = FetchDescriptor<TodoTask>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date)]
        )
        return try fetch(descriptor)
    }
    
    
    // загружаем все не синхронизированные задачи для клнкретного пользователя
    
    func fetchUnsyncedTasks(for userId: String) throws -> [TodoTask] {
        let predicate = #Predicate<TodoTask> {
            $0.userId == userId && $0.isSynced == false
        }
        let descriptor = FetchDescriptor<TodoTask>(predicate: predicate)
        return try fetch(descriptor)
    }
    
    // ищет задачу по ID для обновления из Firestore
    
    func fetchTask(by id: UUID) throws -> TodoTask? {
        let predicate = #Predicate<TodoTask> { $0.id == id }
        let descriptor = FetchDescriptor<TodoTask>(predicate: predicate)
        return try fetch(descriptor).first
    }
}
