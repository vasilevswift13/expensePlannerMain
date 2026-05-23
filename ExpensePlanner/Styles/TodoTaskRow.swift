//
//  TodoTaskRow.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import SwiftUI

struct TaskRow: View {
    @Bindable var task: TodoTask
    @Bindable var viewModel: ExpensePlannerViewModel

    var body: some View {
        HStack(alignment: .top) {
            Button {
                task.isCompleted.toggle()
                viewModel.saveContext()
            } label: {
                (task.isCompleted ?
                 Image(systemName: "checkmark.square.fill") :
                    Image(systemName: "square"))
                .foregroundStyle(task.isCompleted ? .green : .gray)
            }
            .padding(.trailing)
            .buttonStyle(.borderless)
            Spacer()
            VStack {
                if task.isCompleted {
                    TextField("Введите задачу", text: $task.title)
                        .textFieldStyle(.plain)
                        .disabled(true)
                    TextField("Введите стоимость", text: Binding(
                        get: { task.cost.moneyText },
                        set: { task.cost = $0.intValue }
                    ))
                    .textFieldStyle(.plain)
                    .disabled(true)
                } else {
                    TextField("Введите задачу", text: $task.title)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            viewModel.saveContext()
                        }
                    TextField("Введите стоимость", text: Binding(
                        get: { task.cost.moneyText },
                        set: { task.cost = $0.intValue }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        viewModel.saveContext()
                    }

                }
            }
        }
        .padding(.vertical, 4)
        .cardStyle()
    }
}
