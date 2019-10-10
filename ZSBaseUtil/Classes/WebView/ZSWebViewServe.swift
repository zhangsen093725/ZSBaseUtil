//
//  ZSWebViewServe.swift
//  test
//
//  Created by 张森 on 2019/10/9.
//  Copyright © 2019 张森. All rights reserved.
//

import WebKit

class ZSSecureTextEntryCash: NSObject {

    class func defult() {
        
        let onceToken: () = {
            
            guard let systemVersion = Float(UIDevice.current.systemVersion) else { return }
            
            guard systemVersion >= 8.0 else { return }
            
            guard let WKContentViewClass: AnyClass = objc_getClass("WKContentView") as? AnyClass else { return }
            
            let isSecureTextEntry: Selector = NSSelectorFromString("isSecureTextEntry")
            
            if !WKContentViewClass.instancesRespond(to: isSecureTextEntry) {
                
                if let isSecureTextEntryIMP = class_getMethodImplementation(self, isSecureTextEntry) {
                    
                    let addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, isSecureTextEntryIMP, "B@:")
                    
                    if !addIsSecureTextEntry {
                        print("addIsSecureTextEntry修复失败")
                    }
                }
            }
            
            
            let secureTextEntry: Selector = NSSelectorFromString("secureTextEntry")
            
            if !WKContentViewClass.instancesRespond(to: secureTextEntry) {
                
                if let secureTextEntryIMP = class_getMethodImplementation(self, secureTextEntry) {
                    
                    let addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, secureTextEntryIMP, "B@:")
                    
                    if !addSecureTextEntry {
                        print("addSecureTextEntry修复失败")
                    }
                }
            }
        }()
        onceToken
    }
    
    /**
     实现WKContentView对象isSecureTextEntry方法
     @return false
     */
    @objc func isSecureTextEntry(_ sender: Any, cmd: Selector) -> Bool {
        return false
    }
    
    /**
     实现WKContentView对象secureTextEntry方法
     @return false
     */
    @objc func secureTextEntry(_ sender: Any, cmd: Selector) -> Bool {
        return false
    }
}
