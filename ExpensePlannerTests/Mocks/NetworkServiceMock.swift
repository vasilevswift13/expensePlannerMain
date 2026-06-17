//
//  NetworkServiceMock.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import Foundation

final class NetworkServiceMock: INetworkService {
    protocol INetworkService {
    //    func fetchTasks(completion: @escaping (Result<, Error>) -> Void)
        func fetchTasks() async throws -> [TodoTask] // задача асинхронна по отношению к вызывающему потоку
    }
    
    func fetchTasks() async throws -> [TodoTask] {
        try await Task.sleep(for: .seconds(2))

        let calendar = Calendar.current
        let today = Date()
        let userId = "mock-user-id" // фиктивный ID пользователя
        let now = Date()           // для createdAt / updatedAt

        return [
            TodoTask(
                userId: userId,
                title: "Купить продукты",
                date: today,
                cost: 50,
                isCompleted: false,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            ),
            TodoTask(
                userId: userId,
                title: "Оплатить интернет",
                date: today,
                cost: 30,
                isCompleted: true,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            ),
            TodoTask(
                userId: userId,
                title: "Снять машину с учета",
                date: calendar.date(byAdding: .day, value: 1, to: today)!,
                cost: 30,
                isCompleted: false,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            ),
            TodoTask(
                userId: userId,
                title: "Купить корм коту",
                date: calendar.date(byAdding: .day, value: 2, to: today)!,
                cost: 100,
                isCompleted: false,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            ),
            TodoTask(
                userId: userId,
                title: "Оплатить телефон",
                date: calendar.date(byAdding: .day, value: 2, to: today)!,
                cost: 20,
                isCompleted: false,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            ),
            TodoTask(
                userId: userId,
                title: "Сделать домашку",
                date: calendar.date(byAdding: .day, value: 3, to: today)!,
                cost: 0,
                isCompleted: false,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            ),
            TodoTask(
                userId: userId,
                title: "Купить рубашку",
                date: calendar.date(byAdding: .day, value: 3, to: today)!,
                cost: 80,
                isCompleted: false,
                createdAt: now,
                updatedAt: now,
                isSynced: true
            )
        ]
    }
}
