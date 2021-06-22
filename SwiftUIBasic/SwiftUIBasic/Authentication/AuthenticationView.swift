//
//  AuthenticationView.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            VStack {
                /// App Icon
                Image("icLogoSymbol")
                
                /// App title
                Text("Sendbird Calls")
                    .font(.title2)
                    .bold()
                    .padding(.vertical, 32)
                
                /// User ID
                TextField("user ID", text: $viewModel.userID)
                
                /// Access token (Optional)
                TextField("(Optional) access token", text: $viewModel.accessToken)
                
                Divider()
            }
            .padding()
            
            /// Authentication button
            Button(action: viewModel.authenticate) {
                authStyleBody
            }
            
            Spacer()
        }
    }
}

// MARK: - Design
extension AuthenticationView {
    var authStyleBody: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(#colorLiteral(red: 0.4549019608, green: 0.1764705882, blue: 0.8666666667, alpha: 1)))
            .frame(height: 48)
            .padding(.horizontal)
            .overlay(
                Label(
                    title: {
                        Text("Authenticate")
                            .foregroundColor(.white)
                    },
                    icon: {
                        Image("sendbird.logo.white")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                )
            )
    }
}
