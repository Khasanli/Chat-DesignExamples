//
//  Extensions.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 03.07.21.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
}
extension UITextField {
    @objc func shakeAnimated(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 6, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 6, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
extension Notification.Name {
    static let didLoginNotification = Notification.Name("didLogNotification")
}


