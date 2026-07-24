//
//  TodoTaskDTO.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 30.04.2026.
//

// DTO = Data Transfer Object

import Foundation

struct TodoTaskDTO: Codable {
    let id: String
    let userId: String
    let title: String
    let completed: Bool
    let date: Date
    let cost: Int
    let createdAt: Date
    let updatedAt: Date
    let category: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, userId, title, completed, date, cost, createdAt, updatedAt, category, description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Гибкий декодер для id: пробуем Int, затем String
        let idValue: String
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            idValue = String(idInt)
        } else {
            idValue = try container.decode(String.self, forKey: .id)
        }
        id = idValue

        // Гибкий декодер для userId
        let userIdValue: String
        if let userIdInt = try? container.decode(Int.self, forKey: .userId) {
            userIdValue = String(userIdInt)
        } else {
            userIdValue = try container.decode(String.self, forKey: .userId)
        }
        userId = userIdValue

        title = try container.decode(String.self, forKey: .title)
        completed = try container.decode(Bool.self, forKey: .completed)

        // Для полей, которых нет в API, используем значения по умолчанию
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        cost = try container.decodeIfPresent(Int.self, forKey: .cost) ?? 0
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
        
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? "other"
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
        try container.encode(completed, forKey: .completed)
        try container.encode(date, forKey: .date)
        try container.encode(cost, forKey: .cost)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(category, forKey: .category)
        try container.encode(description, forKey: .description)
    }
}
