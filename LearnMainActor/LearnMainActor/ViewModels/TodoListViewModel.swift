//
//  TodoListViewModel.swift
//  LearnMainActor
//
//  Created by 홍진표 on 6/12/26.
//

import Foundation
import Combine

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoViewModel] = []
    
    func populateTodos() async -> Void {
        do {
            guard let url: URL = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
                throw NetworkError.badUrl
            }
            
            Task.detached { //  Background-Thread
                print("[DEBUG]: isMainThread? = \(Thread.isMainThread)")
                let todos: [Todo] = try await WebService.shared.getAllTodos(url: url)
                await MainActor.run {   //  Main-Thread
                    print("[DEBUG]: isMainThread? = \(Thread.isMainThread)")
                    self.todos = todos.map({ TodoViewModel(todo: $0) })
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TodoViewModel {
    let todo: Todo
    
    var id: Int {
        get { return todo.id }
    }
    
    var title: String {
        get { return todo.title }
    }
    
    var completed: Bool {
        get { return todo.completed }
    }
}
