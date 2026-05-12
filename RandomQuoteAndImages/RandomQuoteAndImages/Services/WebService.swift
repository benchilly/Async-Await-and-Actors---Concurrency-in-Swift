//
//  WebServices.swift
//  RandomQuoteAndImages
//
//  Created by 홍진표 on 5/11/26.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidImageId(Int)
    case decodingError
}

final class WebService {
    static let shared: WebService = WebService()
    
    private init() { }
    
    func getRandomImage(id: Int) async throws -> RandomImage {
        guard let randomImageUrl: URL = Constants.Urls.getRandomImageUrl(),
              let randomQuotesUrl: URL = Constants.Urls.randomQuotesUrl else {
            throw NetworkError.badUrl
        }
        
        async let (imageData, _): (Data, URLResponse) = URLSession.shared.data(from: randomImageUrl)
        async let (quotesData, _): (Data, URLResponse) = URLSession.shared.data(from: randomQuotesUrl)
        
        guard let quote: RandomQuote = try? await JSONDecoder().decode(RandomQuote.self, from: quotesData) else {
            throw NetworkError.decodingError
        }
        
        return RandomImage(image: try await imageData, randomQuote: quote)
    }
}
