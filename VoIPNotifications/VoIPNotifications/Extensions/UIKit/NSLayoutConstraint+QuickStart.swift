//
//  NSLayoutConstraint+QuickStart.swift
//  QuickStart
//
//  Copyright © 2020 Sendbird, Inc. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func animate(value: CGFloat) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.constant = value
        }
        
        animator.startAnimation()
    }
}
