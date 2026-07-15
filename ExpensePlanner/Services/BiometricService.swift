//
//  BiometricService.swift.swift
//  ExpensePlanner
//
//  Created by Dmitry on 13.07.26.
//

import Foundation
import LocalAuthentication


protocol BiometricServiceProtocol {
    // проверка, поддерживается ли биометрия на устройстве и разрешена ли она
    
    func canUseBiometrics() -> Bool
    
    // запрашивает биометрическую аутентификацию. Возвращает true при успехе, иначе выкидыват error
    func authenticate() async throws -> Bool
    
}

final class BiometricService: BiometricServiceProtocol {
    
    private let context = LAContext()
    
    func canUseBiometrics() -> Bool {
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return canEvaluate && error == nil
    }
    
    func authenticate() async throws -> Bool {
        // проверяем доступна ли биометрия
        guard canUseBiometrics() else {
            
            throw BiometricError.biometricNotAvailable
        }
        
        return try await withCheckedThrowingContinuation{ continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Подтвердите вход с помощью Face ID или Touch ID") {
                success, error in
                if success {
                    continuation.resume(returning: true)
                } else if let error = error {
                    continuation.resume(throwing: BiometricError.authenticationFailed(error.localizedDescription))
                } else {
                    continuation.resume(throwing: BiometricError.unoknown)
                }
            }
        }
    }
}
    enum BiometricError: Error {
        case biometricNotAvailable
        case authenticationFailed(String)
        case unoknown
        
        var errorDescription: String? {
            switch self {
            case .biometricNotAvailable:
                return "Face ID или Touch ID недоступны на этом устройстве."
            case .authenticationFailed(let message):
                return message
            case .unoknown:
                return "Произошла неизвестная ошибка при попытке входа."
            }
        }
    }

