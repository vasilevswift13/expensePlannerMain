//
//  SyncService.swift
//  ExpensePlanner
//
//  Created by Dmitry on 17.06.26.
//

import Foundation
import FirebaseFirestore

protocol SyncServiceProtocol {
    func pushTask(_ task: TodoTaskDTO) async throws
    func deleteTask(withId id: String) async throws
    func pullTasks(for userId: String) async throws -> [TodoTaskDTO]
    func syncTasks(_ tasks: [TodoTaskDTO]) async throws
}

final class SyncService: SyncServiceProtocol {
    private let db = Firestore.firestore()
    private let collectionName = "tasks"
    
    // MARK: - Push - отправляем одну задачу
    
    func pushTask(_ task: TodoTaskDTO) async throws {
        let data = try Firestore.Encoder().encode(task)
        try await db.collection(collectionName)
            .document(task.id)
            .setData(data, merge: true)
    }
    
    // MARK: - удаляем задачу
    func deleteTask(withId id: String) async throws {
        try await db.collection(collectionName)
            .document(id)
            .delete()
    }
    
    // MARK: - Pull - загружаем все задачи юзера
    
    func pullTasks(for userId: String) async throws -> [TodoTaskDTO] {
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: TodoTaskDTO.self)
                                                                                                                                
        }
    }
    
    
    
    // MARK: - синхроним несколько задач
    
    func syncTasks(_ tasks: [TodoTaskDTO]) async throws {
        let batch = db.batch()
        
        for task in tasks {
            let ref = db.collection(collectionName).document(task.id)
            let data = try Firestore.Encoder().encode(task)
            batch.setData(data, forDocument: ref, merge: true)
        }
        
        try await batch.commit()
    }
    
    
}
