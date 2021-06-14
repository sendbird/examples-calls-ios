//
//  UIActivityIndicatorView+QuickStart.swift
//  QuickStart
//
//  Created by Jaesung Lee on 2020/06/17.
//  Copyright © 2020 Sendbird Inc. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func startLoading(on view: UIView?) {
        guard self.isAnimating == false else { return }
        guard let view = view else { return }
        
        self.center = view.center
        self.hidesWhenStopped = true
        self.style = .gray
        
        if view != self.superview {
            self.superview?.removeFromSuperview()
            view.addSubview(self)
        }
        
        self.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoading() {
        guard self.isAnimating == true else { return }
        
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
