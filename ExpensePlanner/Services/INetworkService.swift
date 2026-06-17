//
//  INetworkService.swift
//  ExpensePlanner
//
//  Created by Dmitry on 17.06.26.
//

import Foundation

protocol INetworkService {
    func fetchTasks() async throws -> [TodoTask]
}
