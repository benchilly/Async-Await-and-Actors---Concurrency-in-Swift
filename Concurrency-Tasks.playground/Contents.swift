import UIKit

enum NetworkError: Error {
    case badUrl
    case decodingError
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
    
    //  서로 다른 API 호출로, 각 await에서 Suspend 되고 Serial하게 실행 (=> 총 소요 시간이 큼)
    //  await를 연속으로 사용해야 하는 경우
    //      - 작업들이 서로 의존관계 (인과관계)를 갖는 경우
    //      - 실행 순서가 보장되어야 하는 경우
    /*
    let (experianData, _): (Data, URLResponse) = try await URLSession.shared.data(from: experianUrl)
    let (equifaxData, _): (Data, URLResponse) = try await URLSession.shared.data(from: equifaxUrl)
     */
    
    //  async-let으로 2개의 API를 병렬 실행
    //  async-let을 만나는 순간, 2개의 실행 흐름이 생김 (-> Parent Task & Child Task)
    //      - Child Task: expression을 수행
    //      - Parent Task: Child Task가 수행하는 결과값을 담을 placeholder를 생성하여 즉시 Binding
    //                      + Child Task가 작업하는 동안 이후 statements 수행
    async let (experianData, _): (Data, URLResponse) = URLSession.shared.data(from: experianUrl)
    async let (equifaxData, _): (Data, URLResponse) = URLSession.shared.data(from: equifaxUrl)
    
    //  실제 값이 필요한 시점에 await로 호출
    //      - Child Task 완료 시: 기다림 없이 즉시 값을 가져옴
    //      - Child Task 아직 실행 시: Parent Task는 suspend되어 Child Task가 끝날 때까지 기다림
    let experianCreditScore: CreditScore? = try? JSONDecoder().decode(CreditScore.self, from: try await experianData)
    let equifaxCreditScore: CreditScore? = try? JSONDecoder().decode(CreditScore.self, from: try await equifaxData)
    
    guard let experianCreditScore: CreditScore = experianCreditScore,
          let equifaxCreditScore: CreditScore = equifaxCreditScore else {
        throw NetworkError.decodingError
    }
    
    return calculateAPR(creditScores: [experianCreditScore, equifaxCreditScore])
}

//  Async-let Tasks
//      Task: 비동기 작업의 단위 (-> 독립실행 + 순차실행)
Task {
    let apr: Double = try await getAPR(userId: 1)
    print("APR: \(apr)")
}

//  Async-let in a Loop
let ids: [Int] = Array(1...5)

Task {
    for id in ids {
        let apr: Double = try await getAPR(userId: id)
        print("id: \(id) / apr: \(apr)")
        
        //  문제점
        //      1. for-in Loop 안에서 각 id에 대해 순차실행 함 (Serial Execution)
        //      2. getAPR() 내부에서 try await 도중 에러 발생 시, Task가 중단됨 (Child Task가 모두 완료되어야 Parent Task도 완료됨)
    }
}
