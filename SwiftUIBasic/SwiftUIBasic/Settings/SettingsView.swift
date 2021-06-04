//
//  SettingsView.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import SwiftUI
import SendBirdCalls


struct SettingsView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            HStack {
                /// **User Profile Image**
                ProfileImage {
                    Image("iconAvatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                }
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                
                VStack {
                    HStack {
                        /// **User ID**
                        Text("USER ID: " + (viewModel.currentUser?.userId ?? "Any ID"))
                            .font(.body.smallCaps())
                        
                        Spacer()
                    }
                    
                    HStack {
                        /// **Nickname**
                        Text("NICKNAME: " + (viewModel.currentUser?.nickname ?? "Any nickname"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.08)))
            
            Divider()
            
            Button(action: viewModel.deauthenticate) {
                authStyleBody
            }
            
            Spacer()
        }
    }
    
    var authStyleBody: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(#colorLiteral(red: 0.4549019608, green: 0.1764705882, blue: 0.8666666667, alpha: 1)))
            .frame(height: 48)
            .padding(.horizontal)
            .overlay(
                Label(
                    title: {
                        Text("Deauthenticate")
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
