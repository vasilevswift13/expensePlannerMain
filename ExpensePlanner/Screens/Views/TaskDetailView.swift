//
//  TaskDetailView.swift
//  ExpensePlanner
//
//  Created by Dmitry on 23.07.26.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Bindable var task: TodoTask
    @Bindable var viewModel: ExpensePlannerViewModel
    @Environment(\.dismiss) private var dismiss
    
    // временные копии для редактирования
    @State private var title: String
    @State private var cost: String
    @State private var date: Date
    @State private var category: String
    @State private var description: String
    @State private var isCompleted: Bool
    
    init(task: TodoTask, viewModel: ExpensePlannerViewModel) {
        self.task = task
        self.viewModel = viewModel
       _title = State(initialValue: task.title)
       _cost = State(initialValue: String(task.cost))
        _date = State(initialValue: task.date)
        _category = State(initialValue: task.category)
        _description = State(initialValue: task.taskDescription)
        _isCompleted = State(initialValue: task.isCompleted)
        
    }
    
    let categories = ["Еда","Работа", "Дом", "Развлечения", "Транспорт", "Спорт", "Здоровье", "Прочее"]
    
    var body: some View {
            Form {
                Section("Основное") {
                    TextField("Название", text: $title)
                    TextField("Стоимость", text: $cost)
                        .keyboardType(.numberPad)
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                    Toggle("Выполнено", isOn: $isCompleted)
                }
                
                Section("Детали") {
                    Picker("Категория", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat == "other" ? "Без категории" : cat).tag(cat)
                        }
                    }
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                }
                
                Section {
                    Button("Удалить задачу", role: .destructive) {
                        Task {
                            do {
                                try await viewModel.deleteTask(task)
                                dismiss()
                            } catch {
                                print("Ошибка удаления: \(error)")
                            }
                        }
                    }
                }
            }
            
            .navigationTitle("Детали задачи")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveChanges()
                    
                    }
                }
            }
        
    }
    
    private func saveChanges() {
        guard let costValue = Double(cost) else { return }
        task.title = title
        task.cost = Int(costValue)
        task.date = date
        task.category = category
        task.taskDescription = description
        task.isCompleted = isCompleted
        task.updatedAt = Date()
        task.isSynced = false
        
        Task {
            do {
                try await viewModel.updateTask(task)
                dismiss()
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
        
        
    }
    
    
}
