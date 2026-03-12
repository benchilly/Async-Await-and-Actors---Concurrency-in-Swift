//
//  CurrentDate.swift
//  GettingStartedAsyncAwait
//
//  Created by 홍진표 on 1/28/26.
//

import Foundation

struct CurrentDate: Decodable, Identifiable {
    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}
