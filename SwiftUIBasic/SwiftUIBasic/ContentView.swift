//
//  ContentView.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/05/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        TabView {
            /**
             - (User Info) Displays authenticated user ID and nickname.
             - (Direct Call) Makes an outgoing direct call.
             */
            DirectCallView()
                .tabItem {
                    Image(systemName: "phone.fill")
                    
                    Text("Direct Call")
                }
            
            /**
             Displays list of direct call logs.
             */
            DirectCallLogList()
                .tabItem {
                    Image(systemName: "list.dash")
                    
                    Text("Call Logs")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    
                    Text("Account")
                }
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $viewModel.authRequired) {
            /**
             Displays authenticating button and textfield for entering user ID.
             */
            AuthenticationView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
