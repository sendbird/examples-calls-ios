//
//  File.swift
//  
//
//  Created by Minhyuk Kim on 2020/12/07.
//

import Foundation

extension String {
    public var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var isEmptyOrWhitespace: Bool {
        self.trimmed.isEmpty
    }
    
    public var collapsed: String? {
        if self.isEmptyOrWhitespace {
            return nil
        } else {
            return self.trimmed
        }
    }
}
