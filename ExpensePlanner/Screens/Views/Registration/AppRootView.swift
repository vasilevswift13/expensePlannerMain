//
//  AppRootView.swift
//  ExpensePlanner
//
//  Created by Dmitry on 3.06.26.
//

import SwiftUI
import FirebaseAuth

struct AppRootView: View {
    @Environment(\.modelContext) private var modelContext
    // Начальное состояние — проверяем, есть ли уже пользователь
    @StateObject private var viewModelRegistration = RegistrationViewModel()

    var body: some View {
        Group {
            if viewModelRegistration.isAuthenticated {
                // главный экран после входа
                ExpensePlannerView(viewModel: ExpensePlannerViewModel(service: NetworkService(), context: modelContext))
            } else {
                // Экран регистрации/входа
                RegistrationView()
                    .environmentObject(viewModelRegistration)
            }
        }
        .task {
            await viewModelRegistration.loadSavedCredentials()
        }
        }
    }


