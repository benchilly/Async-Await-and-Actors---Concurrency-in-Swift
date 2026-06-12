//
//  WebService.swift
//  LearnMainActor
//
//  Created by 홍진표 on 6/11/26.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case decodingError
    case badRequest
}

class WebService {
    static let shared: WebService = WebService()
    
    func getAllTodos(url: URL) async throws -> [Todo] {
        let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
        let todos: [Todo]? = try? JSONDecoder().decode([Todo].self, from: data)
        return todos ?? []
        
        /*
        return try await withCheckedThrowingContinuation { continuation in
            self.getAllTodos(url: url) { result in
                switch result {
                case.success(let todos):
                    continuation.resume(returning: todos)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
         */
    }
    
    func getAllTodos(url: URL, completion: @escaping (Result<[Todo], NetworkError>) -> Void) -> Void {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let safeData: Data = data, error == nil else {
                completion(.failure(.badRequest))
                return
            }
            
            guard let todos: [Todo] = try? JSONDecoder().decode([Todo].self, from: safeData) else {
                completion(.failure(.badRequest))
                return
            }
            
            completion(.success(todos))
        }.resume()
    }
}
