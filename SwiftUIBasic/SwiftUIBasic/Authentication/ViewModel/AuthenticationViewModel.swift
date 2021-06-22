//
//  AuthenticationViewModel.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import Combine
import Commons
import SendBirdCalls

class AuthenticationViewModel: ObservableObject {
    @Published var userID: String = ""
    @Published var accessToken: String = ""
    @Published var authRequired: Bool = true
    
    var currentUser: User? { SendBirdCall.currentUser }
    
    func authenticate() {
        /// 1. Create `AuthenticateParams`
        let authParams = AuthenticateParams(
            userId: userID,
            accessToken: accessToken.isEmpty ? nil : accessToken
        )
        
        /// 2. Authenticate with the pararms
        SendBirdCall.authenticate(with: authParams) { [self] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            /// 3. Dismiss AuthView
            authRequired = false
            
            /// 4. Remote push token registration
            SendBirdCall.registerRemotePush(token: UserDefaults.standard.remotePushToken, completionHandler: nil)
        }
    }
    
    func deauthenticate() {
        /// 1. deauthenticate
        SendBirdCall.deauthenticate { [self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            authRequired = true
        }
    }
}
