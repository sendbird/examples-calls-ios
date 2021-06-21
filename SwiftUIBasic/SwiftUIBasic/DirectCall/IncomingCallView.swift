//
//  IncomingCallView.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import SwiftUI
import SendBirdCalls

struct IncomingCallView: View {
    @ObservedObject var viewModel: DirectCallViewModel
    @EnvironmentObject private var appState: SwiftUIAppState
    
    var body: some View {
        HStack {
            Button(action: viewModel.accept) {
                acceptStyleBody
            }
            
            Button(action: viewModel.end) {
                declineStyleBody
            }
        }
        .onAppear {
            viewModel.call = appState.incomingCall
        }
    }
    
    // MARK: - Call interactions
    func accept() {
        viewModel.accept()
    }
    
    func decline() {
        viewModel.end()
    }
}

// MARK: - Design
extension IncomingCallView {
    var acceptStyleBody: some View {
        Color
            .green
            .frame(width: 52, height: 52)
            .cornerRadius(26)
            .overlay(
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            )
    }
    
    var declineStyleBody: some View {
        Color
            .red
            .frame(width: 52, height: 52)
            .cornerRadius(26)
            .overlay(
                Image(systemName: "phone.down.fill")
                    .foregroundColor(.white)
            )
    }
}
