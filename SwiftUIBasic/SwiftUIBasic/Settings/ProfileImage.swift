//
//  SettingsView.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/05/21.
//

import SwiftUI
import SendBirdCalls
import Kingfisher

struct ProfileImage<Content: View>: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var content: () -> Content
    
    var body: some View {
        if let currentUser = viewModel.currentUser {
            if let profileURL = currentUser.profileURL {
                KFImage
                    .url(URL(string: profileURL))
                    .placeholder(content)
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .resizable()
                    
            }
        } else {
            content()
        }
    }
    
    init(@ViewBuilder _ content: @escaping () -> (Content)) {
        self.content = content
    }  
}
