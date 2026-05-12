//
//  RandomImageListViewModel.swift
//  RandomQuoteAndImages
//
//  Created by 홍진표 on 5/11/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class RandomImageListViewModel: ObservableObject {
    @Published var randomImages: [RandomImageViewModel] = []
    
    func getRandomImages(ids: [Int]) async -> Void {
        do {
            try await withThrowingTaskGroup(of: (Int, RandomImage).self) { group in
                //  Fork
                for id in ids {
                    group.addTask {
                        return (id, try await WebService.shared.getRandomImage(id: id))
                    }
                }
                
                //  Join
                for try await (_, randomImage) in group {
                    randomImages.append(RandomImageViewModel(randomImage: randomImage))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct RandomImageViewModel: Identifiable {
    let id: UUID = UUID()
    fileprivate let randomImage: RandomImage
    
    var image: UIImage? {
        get { return UIImage(data: randomImage.image) }
    }
    
    var quote: String {
        get { return randomImage.randomQuote.quote }
    }
    
    var author: String {
        get { return randomImage.randomQuote.author }
    }
}
