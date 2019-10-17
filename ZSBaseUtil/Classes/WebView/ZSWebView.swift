//
//  ZSWebView.swift
//  test
//
//  Created by 张森 on 2019/10/9.
//  Copyright © 2019 张森. All rights reserved.
//

import WebKit
import JavaScriptCore

@objc public protocol ZSWebViewDelegate {
    
    @objc optional func zs_webView(_ webView: WKWebView, isDecidePolicy navigationAction: WKNavigationAction) -> Bool
    
    @objc optional func zs_webView(_ webView: WKWebView, alert message: String)
    
    @objc optional func zs_webViewDidLoad(_ webView: WKWebView)
    
    @objc optional func zs_webView(_ webView: WKWebView, loadFail error: Error)
    
    @objc optional func zs_webViewBeginLoad(_ webView: WKWebView)
    
    @objc optional func zs_webViewDidScroll(_ scrollView: UIScrollView)
    
    @objc optional func zs_webView(_ webView: WKWebView, loadFor progress : Float)
    
    @objc optional func zs_webView(_ webView: WKWebView, title: String)
}

@objcMembers public class ZSWebView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKUIDelegate, WKNavigationDelegate {
    
    @objc private lazy var webView: WKWebView = {
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.selectionGranularity = .character
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: nil)
        longPress.minimumPressDuration = 0.2
        longPress.delegate = self
        
        webView.addGestureRecognizer(longPress)
        webView.scrollView.decelerationRate = .normal
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        addSubview(webView)
        return webView
    }()
    
    public weak var delegate: ZSWebViewDelegate?
    
    public var contentView: WKWebView {
        return webView
    }
    
    public var isClearBackgroundColor: Bool = false {
        willSet {
            backgroundColor = .clear
            webView.isOpaque = !newValue
            webView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        }
    }
    
    public var isAllowZoom: Bool = false
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = bounds
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
    // TODO: 加载页面
    public func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    public func loadHTMLString(_ string: String, baseURL: URL) {
        webView.loadHTMLString(string, baseURL: baseURL)
    }
    
    public func loadFileURL(_ url: URL, baseURL: URL) {
        if #available(iOS 9.0, *) {
            webView.loadFileURL(url, allowingReadAccessTo: baseURL)
        }
    }
    
    // TODO: observe
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "title" {
            delegate?.zs_webView?(webView, title: webView.title ?? "unknow")
            return
        }
        
        if keyPath == "estimatedProgress" {
            let progress: NSNumber = change?[.newKey] as? NSNumber ?? NSNumber(value: 0)
            delegate?.zs_webView?(webView, loadFor: progress.floatValue)
            return
        }
    }
    
    // TODO: UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        next?.touchesBegan([touch], with: nil)
        return false
    }

    // TODO: UIScrollViewDelegate
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return isAllowZoom ? webView.scrollView.subviews.first : nil
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.zs_webViewDidScroll?(scrollView)
    }
    
    // TODO: WKNavigationDelegate
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.zs_webViewBeginLoad?(webView)
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.zs_webViewDidLoad?(webView)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        delegate?.zs_webView?(webView, loadFail: error)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if delegate?.zs_webView?(webView, isDecidePolicy: navigationAction) ?? true {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
    }
    
    // TODO: WKUIDelegate
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // Alert
        delegate?.zs_webView?(webView, alert: message)
        completionHandler()
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        // Alert
        delegate?.zs_webView?(webView, alert: message)
        completionHandler(false)
    }
}
