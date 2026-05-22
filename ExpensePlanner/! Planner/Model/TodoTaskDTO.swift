//
//  TodoTaskDTO.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 30.04.2026.
//

// DTO = Data Transfer Object

import Foundation

struct TodoTaskDTO: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}
