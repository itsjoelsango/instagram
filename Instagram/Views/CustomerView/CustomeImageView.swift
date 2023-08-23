//
//  CustomeImageView.swift
//  Instagram
//
//  Created by Jo Michael on 7/29/23.
//

import UIKit

@IBDesignable
class CustomeImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 16.0
        self.layer.shadowColor = UIColor.systemBrown.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }
}
