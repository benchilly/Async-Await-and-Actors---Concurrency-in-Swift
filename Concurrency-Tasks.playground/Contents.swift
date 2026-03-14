import UIKit

enum NetworkError: Error {
    case badUrl
    case decodingError
    case invalidId
}

struct CreditScore: Decodable {
    let score: Int
}

struct Constants {
    struct Urls {
        static func experian(userId: Int) -> URL? {
            return URL(string: "http://localhost:3000/experian/credit-score/\(userId)")
        }
        
        static func equifax(userId: Int) -> URL? {
            return URL(string: "http://localhost:3000/equifax/credit-score/\(userId)")
        }
    }
}

func calculateAPR(creditScores: [CreditScore]) -> Double {
    let sum: Int = creditScores.reduce(0) { next, credit in
        return next + credit.score
    }
    
    return Double((sum / creditScores.count) / 100)
}

func getAPR(userId: Int) async throws -> Double {
    guard let experianUrl: URL = Constants.Urls.experian(userId: userId),
          let equifaxUrl: URL = Constants.Urls.equifax(userId: userId) else {
        throw NetworkError.badUrl
    }
    
    //  For testing the cancellation of the task
    if (userId % 2 == 0) {
        throw NetworkError.invalidId
    }
    
    async let (experianData, _): (Data, URLResponse) = URLSession.shared.data(from: experianUrl)
    async let (equifaxData, _): (Data, URLResponse) = URLSession.shared.data(from: equifaxUrl)
    
    let experianCreditScore: CreditScore? = try? JSONDecoder().decode(CreditScore.self, from: try await experianData)
    let equifaxCreditScore: CreditScore? = try? JSONDecoder().decode(CreditScore.self, from: try await equifaxData)
    
    guard let experianCreditScore: CreditScore = experianCreditScore,
          let equifaxCreditScore: CreditScore = equifaxCreditScore else {
        throw NetworkError.decodingError
    }
    
    return calculateAPR(creditScores: [experianCreditScore, equifaxCreditScore])
}

let ids: [Int] = Array(1...5)
var invalidIds: [Int] = []

Task {
    for id in ids {
        do {
            //  Cancellation 2가지 방법
            //      - Task.isCancelled: 취소 상태 확인만 함 (-> 리소스 정리 후 종료하거나 값을 반환할 때 사용)
            //      - Task.checkCancellation(): 취소 여부 확인 후, 취소된 상태라면 즉시 CancellationError를 던짐 (-> 즉시 중단하고 에러처리를 맡길 때 사용)
            
            try Task.checkCancellation()
            let apr: Double = try await getAPR(userId: id)
            print("id: \(id) / apr: \(apr)")
        } catch {
            print("error: \(error)")
            invalidIds.append(id)
        }
    }
    
    print("\ninvalidIds: \(invalidIds)")
}
