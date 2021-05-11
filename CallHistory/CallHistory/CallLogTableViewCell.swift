//
//  CallLogTableViewCell.swift
//  CallHistory
//
//  Created by Jaesung Lee on 2021/05/11.
//

import UIKit
import SendBirdCalls

class CallLogTableViewCell: UITableViewCell {
    @IBOutlet weak var callTypeImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var startedAtLabel: UILabel!
    @IBOutlet weak var endReasonLabel: UILabel!
    
    var callLog: DirectCallLog! {
        didSet {
            updateUI()
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        return dateFormatter
    }()
    
    func updateUI() {
        let remoteUser = callLog.myRole == .caller
            ? callLog.callee
            : callLog.caller
        
        callTypeImageView.image = UIImage.callTypeImage(
            outgoing: callLog.myRole == .caller,
            hasVideo: callLog.isVideoCall
        )
        nicknameLabel.text = (remoteUser?.nickname?.collapsed ?? "-")
        userIdLabel.text = "ID: \(remoteUser?.userId ?? "Unknown caller")"
        startedAtLabel.text = Self.dateFormatter.string(
            from: Date(
                timeIntervalSince1970: Double(callLog.startedAt) / 1000
            )
        )
        let endResult = callLog.endResult.rawValue.replacingOccurrences(of: "_", with: " ")
        let duration = callLog.duration.durationToString()
        endReasonLabel.text = "\(endResult) \(duration)"
    }
}

extension UIImage {
    /// - Returns: UIImage object based on call type.
    static func callTypeImage(outgoing: Bool, hasVideo: Bool) -> UIImage? {
        if hasVideo {
            return UIImage(
                named: outgoing ? "iconCallVideoOutgoingFilled" : "iconCallVideoIncomingFilled"
            )
        } else {
            return UIImage(
                named: outgoing ? "iconCallVoiceOutgoingFilled" : "iconCallVoiceIncomingFilled"
            )
        }
    }
}

extension Int64 {
    func durationToString() -> String {
        let convertedTime = Int(self / 1000)
        let hr = Int(convertedTime / 3600)
        let min = Int(convertedTime / 60) % 60
        let sec = Int(convertedTime % 60)
        
        if hr > 0 {
            return String(format: "%02d:%02d", hr, min)
        } else {
            return String(format: "%02d:%02d", min, sec)
        }
    }
}
