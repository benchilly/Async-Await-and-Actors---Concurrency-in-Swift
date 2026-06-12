//
//  ContentView.swift
//  BankAccountTransferActors
//
//  Created by 홍진표 on 6/7/26.
//

import SwiftUI

enum BankError: Error {
    case insufficientFunds(Double)
}

actor BankAccount {
    let accountNumber: Int
    var balance: Double
    
    init(accountNumber: Int, balance: Double) {
        self.accountNumber = accountNumber
        self.balance = balance
    }
    
    nonisolated func getCurrentAPR() -> Double {
        return 0.2
    }
    
    func deposit(_ amount: Double) -> Void { balance += amount }
    
    func transfer(amount: Double, to other: BankAccount) async throws -> Void {
        if (amount > balance) {
            throw BankError.insufficientFunds(amount)
        }
        
        balance -= amount
        await other.deposit(amount)
        
        print("Current Account: \(balance), Other Account: \(await other.balance)")
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                let bankAccount: BankAccount = BankAccount(accountNumber: 123, balance: 500)
                let otherAccount: BankAccount = BankAccount(accountNumber: 456, balance: 100)
                
                let _: Double = bankAccount.getCurrentAPR()
                
                DispatchQueue.concurrentPerform(iterations: 100) { _ in
                    Task {
                        try? await bankAccount.transfer(amount: 300, to: otherAccount)
                    }
                }
            } label: {
                Text(verbatim: "Transfer")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
