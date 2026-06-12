//
//  Todo.swift
//  LearnMainActor
//
//  Created by 홍진표 on 6/11/26.
//

import Foundation

struct Todo: Decodable {
    let id: Int
    let title: String
    let completed: Bool
}
