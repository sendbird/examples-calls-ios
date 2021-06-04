//
//  DirectCallLogRow.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import SwiftUI
import SendBirdCalls

struct DirectCallLogRow: View {
    let callLog: DirectCallLog
    
    var body: some View {
        VStack {
            HStack {
                Text("From \(callLog.caller?.userId ?? "")")
                
                Spacer()
                
                Text("To \(callLog.callee?.userId ?? "")")
            }
            
            HStack {
                Text(callLog.endResult.rawValue)
                
                Spacer()
                
                Text(
                    Date(timeIntervalSince1970: TimeInterval(callLog.endedAt) / 1000),
                    style: .time
                )
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}
