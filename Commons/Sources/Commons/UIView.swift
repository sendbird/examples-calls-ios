//
//  File.swift
//  
//
//  Created by Minhyuk Kim on 2020/12/07.
//

import UIKit

extension UIView {
    public func embed(_ videoView: UIView) {
        self.insertSubview(videoView, at: 0)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view": videoView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view": videoView]))
        self.layoutIfNeeded()
    }
}
