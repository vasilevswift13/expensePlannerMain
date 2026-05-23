//
//  NetworkService.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 30.04.2026.
//

import Foundation

final class NetworkService: INetworkService {

    func fetchTasks() async throws -> [TodoTask] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            return []
        }

//        var request = URLRequest(url: url)
//        request.setValue("Bearer vfjjn3unc3oind3n0s83nj08nc93ncd", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(from: url) // асинхронный запрос данных на бэк

        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        let dto = try JSONDecoder().decode([TodoTaskDTO].self, from: data)
        return dto.map { TodoTaskMapper.map(from: $0) }
    }
}
