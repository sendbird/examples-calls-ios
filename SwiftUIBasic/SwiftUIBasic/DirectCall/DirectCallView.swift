//
//  DirectCallView.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/05/21.
//

import SwiftUI

struct DirectCallView: View {
    @StateObject private var viewModel = DirectCallViewModel()
    @EnvironmentObject private var appState: SwiftUIAppState
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Enter callee ID", text: $viewModel.calleeID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(viewModel.call != nil)
                .padding()
            
            if viewModel.callState == .none {
                Button(action: viewModel.dial) {
                    dialStyleBody
                }
            } else {
                Text(viewModel.call?.callId ?? "Failed call")
                
                Text(viewModel.callState.rawValue)
                
                Button(action: viewModel.end) {
                    endStyleBody
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $appState.onRinging) {
            IncomingCallView(viewModel: viewModel)
        }
    }
    
    var dialStyleBody: some View {
        Color
            .green
            .frame(width: 52, height: 52)
            .cornerRadius(26)
            .overlay(
                Image(systemName: "phone.fill")
                    .foregroundColor(.white)
            )
    }
    
    var endStyleBody: some View {
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
