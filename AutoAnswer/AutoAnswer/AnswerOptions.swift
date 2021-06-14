//
//  AnswerOptions.swift
//  AutoAnswer
//
//  Created by Minhyuk Kim on 2021/06/11.
//

import Foundation

/**
 AnswerOptions used to configure how to automatically handle incoming calls
 */
enum AnswerOptions: Int {
    /// Automatically accepts any incoming calls
    case accept
    /// Presents an alert to user before proceeding
    case wait
    /// Automatically declines any incoming calls
    case decline
    
    static var option = AnswerOptions.wait
}
