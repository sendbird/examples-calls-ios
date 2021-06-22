//
//  DirectCallLogList.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/05/21.
//

import SwiftUI

struct DirectCallLogList: View {
    @StateObject private var viewModel = DirectCallLogListViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: viewModel.next) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                        .frame(width: 52, height: 52)
                }
            }
            
            if viewModel.logs.isEmpty {
                Spacer()
                
                Text("There's no call log. ")
                
                Spacer()
            } else {
                List(viewModel.logs, id: \.self) {
                    DirectCallLogRow(callLog: $0)
                }
            }
        }
        .onAppear(perform: viewModel.next)
    }
}


