//
//  Untitled.swift
//  ExpensePlanner
//
//  Created by Dmitry on 27.05.26.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    
    var body: some View {
        VStack {
            Picker("", selection: $registrationViewModel.isSignIn) {
                Text("Sign In").tag(true)
                Text("Register").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            
            
            TextField("Email", text: $registrationViewModel.email)
                .padding(10)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $registrationViewModel.password)
                .padding(10)
                .textFieldStyle(.roundedBorder)
            
            if !registrationViewModel.isSignIn {
                SecureField("Confirm Password", text: $registrationViewModel.confirmPassword)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
            }
            
            if registrationViewModel.isLoading {
                ProgressView()
            }
            
            Button(registrationViewModel.isSignIn ? "Sign In" : "Register") {
                Task {
                    await registrationViewModel.authenticate()
                }
            }
            .disabled(!registrationViewModel.isFormValid || registrationViewModel.isLoading)
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button(action: {
                Task { await registrationViewModel.signInWithGoogle()}
            }) {
                Label("Войти через Google", systemImage: "g.circle.fill")
            }
            .labelStyle(.titleAndIcon)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button("Войти через Facebook") {
                Task {
                    await registrationViewModel.signInWithFacebook()
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button("Войти по Face ID / Touch ID") {
                Task {
                    await registrationViewModel.signInWithBiometrics()
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple)
            .cornerRadius(10)
            .padding(.horizontal)
            
            
            
            Button("Очистить данные") {
                registrationViewModel.claerSavedCredentials()
            }
            .foregroundColor(.red)
            .padding(.top, 8)
        }
        
        .padding(.vertical)
        .alert("Ошибка", isPresented: $registrationViewModel.showError) {
            Button("OK") {
                registrationViewModel.errorMessage = nil
            }
        } message: {
            Text(registrationViewModel.errorMessage ?? "")
        }
        .navigationTitle(registrationViewModel.isSignIn ? "Добро пожаловать" : "Создать аккаунт")
        }
    }

struct RepeatedRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

