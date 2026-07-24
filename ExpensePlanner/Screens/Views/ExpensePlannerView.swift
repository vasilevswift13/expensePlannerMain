//
//  ExpensePlannerView.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import SwiftData
import SwiftUI

struct ExpensePlannerView: View {
    
    @State private var viewModel: ExpensePlannerViewModel
    @State private var showAlert = false
    @State private var weekDragOffset: CGFloat = 0
    @State private var showCalendar = false
    @State private var showAddTaskSheet = false
    
    init(viewModel: ExpensePlannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Group {
                content
                    .sheet(isPresented: $showAddTaskSheet) {
                        AddTaskView(viewModel: viewModel)
                    }
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showAddTaskSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.orange)
                        .background(Circle().fill(Color.white).shadow(radius: 4))
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .refreshable {
                try? await Task.sleep(for: .seconds(1))
                await viewModel.loadTasks()
            }
            .task {
                await viewModel.loadTasks()
            }
        }
        //        .onAppear() {
        //            Task {
        //                try? await viewModel.loadTasks()
        //            }
        //        }
    }
    
    private var content: some View {
        ZStack {
            Image("skills")
                .resizable()
            VStack(alignment: .leading, spacing: 8) {
                calendarSection
                weekSection
                contentBlock
                
                //                Button("Show alert") {
                //                    showAlert.toggle()
                //                }
                //                .alert("Error", isPresented: $showAlert) {
                //                    Button("OK", role: .cancel, action: {})
                //                } message: {
                //                    Text("Some error occured")
                //                }
                //                .actionSheet(isPresented: $showAlert) {
                //                    actionSheet
                //                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(.ultraThinMaterial)
        }
    }
    
    @ViewBuilder
    private var contentBlock: some View {
        if viewModel.loadingState == .loading {
            LoadingView()
        } else if viewModel.loadingState == .error {
            ErrorView()
        } else {
            
            if viewModel.selectedDayTasks.isEmpty {
                EmptyStateView(systemImage: "exclamationmark.bubble", title: "No tasks", message: "Please add new task")
            } else {
                tasksSection
            }
        }
    }
    
    private var calendarSection: some View {
        HStack {
            Button {
                showCalendar = true
            } label: {
                Text(viewModel.selectedDate.monthAndYear)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(.capsule)
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showCalendar) {
            VStack {
                DatePicker(
                    "",
                    selection: $viewModel.selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()
                
                Button("Done") {
                    showCalendar = false
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
            }
            .presentationDetents([.medium])
        }
    }
    
    private var weekSection: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            HStack(spacing: 0) {
                weekPageView(offset: -1)
                    .frame(width: width)
                
                weekPageView(offset: 0)
                    .frame(width: width)
                
                weekPageView(offset: 1)
                    .frame(width: width)
            }
            .offset(x: -width + weekDragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        weekDragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = width * 0.25
                        
                        if value.translation.width < -threshold {
                            withAnimation(.easeOut(duration: 0.2)) {
                                weekDragOffset = -width
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.moveWeek(by: 1)
                                weekDragOffset = 0
                            }
                        } else if value.translation.width > threshold {
                            withAnimation(.easeOut(duration: 0.2)) {
                                weekDragOffset = width
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.moveWeek(by: -1)
                                weekDragOffset = 0
                            }
                        } else {
                            withAnimation(.spring()) {
                                weekDragOffset = 0
                            }
                        }
                    }
            )
        }
        .frame(height: 90)
        .clipped()
    }
    
    private var tasksSection: some View {
        List {
            ForEach(viewModel.selectedDayTasks) { task in
                HStack(spacing: 0) {
                    // чекбокс отдельно, чтоб не захватить NavigationLink
                    Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                        .foregroundStyle(task.isCompleted ? .green : .gray)
                        .onTapGesture {
                            task.isCompleted.toggle()
                            viewModel.saveContext()
                        }
                        .padding(.trailing, 8)
                        .frame(width: 44, height: 44)
                    
                    NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                                        TaskRowContent(task: task)
                                    }
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
                }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(
                        EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
                    )
            }
            .onDelete { indexSet in
                if let index = indexSet.first {
                    let task = viewModel.selectedDayTasks[index]
                    Task {
                        do {
                            try await viewModel.deleteTask(task)
                        } catch {
                            print("Ошибка удаления: \(error)")
                        }
                    }
                }
                
            }
            
        }
        .listStyle(.plain)
        .contentMargins(.top, 8, for: .scrollContent)
        .scrollContentBackground(.hidden)
        .background(.clear)
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.05),
                    .init(color: .black, location: 1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    /// Для теста навигации задач
//    private var tasksSection: some View {
//        List {
//            ForEach(viewModel.selectedDayTasks) { task in
//                NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
//                    Text(task.title)
//                }
//            }
//        }
//        .listStyle(.plain)
//    }
    
    
    var actionSheet: ActionSheet {
        let buttons = [
            ActionSheet.Button.default(Text("1")) {
                print("1")
            },
            ActionSheet.Button.default(Text("2")) {
                print("2")
            },
            ActionSheet.Button.default(Text("3")) {
                print("3")
            }
        ]
        
        return ActionSheet(title: Text("Action sheet"), message: nil, buttons: buttons + [.cancel()])
    }
    
    private func weekPageView(offset: Int) -> some View {
        HStack {
            ForEach(viewModel.weekDates(offset: offset), id: \.self) { day in
                let isSelected = day.isSameDay(as: viewModel.selectedDate)
                let isToday = day.isSameDay(as: viewModel.today)
                let hasTasks = viewModel.hasTasks(on: day)
                
                VStack(spacing: 4) {
                    Text(day.shortWeekday)
                    
                    Text(day.dayNumber)
                    
                    // 🔵 точка задач
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                        .opacity(hasTasks ? 1 : 0)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if isSelected {
                            Color.blue
                        } else if isToday {
                            Color.red
                        } else {
                            Color.white.opacity(0.8)
                        }
                    }
                )
                .foregroundColor(
                    isSelected || isToday ? .white : .primary
                )
                .cornerRadius(10)
                .onTapGesture {
                    viewModel.selectDate(day)
                }
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    ExpensePlannerView(viewModel: <#T##ExpensePlannerViewModel#>)
//}

//#Preview("Dark") {
//    ExpensePlannerView(service: NetworkServiceMock())
//        .preferredColorScheme(.dark)
//}

//#Preview("Large") {
//    ExpensePlannerView(service: NetworkServiceMock())
//        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
//}
