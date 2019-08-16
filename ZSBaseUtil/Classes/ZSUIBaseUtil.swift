//
//  ZSUIBaseUtil.swift
//  Pods-ZSBaseUtil_Example
//
//  Created by 张森 on 2019/8/13.
//

import Foundation

// MARK: - UITableView扩展
@objc extension UITableView {
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
    }
}


// MARK: - UILabel扩展
@objc extension UILabel {
    
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
@objc extension UIViewController {
    
    public func presentRootController(animated: Bool = false, complete: (()->Void)? = nil) {
        
        if let presentedViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            presentedViewController.present(self, animated: animated, completion: complete)
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: complete)
        }
    }
}


// MARK: - UIView扩展
@objc public extension UIView {
    
    var zs_x: CGFloat {
        set{
            self.frame.origin.x = newValue
        }
        get{
            return self.frame.minX
        }
    }
    
    var zs_y: CGFloat {
        set{
            self.frame.origin.y = newValue
        }
        get{
            return self.frame.minY
        }
    }
    
    var zs_w: CGFloat {
        set{
            self.frame.size.width = newValue
        }
        get{
            return self.frame.width
        }
    }
    
    var zs_h: CGFloat {
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.height
        }
    }
    
    var zs_maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    var zs_maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    class var zs_currentControllerView: UIView? {
        get {
            var controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            
            while (controller?.presentedViewController != nil && !(controller?.presentedViewController is UIAlertController)) {
                controller = controller?.presentedViewController
            }
            return controller?.view
        }
    }
    
    func addSubviewToControllerView() {
        UIView.zs_currentControllerView?.addSubview(self)
    }
    
    func addSubviewToRootControllerView() {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
    }
}
