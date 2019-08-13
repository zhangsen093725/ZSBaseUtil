//
//  ZSUIBaseUtil.swift
//  Pods-ZSBaseUtil_Example
//
//  Created by 张森 on 2019/8/13.
//

import Foundation

// MARK: - UITableView扩展
extension UITableView {
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
    }
}


// MARK: - UILabel扩展
extension UILabel {
    
    public var attributedTextTail: NSAttributedString? {
        set {
            self.attributedText = attributedTextTail;
            self.lineBreakMode = .byTruncatingTail;
        }
        get {
            return attributedText
        }
    }
}


// MARK: - UIViewController扩展
extension UIViewController {

    public func presentRootController(animated: Bool = false, complete: (()->Void)? = nil) {

        if let presentedViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            presentedViewController.present(self, animated: animated, completion: complete)
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: complete)
        }
    }
}
