//
//  ContentView.swift
//  LearnMainActor
//
//  Created by 홍진표 on 6/11/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var todoListViewModel: TodoListViewModel = TodoListViewModel()
    
    var body: some View {
        NavigationStack {
            List(todoListViewModel.todos, id: \.id) { todo in
                Text(verbatim: todo.title)
            }
            .navigationTitle(Text(verbatim: "ToDo List"))
        }
        .task {
            await todoListViewModel.populateTodos()
        }
    }
}

#Preview {
    ContentView()
}
