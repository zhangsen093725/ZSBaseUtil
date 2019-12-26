//
//  ZSNoticeManager.swift
//  Pods-ZSBaseUtil_Example
//
//  Created by 张森 on 2019/8/16.
//

import UIKit

@objc public protocol ZSNoticeToolDelegate {
    
    @objc optional func zs_enterBackground()
    @objc optional func zs_enterForeground()
    @objc optional func zs_keyboardWillShow(frame: CGRect)
    @objc optional func zs_keyboardWillHide()
}


@objcMembers public class ZSNoticeTool: NSObject {
    
    public weak var delegate: ZSNoticeToolDelegate?
    
    public func addAllObservers() {
        
        addKeyboardObserver()
        addEnterBackForeObserver()
    }
    
    public func removeAllObservers() {
        
        removeKeyboardObserver()
        removeEnterBackForeObserver()
    }
    
    
    // MARK: - 进入前后台的通知
    public func addEnterBackForeObserver() {
        let notice: NotificationCenter = NotificationCenter.default
        
        notice.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notice.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    public func removeEnterBackForeObserver() {
        
        let notice: NotificationCenter = NotificationCenter.default
        
        notice.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        notice.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func enterBackground() {
        delegate?.zs_enterBackground?()
    }
    
    @objc func enterForeground() {
        delegate?.zs_enterForeground?()
    }
    
    
    // MARK: - 键盘的通知
    public func addKeyboardObserver() {
        let notice: NotificationCenter = NotificationCenter.default
        
        notice.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notice.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func removeKeyboardObserver() {
        let notice: NotificationCenter = NotificationCenter.default
        
        notice.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notice.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notifiaction: Notification) {

        if let keyboardFrame: CGRect = notifiaction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            delegate?.zs_keyboardWillShow?(frame: keyboardFrame)
        }
    }
    
    @objc func keyboardWillHide(_ notifiaction: Notification) {
        
        delegate?.zs_keyboardWillHide?()
    }
    
}
