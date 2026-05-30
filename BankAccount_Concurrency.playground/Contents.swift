import UIKit

class BankAccount {
    var balance: Double
    let lock: NSLock = NSLock()
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func withdraw(_ amount: Double) -> Void {
        lock.lock()
        
        if (balance >= amount) {
            let processingTime: UInt32 = UInt32.random(in: 0...3)
            print("[withDraw] Processing for \(amount) | \(processingTime) seconds")
            sleep(processingTime)
            print("withDrawing \(amount) from account")
            
            balance -= amount
            print("Balance is \(balance)")
        }
        
        lock.unlock()
    }
}

// FIXME: Race Condition & Data Race
/// `Race Condition (경쟁 상태)`
/// 정의: 여러 프로세스나 스레드가 공유 자원에 동시에 접근할 때, `실행 순서에 따라 결과가 달라지는 현상`
///
/// `Data Race (데이터 경쟁)`
/// 정의: 두 개 이상의 스레드가 `동시에 같은 메모리 위치에 접근`하고, 그 중 `최소 하나는 Write 작업`이며, 스레드 간의 `동기화가 없을 때` 발생하는 현상
/*
let bankAccount: BankAccount = BankAccount(balance: 500)
let queue: DispatchQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)

queue.async {
    bankAccount.withdraw(300)
}


queue.async {
    bankAccount.withdraw(500)
}
 */


// TODO: 1.Serial Queue로 처리
/*
let bankAccount: BankAccount = BankAccount(balance: 500)
let queue: DispatchQueue = DispatchQueue(label: "SerialQueue")

queue.async {
    bankAccount.withdraw(300)
}

queue.async {
    bankAccount.withdraw(500)
}
 */

// TODO: 2.NSLock (Mutex)로 처리
/// `Mutex (Mutual Exclusion, 상호 배제)`
/// 정의: 여러 스레드나 프로세스가 동시에 공유 자원에 접근할 때, `단 하나의 스레드만` 자원에 접근할 수 있도록 제한하는 동기화 기법
///
/// 임계 구역 (Critical Section): 공유 자원에 접근하는 코드의 영역
/// 잠금 (Locking): 하나의 스레드가 임계 구역에 들어가면 Lock을 걸어 다른 스레드가 들어오지 못하게 막음
/// 해제 (Unlocking): 작업을 마친 후, Unlock해야 대기하던 다른 스레드가 자원을 사용할 수 있음
let bankAccount: BankAccount = BankAccount(balance: 500)
let queue: DispatchQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)

queue.async {
    bankAccount.withdraw(300)
}

queue.async {
    bankAccount.withdraw(500)
}
