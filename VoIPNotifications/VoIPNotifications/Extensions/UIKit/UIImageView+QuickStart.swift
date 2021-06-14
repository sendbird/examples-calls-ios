//
//  UIImageView+QuickStart.swift
//  QuickStart
//
//  Copyright © 2020 Sendbird, Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    func rounding() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func border() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.QuickStart.lightPurple.cgColor
    }
    
    func updateImage(urlString: String?) {
        guard let urlString = urlString, !urlString.isEmpty else {
            self.image = UIImage(named: "iconAvatar")
            return
        }
        guard let profileURL = URL(string: urlString) else { return }
        
        ImageCache.shared.load(url: profileURL) { image, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Failed to load image")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // If returned image is same as current image
                guard self.image != image else { return }
                self.image = image
                self.layoutIfNeeded()
            }
        }
    }
}
