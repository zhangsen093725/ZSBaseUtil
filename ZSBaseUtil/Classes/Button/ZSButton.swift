//
//  ZSButton.swift
//  JadeToB
//
//  Created by 张森 on 2019/11/12.
//  Copyright © 2019 张森. All rights reserved.
//

import UIKit

class ZSButton: UIButton {
    
    struct Content {
        enum Inset {
            case imgL
            case imgR
            case imgT
            case imgB
        }
    }
    
    var contentInset: Content.Inset = .imgL
    
    lazy var imageBackView: UIView = {
        
        let imageBackView = UIView()
        imageBackView.backgroundColor = .clear
        imageBackView.isUserInteractionEnabled = false
        imageBackView.addSubview(imageView ?? UIImageView())
        addSubview(imageBackView)
        return imageBackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch contentInset {
        case .imgL:
            
            layoutImageLeft()
            break
        case .imgR:
            
            layoutImageRight()
            break
        case .imgT:
            
            layoutImageTop()
            break
        case .imgB:
            
            layoutImageBottom()
            break
        }
    }
    
    func layoutImageLeft() {
        
        let imageBackSize = min(frame.height, frame.width)
        
        imageBackView.frame = CGRect(x: 0, y: (frame.height - imageBackSize) * 0.5, width: imageBackSize, height: imageBackSize)
        
        let imageWidth = imageBackSize - imageEdgeInsets.left - imageEdgeInsets.right
        let imageHeight = imageBackSize - imageEdgeInsets.top - imageEdgeInsets.bottom
        
        imageView?.frame = CGRect(x: (imageBackView.frame.width - imageWidth) * 0.5, y: (imageBackView.frame.height - imageHeight) * 0.5, width: imageWidth, height: imageHeight)
        
        let titleWidth = frame.width - imageBackView.frame.maxX - titleEdgeInsets.left - titleEdgeInsets.right
        let titleHeight = frame.height - titleEdgeInsets.top - titleEdgeInsets.bottom
        
        titleLabel?.frame = CGRect(x: imageBackView.frame.maxX + titleEdgeInsets.left, y: titleEdgeInsets.top, width: titleWidth, height: titleHeight)
        titleLabel?.textAlignment = .left
    }
    
    
    func layoutImageRight() {
        
        let titleWidth = frame.width - titleEdgeInsets.left - titleEdgeInsets.right
        let titleHeight = frame.height - titleEdgeInsets.top - titleEdgeInsets.bottom
        
        titleLabel?.frame = CGRect(x: titleEdgeInsets.left, y: titleEdgeInsets.top, width: titleWidth, height: titleHeight)
        titleLabel?.textAlignment = .left
        
        
        let imageBackSize = min(frame.height, frame.width)
        
        imageBackView.frame = CGRect(x: titleLabel?.frame.maxX ?? 0, y: (frame.height - imageBackSize) * 0.5, width: imageBackSize, height: imageBackSize)
        
        let imageWidth = (titleLabel?.frame.maxX ?? 0) - imageEdgeInsets.left - imageEdgeInsets.right
        let imageHeight = imageBackSize - imageEdgeInsets.top - imageEdgeInsets.bottom
        
        imageView?.frame = CGRect(x: (imageBackView.frame.width - imageWidth) * 0.5, y: (imageBackView.frame.height - imageHeight) * 0.5, width: imageWidth, height: imageHeight)
    }
    
    
    func layoutImageTop() {
        
        let imageBackSize = min(frame.height - (titleLabel?.font.lineHeight ?? 0), frame.width)
        
        imageBackView.frame = CGRect(x: (frame.width - imageBackSize) * 0.5, y: 0, width: imageBackSize, height: imageBackSize)
        
        let imageWidth = imageBackSize - imageEdgeInsets.left - imageEdgeInsets.right
        let imageHeight = imageBackSize - imageEdgeInsets.top - imageEdgeInsets.bottom
        
        imageView?.frame = CGRect(x: (imageBackView.frame.width - imageWidth) * 0.5, y: (imageBackView.frame.height - imageHeight) * 0.5, width: imageWidth, height: imageHeight)
        
        
        let titleWidth = frame.width - titleEdgeInsets.left - titleEdgeInsets.right
        let titleHeight = frame.height - imageBackView.frame.maxY - titleEdgeInsets.top - titleEdgeInsets.bottom
        
        titleLabel?.frame = CGRect(x: titleEdgeInsets.left, y: imageBackView.frame.maxY + titleEdgeInsets.top, width: titleWidth, height: titleHeight)
        titleLabel?.textAlignment = .center
    }
    
    func layoutImageBottom() {
        
        let imageBackSize = min(frame.height - (titleLabel?.font.lineHeight ?? 0), frame.width)
        
        let titleWidth = frame.width - titleEdgeInsets.left - titleEdgeInsets.right
        let titleHeight = frame.height - imageBackSize - titleEdgeInsets.top - titleEdgeInsets.bottom
        
        titleLabel?.frame = CGRect(x: titleEdgeInsets.left, y: titleEdgeInsets.top, width: titleWidth, height: titleHeight)
        titleLabel?.textAlignment = .center
        
        
        imageBackView.frame = CGRect(x: (frame.width - imageBackSize) * 0.5, y: titleLabel?.frame.maxY ?? 0, width: imageBackSize, height: imageBackSize)
        
        let imageWidth = imageBackSize - imageEdgeInsets.left - imageEdgeInsets.right
        let imageHeight = imageBackSize - imageEdgeInsets.top - imageEdgeInsets.bottom
        
        imageView?.frame = CGRect(x: (imageBackView.frame.width - imageWidth) * 0.5, y: (imageBackView.frame.height - imageHeight) * 0.5, width: imageWidth, height: imageHeight)
    }
}
