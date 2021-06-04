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
    @Published var error: String = ""
    @Published var authRequired: Bool = true
    
    var currentUser: User? { SendBirdCall.currentUser }
    
    func authenticate() {
        let authParams = AuthenticateParams(
            userId: userID,
            accessToken: accessToken.isEmpty ? nil : accessToken
        )
        
        SendBirdCall.authenticate(with: authParams) { [self] user, error in
            if let error = error {
                self.error = error.localizedDescription
                return
            }
            authRequired = false
            SendBirdCall.registerRemotePush(token: UserDefaults.standard.remotePushToken, completionHandler: nil)
        }
    }
    
    func deauthenticate() {
        SendBirdCall.deauthenticate { [self] error in
            if let error = error {
                self.error = error.localizedDescription
                return
            }
            authRequired = true
        }
    }
}
