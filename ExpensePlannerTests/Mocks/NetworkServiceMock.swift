//
//  NetworkServiceMock.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import Foundation

protocol INetworkService {
//    func fetchTasks(completion: @escaping (Result<, Error>) -> Void)
    func fetchTasks() async throws -> [TodoTask] // задача асинхронна по отношению к вызывающему потоку
}

final class NetworkServiceMock: INetworkService { // мок-сервис, имитирующий получение массива задач с бэка

//    func fetchTasks(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
    func fetchTasks() async throws -> [TodoTask] {

        try await Task.sleep(for: .seconds(2)) // задержка на 2 секунды

        let calendar = Calendar.current
        let today = Date()

        return [
            TodoTask(
                title: "Купить продукты",
                date: today,
                cost: 50,
                isCompleted: false
            ),
            TodoTask(
                title: "Оплатить интернет",
                date: today,
                cost: 30,
                isCompleted: true
            ),
            TodoTask(
                title: "Снять машину с учета",
                date: calendar.date(byAdding: .day, value: 1, to: today)!,
                cost: 30,
                isCompleted: false
            ),
            TodoTask(
                title: "Купить корм коту",
                date: calendar.date(byAdding: .day, value: 2, to: today)!,
                cost: 100,
                isCompleted: false
            ),
            TodoTask(
                title: "Оплатить телефон",
                date: calendar.date(byAdding: .day, value: 2, to: today)!,
                cost: 20,
                isCompleted: false
            ),
            TodoTask(
                title: "Сделать домашку",
                date: calendar.date(byAdding: .day, value: 3, to: today)!,
                cost: 0,
                isCompleted: false
            ),
            TodoTask(
                title: "Купить рубашку",
                date: calendar.date(byAdding: .day, value: 3, to: today)!,
                cost: 80,
                isCompleted: false
            )
        ]
    }
}
