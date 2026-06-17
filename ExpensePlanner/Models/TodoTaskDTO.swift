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
}
