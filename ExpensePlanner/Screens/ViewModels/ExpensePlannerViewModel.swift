//
//  ExpensePlannerViewModel.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import Observation
import Foundation
import SwiftData

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
    private var context: ModelContext

    // Properties
    var selectedDate = Date()
    var today = Date()
    var tasks = [TodoTask]()
    var loadingState: LoadingState = .idle
    
    init(service: INetworkService = NetworkServiceMock(), context: ModelContext) {
        self.service = service
        self.context = context
    }

    func loadTasks() async {
        loadingState = .loading
        
        do {
            try fetchTasks()
            if tasks.isEmpty {
                tasks = try await service.fetchTasks() // ожидаем, пока загрузятся данные из сервиса
                loadingState = .loaded // эта строка НЕ ВЫПОЛНИТСЯ, пока не загружены данные
                for task in tasks {
                    context.insert(task)
                }
                try context.save()
            } else {
                loadingState = .loaded
            }
        } catch {
            loadingState = .error
        }
    }

    func fetchTasks() throws {
        let descriptor = FetchDescriptor<TodoTask>(predicate: nil) // обертка предиката, можно добавить сортировку выдачи
        tasks = try context.fetch(descriptor) // поиск в БД по предикату
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

    func saveContext() {
        try? context.save()
    }
}
