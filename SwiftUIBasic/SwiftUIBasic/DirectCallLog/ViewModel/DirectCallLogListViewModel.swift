//
//  DirectCallLogListViewModel.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import Combine
import SendBirdCalls

class DirectCallLogListViewModel: ObservableObject {
    @Published var logs: [DirectCallLog] = []
    @Published var error: String = ""
    
    private var query: DirectCallLogListQuery?
    
    func next() {
        let params = DirectCallLogListQuery.Params()
        params.myRole = .all
        params.endResults = []
        params.limit = 10
        
        query = SendBirdCall.createDirectCallLogListQuery(with: params)
        
        query?.next { [self] logs, error in
            if let logs = logs {
                self.logs.append(contentsOf: logs)
            }
            if let error = error {
                self.error = error.localizedDescription
            }
        }
    }
}

