//
//  GoogleSignInService.swift
//  ExpensePlanner
//
//  Created by Dmitry on 4.06.26.
//

import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseAuth
import UIKit
import FirebaseCore


// MARK: - Ошибки Google Sign-In
enum GIDSignInError: LocalizedError {
    case noViewController, invalidClientID

    var errorDescription: String? {
        switch self {
        case .noViewController:
            return "Не удалось найти корневой ViewController."
        case .invalidClientID:
            return "Не удалось получить Client ID из конфигурации Firebase."
        }
    }
}


// определяем протокол чтоб в будущем его можно было замокать

protocol GoogleSignInServiceProtocol {
    func signIn() async throws -> AuthCredential
}


final class GoogleSignInService: GoogleSignInServiceProtocol {
    func signIn() async throws -> AuthCredential {
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = await windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            throw NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось найти корневой ViewController"])
        }
        // получаем clientID из конфигурации Firebase
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "GoogleSignInError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить Client ID из Firebase. Проверьте GoogleService-Info.plist"])
        }
        // Конфигурация
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
    
        
        // запуск входа черз гугл
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw NSError(domain: "GoogleSignInError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить idToken"])
        }
        let accessToken = user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    
        return credential
    }
}
