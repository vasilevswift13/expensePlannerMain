//
//  NEtworkError.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 30.04.2026.
//

import Foundation

enum NetworkError: LocalizedError {

    case invalidResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .decodingFailed:
            return "Ошибка декодирования данных"
        }
    }
}
