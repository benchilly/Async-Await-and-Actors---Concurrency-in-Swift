//: [Previous](@previous)

import Foundation

class BitcoinPriceMonitor {
    var price: Double = 0.0
    var timer: Timer?
    var priceHandler: (Double) -> Void = { _ in }
    
    @objc func getPrice() -> Void {
        priceHandler(Double.random(in: 20000...40000))
    }
    
    func startUpdating() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                      target: self,
                      selector: #selector(getPrice),
                      userInfo: nil,
                      repeats: true)
    }
    
    func stopUpdating() -> Void {
        timer?.invalidate()
    }
}

/*
let bitcoinPriceMonitor: BitcoinPriceMonitor = BitcoinPriceMonitor()
bitcoinPriceMonitor.priceHandler = { print($0) }
bitcoinPriceMonitor.startUpdating()
 */

let bitcoinPriceStream: AsyncStream<Double> = AsyncStream(Double.self) { continuation in
    let bitcoinPriceMonitor: BitcoinPriceMonitor = BitcoinPriceMonitor()
    bitcoinPriceMonitor.priceHandler = { continuation.yield($0) }
    
    continuation.onTermination = { _ in
        bitcoinPriceMonitor.stopUpdating()
    }
    
    bitcoinPriceMonitor.startUpdating()
}

Task {
    for await bitcoinPrice in bitcoinPriceStream {
        print(bitcoinPrice)
    }
}

//: [Next](@next)
