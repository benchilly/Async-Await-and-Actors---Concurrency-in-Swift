//
//  ContentView.swift
//  LearnActors
//
//  Created by 홍진표 on 6/4/26.
//

import SwiftUI
import Combine

// MARK: Model
actor BankAccount {
    private(set) var balance: Double
    private(set) var transaction: [String] = []
    
    init(balance: Double) { self.balance = balance }
    
    func getBalance() -> Double { return balance }
    
    func withdraw(_ amount: Double) -> Void {
        if (balance >= amount) {
            let processingTime: UInt32 = UInt32.random(in: 0...3)
            print("[Withdraw] Processing for \(amount) | \(processingTime) seconds")
            transaction.append("[Withdraw] Processing for \(amount) | \(processingTime) seconds")
            
            sleep(processingTime)
            print("Withdrawing \(amount) from account")
            transaction.append("Withdrawing \(amount) from account")
            
            self.balance -= amount
            print("Balance is \(balance)")
            transaction.append("Balacdee is \(balance)")
        }
    }
}

// MARK: ViewModel
@MainActor
class BankAccountViewModel: ObservableObject {
    private var bankAccount: BankAccount
    @Published var currentBalance: Double?
    @Published var transaction: [String] = []
    
    init(balance: Double) {
        self.bankAccount = BankAccount(balance: balance)
    }
    
    func withdraw(_ amount: Double) async -> Void {
        await bankAccount.withdraw(amount)
        
        self.currentBalance = await self.bankAccount.getBalance()
        self.transaction = await self.bankAccount.transaction
    }
}

// MARK: View
struct ContentView: View {
    @StateObject private var bankAccountViewModel: BankAccountViewModel = BankAccountViewModel(balance: 500)
    let queue: DispatchQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
    
    var body: some View {
        VStack {
            Button("Withdraw") {
                Task.detached {
                    await bankAccountViewModel.withdraw(200)
                }
                
                Task.detached {
                    await bankAccountViewModel.withdraw(500)
                }
            }
            Text(verbatim: "\(bankAccountViewModel.currentBalance ?? 0.0)")
            List(bankAccountViewModel.transaction, id: \.self) { transaction in
                Text(verbatim: transaction)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
