//
//  TaskRepository.swift
//  ExpensePlanner
//
//  Created by Dmitry on 17.06.26.
//

import Foundation
import SwiftData
import FirebaseAuth

@MainActor

final class TaskRepository: @preconcurrency TaskRepositoryProtocol {
    
    private let context: ModelContext
    private let syncService: SyncServiceProtocol
    private let userId: String
    
    init(context: ModelContext, syncService: SyncServiceProtocol = SyncService()) {
        self.context = context
        self.syncService = syncService
        self.userId = Auth.auth().currentUser?.uid ?? ""
    }
    
    
    // MARK: - локально
    
    func fetchLocalTasks() throws -> [TodoTask] {
        return try context.fetchTasks(for: userId)
    }
    
    
    func createTask(_ task: TodoTask) async throws {
        context.insert(task)
        try context.saveIfNeeded()
        
        let dto = TodoTaskDTO(from: task)
        try await syncService.pushTask(dto)
        task.isSynced = true
        
        try context.saveIfNeeded()
        
    }
    
    func updateTask(_ task: TodoTask) async throws {
        task.updatedAt = Date()
        task.isSynced = false
        try context.saveIfNeeded()
        
        let dto = TodoTaskDTO(from: task)
        try await syncService.pushTask(dto)
        
        task.isSynced = true
        try context.saveIfNeeded()
    }
    
    
    func deleteTask(_ task: TodoTask) async throws {
        try await syncService.deleteTask(withId: task.id.uuidString)
        context.delete(task)
        try context.saveIfNeeded()
    }
    
    
    // MARK: - Sync
    
    func syncUnsyncedTasks() async throws {
        let unsynced = try context.fetchUnsyncedTasks(for: userId)
        guard !unsynced.isEmpty else { return }
        
        
        let dtos = unsynced.map { TodoTaskDTO(from: $0) }
        try await syncService.syncTasks(dtos)
        
        for task in unsynced {
            task.isSynced = true
        }
        try context.saveIfNeeded()
    }
    
    
    
    func pullFromFirestore() async throws {
        let dtos = try await syncService.pullTasks(for: userId)
        
        for dto in dtos {
            if let local = try context.fetchTask(by: UUID(uuidString: dto.id) ?? UUID()) {
                if dto.updatedAt > local.updatedAt {
                    local.title = dto.title
                    local.date = dto.date
                    local.cost = dto.cost
                    local.isCompleted = dto.completed
                    local.updatedAt = dto.updatedAt
                    local.isSynced = true
                }
            } else {
                let task = TodoTask(from: dto)
                context.insert(task)
            }
        }
        try context.saveIfNeeded()
    }
    
}
