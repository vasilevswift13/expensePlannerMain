//
//  TaskRepositoryProtocol.swift
//  ExpensePlanner
//
//  Created by Dmitry on 17.06.26.
//

import Foundation

protocol TaskRepositoryProtocol {
    func fetchLocalTasks() throws -> [TodoTask]
    func createTask(_ task: TodoTask) async throws
    func updateTask(_ task: TodoTask) async throws
    func deleteTask(_ task: TodoTask) async throws
    func syncUnsyncedTasks() async throws
    func pullFromFirestore() async throws
}
