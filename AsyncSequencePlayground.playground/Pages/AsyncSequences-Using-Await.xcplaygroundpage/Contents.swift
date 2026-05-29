import UIKit

struct Lines: Sequence {
    let url: URL
    
    init(url: URL) {
        self.url = url
        print("DEBUG: Sequence 생성")
    }
    
    func makeIterator() -> some IteratorProtocol {
        let lines: [String.SubSequence] = (try? String(contentsOf: url, encoding: .utf8))?.split(separator: "\n") ?? []
        
        return LinesIterator(lines: lines)
    }
}

struct LinesIterator: IteratorProtocol {
    typealias Element = String
    
    var lines: [String.SubSequence]
    
    init(lines: [String.SubSequence]) {
        self.lines = lines
        print("DEBUG: Iterator 생성")
    }
    
    mutating func next() -> Element? {
        return lines.isEmpty ? nil : String(lines.removeFirst())
    }
}

extension URL {
    func allLines() async -> Lines { return Lines(url: self) }
}

let endpointURL: URL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!

// TODO: Loop over sequence without AsyncSequence
/// 데이터 전체 다운로드 후, element 처리
/*
Task {
    for line in await endpointURL.allLines() {
        print("===> \(line)")
    }
    
    print("\nDEBUG: for-in Loop 끝")
}
 */

// TODO: Loop over AsyncSequence using await
/// 데이터가 들어오는 대로 한 줄씩 element 처리
Task {
    var count = 0
    for try await line in endpointURL.lines {
        count += 1
        print("===> \(count)L.: \(line)")
    }
    
    print("\nDEBUG: for-in Loop 끝")
}
