//
//  FacebookSignInService.swift
//  ExpensePlanner
//
//  Created by Dmitry on 8.06.26.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import AppTrackingTransparency

protocol FacebookSignInServiceProtocol {
    func signIn() async throws -> AuthCredential
}

enum FacebookSignInError: LocalizedError {
    case cancelledByUser
    case noViewController
    case noAccessToken
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .cancelledByUser:
            return "Вход отменен пользователем"
        case .noViewController:
            return "Не удалось найти корневой ViewController"
        case .noAccessToken:
            return "Не удалось получить токен доступа Facebook"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

final class FacebookSignInService: FacebookSignInServiceProtocol {
    private let loginManager = LoginManager()
    
    func signIn() async throws -> AuthCredential {
        // 1. Получаем root ViewController
        guard let rootViewController = UIApplication.shared.topViewController() else {
            throw FacebookSignInError.noViewController
        }
        
        // 2. Запрашиваем разрешение на отслеживание (для получения обычного токена)
        if #available(iOS 14, *) {
            let status = await ATTrackingManager.requestTrackingAuthorization()
            print("ATT status: \(status.rawValue)")
        }
        
        // 3. Выполняем вход через Facebook с помощью простого метода
        return try await withCheckedThrowingContinuation { continuation in
            loginManager.logIn(permissions: ["public_profile", "email"], from: rootViewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: FacebookSignInError.unknown(error))
                    return
                }
                guard let result = result, !result.isCancelled else {
                    continuation.resume(throwing: FacebookSignInError.cancelledByUser)
                    return
                }
                
                // Получаем токен доступа
                guard let token = AccessToken.current?.tokenString else {
                    continuation.resume(throwing: FacebookSignInError.noAccessToken)
                    return
                }
                
                // Создаём Firebase credential
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                continuation.resume(returning: credential)
            }
        }
    }
}

// Расширение для получения top ViewController
extension UIApplication {
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? windows.first(where: { $0.isKeyWindow })?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            return topViewController(controller: tabController.selectedViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
