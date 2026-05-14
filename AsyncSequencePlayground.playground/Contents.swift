import UIKit

struct Lines: Sequence {
    let url: URL
    
    func makeIterator() -> some IteratorProtocol {
        let lines: [String.SubSequence] = (try? String(contentsOf: url, encoding: .utf8))?.split(separator: "\n") ?? []
        
        return LinesIterator(lines: lines)
    }
}

struct LinesIterator: IteratorProtocol {
    typealias Element = String
    
    var lines: [String.SubSequence]
    
    mutating func next() -> Element? {
        return lines.isEmpty ? nil : String(lines.removeFirst())
    }
}

extension URL {
    func allLines() async -> Lines {
        return Lines(url: self)
    }
}

let endpointURL: URL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!

//  Loop over sequence without AsyncSequence
Task {
    for line in await endpointURL.allLines() {
        print(line)
    }
}

//  Loop over AsyncSequence using await
Task {
    for try await line in endpointURL.lines {
        print(line)
    }
}

