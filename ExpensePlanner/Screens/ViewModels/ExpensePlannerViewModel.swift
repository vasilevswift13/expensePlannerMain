//
//  ExpensePlannerViewModel.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import Observation
import Foundation
import SwiftData
import Firebase
import FirebaseAuth

enum LoadingState {
    case idle
    case loading
    case loaded
    case error
}

@MainActor
@Observable
final class ExpensePlannerViewModel {
    
    // Dependencies
    private let service: INetworkService
    private let repository: TaskRepositoryProtocol
    
    // Properties
    var selectedDate = Date()
    var today = Date()
    var tasks = [TodoTask]()
    var loadingState: LoadingState = .idle
    
    init(service: INetworkService = NetworkServiceMock(), context: ModelContext) {
        self.service = service
        self.repository = TaskRepository(context: context) // передаем контекст в репозиторий
    }
    
    func loadTasks() async {
        loadingState = .loading
        
        do {
            print("1 Начинаем fetchTasks локально")
            try fetchTasks()
            print("2 Локальные задачи загружены, count: \(tasks.count)")
            
            if tasks.isEmpty {
                print("3 Локальных задач нет, загружаем из сети")
                let remoteTasks = try await service.fetchTasks()
                print("4 Загружено из сети: \(remoteTasks.count)")
                
                // Получаем текущий uid пользователя
                guard let userId = Auth.auth().currentUser?.uid else {
                    print("Ошибка - пользователь не авторизован")
                    loadingState = .error
                    return
                }
                print("Используем userId: \(userId)")
                
                for task in remoteTasks {
                    // Создаём новую задачу с правильным userId
                    let newTask = TodoTask(
                        userId: userId,
                        title: task.title,
                        date: task.date,
                        cost: task.cost,
                        isCompleted: task.isCompleted,
                        createdAt: task.createdAt,
                        updatedAt: task.updatedAt,
                        isSynced: false // пока не синхронизирована
                    )
                    try await repository.createTask(newTask)
                    print("5 Задача создана локально и отправлена в Firestore")
                }
                try fetchTasks()
                print("6 Локальные задачи обновлены")
            }
            print("7 Начинаем pullFromFirestore")
            try await repository.pullFromFirestore()
            print("8 Pull завершён")
            try fetchTasks()
            print("9 Локальные задачи после pull: \(tasks.count)")
            loadingState = .loaded
            print("10 Загрузка завершена успешно")
        } catch {
            print("Ошибка в loadTasks: \(error)")
            print("Детали: \(error.localizedDescription)")
            loadingState = .error
        }
    }
 
    func fetchTasks() throws {
        tasks = try repository.fetchLocalTasks()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    var currentWeekDates: [Date] {
        weekDates()
    }
    
    var selectedDayTasks: [TodoTask] {
        tasks
            .filter {
                $0.date.isSameDay(as: selectedDate)
            }
            .sorted(by: { $0.date < $1.date })
            .sorted(by: { !$0.isCompleted && $1.isCompleted })
    }
    
    func weekDates(offset: Int = 0) -> [Date] {
        let calendar = Calendar.current
        
        let baseDate = calendar.date(
            byAdding: .weekOfYear,
            value: offset,
            to: selectedDate
        ) ?? selectedDate
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: baseDate)?.start ?? baseDate
        
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
    
    func moveWeek(by value: Int) {
        let calendar = Calendar.current
        
        let currentWeekReference = selectedDate
        
        if let newDate = calendar.date(
            byAdding: .weekOfYear,
            value: value,
            to: currentWeekReference
        ) {
            selectedDate = newDate
        }
    }
    
    func hasTasks(on date: Date) -> Bool {
        tasks.contains { $0.date.isSameDay(as: date) }
    }
    
    // MARK: - Созранение и синхронизация
    
    func saveContext() {
        Task {
            do {
                try await repository.syncUnsyncedTasks()
            } catch {
                print("Ошибка синхронизации: \(error.localizedDescription)")
            }
        }
    }
    
    
    func addTask(title: String, cost: Int, date: Date) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
                   throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])
               }
        let task = TodoTask(
            userId: userId,
            title: title,
            date: date,
            cost: cost,
            isCompleted: false,
            createdAt: Date(),
            updatedAt: Date(),
            isSynced: false
        )
        try await repository.createTask(task)
        try fetchTasks()
    }
    
    
}
