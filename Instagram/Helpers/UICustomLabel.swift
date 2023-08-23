//
//  CustomLabel.swift
//  Instagram
//
//  Created by Jo Michael on 8/10/23.
//

import UIKit

class UICustomLabel: UILabel {
    
    var padding: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }
}
