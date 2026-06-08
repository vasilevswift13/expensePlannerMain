import SwiftUI
import FirebaseAuth

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var isSignIn = false
    @Published var showError = false
    
    private let manager = FirebaseManager()
    private let keychainManager = KeychainManager.shared
    
    
    // для автомматического входа при запуске
    func loadSavedCredentials() async {
        guard let email = keychainManager.getEmail(),
              let password = keychainManager.getPassword(email: email) else {
            return
        }
        
        self.email = email
        self.password = password
        self.isSignIn = true
        
    }
    
    
    var isFormValid: Bool {
        if isSignIn {
            return !email.isEmpty && !password.isEmpty
        } else {
            return !email.isEmpty && !password.isEmpty && (password == confirmPassword)
        }
    }
    
    
    func authenticate() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }
        
        if !isSignIn && password != confirmPassword {
            errorMessage = "Пароли не совпадают"
            return
        }
        
        
        isLoading = true
        defer { isLoading = false }
        
        let user = UserData(email: email, password: password)
        
        do {
            if isSignIn {
                try await manager.signIn(user: user)
            } else {
                try await manager.registNewUser(user: user)
            }
            keychainManager.save(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    
    func signOut() {
        try? Auth.auth().signOut()
        keychainManager.clear()
        isAuthenticated = false
        
        // чистим поля
        
        email = ""
        password = ""
        confirmPassword = ""
        isSignIn = true
    }
    
    
    func claerSavedCredentials() {
        keychainManager.clear()
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
        showError = false
        isSignIn = false
    }
    
    
    func signInWithGoogle() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await manager.signInWithGoogle()
            
            if let email = Auth.auth().currentUser?.email {
                keychainManager.save(email: email, password: "") // тут появляются данные после входа и мы их сохраняем в кейчейн, у нас только мыло
            }
            
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
}
