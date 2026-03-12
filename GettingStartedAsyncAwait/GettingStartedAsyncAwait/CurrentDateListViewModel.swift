//
//  CurrentDateListViewModel.swift
//  GettingStartedAsyncAwait
//
//  Created by 홍진표 on 1/28/26.
//

import Foundation
import Combine

//  @MainActor 사용으로 CurrentDateListViewModel 객체는 UI와 직접 연결된 객체이며,
//  모든 상태 변경은 Main thread에서 일어남을 명시적으로 선언
@MainActor
class CurrentDateListViewModel: ObservableObject {
    
    @Published var currentDates: [CurrentDateViewModel] = []
    
    func populateDates() async -> Void {
        
        do {
            let currentDate = try await WebService().getDate()
            if let currentDate = currentDate {
                let currentDateViewModel = CurrentDateViewModel(currentDate: currentDate)
                
                /*
                DispatchQueue.main.async {
                    self.currentDates.append(currentDateViewModel)
                }
                 */
                
                //  @MainActor 사용으로 DispatchQueue.main.async {}를 사용할 필요가 없음
                self.currentDates.append(currentDateViewModel)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CurrentDateViewModel {
    
    let currentDate: CurrentDate
    var id: UUID {
        get { return currentDate.id }
    }
    var date: String {
        get { return currentDate.date }
    }
}
