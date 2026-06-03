//
//  ContentView.swift
//  Understanding Actors
//
//  Created by 홍진표 on 6/3/26.
//

import SwiftUI

// MARK: actor: 오직 단 하나의 스레드만 해당 데이터에 접근하도록 보장
actor Counter {
    var value: Int = 0
    
    func increment() -> Int {
        print("[DEBUG] Current-Thread: \(Thread.current)")
        
        value += 1
        return value
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                let counter: Counter = Counter()
                
                // FIXME: Counter가 class/struct라면 concurrentPerform() 안에서 공유 자원인 value에 접근 시, Data race/Race condition이 발생
                /*
                DispatchQueue.concurrentPerform(iterations: 100) { _ in //  concurrentPerform()은 기본적으로 순서를 보장하지 않음
                    print("[DEBUG] value: \(counter.increment())")
                }
                 */
                
                DispatchQueue.concurrentPerform(iterations: 100) { _ in
                    Task {
                        print("[DEBUG] value: \(await counter.increment())")
                    }
                }
            } label: { Text("Increment") }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
