//
//  ZSWebJSUtil.swift
//  test
//
//  Created by 张森 on 2019/10/9.
//  Copyright © 2019 张森. All rights reserved.
//

import WebKit

@objc public protocol ZSWebJSToolDelegate {
    func zs_webViewJavaScriptFunction(_ function: String, params: Any?)
}

@objcMembers public class ZSWebJSTool: NSObject, WKScriptMessageHandler {
    
    public class func evaluateJavaScriptFunction(_ function: String, webView: WKWebView, params: String) {
        
        webView.evaluateJavaScript(function + "(" + params + ")") { (obj, error) in
            print("-----------evaluateJavaScript Begin-------------")
            print("function: \(function)")
            print("params:  \(params)")
            print(obj ?? "null")
            print(error ?? "无错误信息")
            print("-----------evaluateJavaScript End-------------")
        }
    }
    
    public weak var delegate: ZSWebJSToolDelegate?
    
    public func addScriptMessageHandler(_ webView: WKWebView, funcNames: [String]) {
        
        let userContentController = webView.configuration.userContentController

        for funcName in funcNames {
            userContentController.add(self, name: funcName)
        }
    }
    
    public func removeScriptMessageHandler(_ webView: WKWebView, funcNames: [String]) {
        
        let userContentController = webView.configuration.userContentController
        
        for funcName in funcNames {
            userContentController.removeScriptMessageHandler(forName: funcName)
        }
    }
    

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
