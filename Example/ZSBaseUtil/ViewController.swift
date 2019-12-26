//
//  ViewController.swift
//  ZSBaseUtil
//
//  Created by zhangsen093725 on 08/12/2019.
//  Copyright (c) 2019 zhangsen093725. All rights reserved.
//

import UIKit
import ZSBaseUtil

class ViewController: UIViewController, ZSLoopScrollViewDataSource {
  
    lazy var phoneField: ZSPhoneField = {
        
        let phoneField = ZSPhoneField()
        phoneField.placeholder = "输入手机号码"
        phoneField.placeholderColor = KColor(51, 51, 51, 0.1)
        view.addSubview(phoneField)
        return phoneField
    }()
    
    lazy var safariView: ZSWebView = {
        
        let safariView = ZSWebView()
        view.addSubview(safariView)
        return safariView
    }()
    
    lazy var loopScrollView: ZSLoopScrollView = {
        
        let loopScrollView = ZSLoopScrollView()
        loopScrollView.dataSource = self
        loopScrollView.isAutoScroll = true
        loopScrollView.isLoopScroll = true
        loopScrollView.interval = 10
        view.addSubview(loopScrollView)
        return loopScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        phoneField.frame = CGRect(x: 20, y: 100, width: 200, height: 30)
        loopScrollView.frame = CGRect(x: 30, y: 150, width: 300, height: 200)
        // Do any additional setup after loading the view, typically from a nib.
//        safariView.load(url: "https://www.baidu.com".zs_url!)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        safariView.frame = view.bounds
    }
    
    
    // TODO: ZSLoopScrollViewDataSource
    func zs_numberOfItemLoopScrollView(_ loopScrollView: ZSLoopScrollView) -> Int {
        
        return 3
    }
    
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, itemAt index: Int, isFirst: Bool, isLast: Bool) -> UIView {
        
        
        var imageView: UIImageView? = loopScrollView.viewWithIndex(index)
        
        if imageView == nil {
            imageView = UIImageView()
        }
        
        if isFirst {
            imageView?.image = UIImage(named: "JzkLjvgyeglYlIkyj7ur")
            return imageView!
        }
        
        if isLast {
            imageView?.image = UIImage(named: "JzkLjvgyeglYlIkyj7ur")
            return imageView!
        }
        
        imageView?.image = UIImage(named: "JzkLjvgyeglYlIkyj7ur")
        
        return imageView!
    }
    
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, sizeAt index: Int, isFirst: Bool, isLast: Bool) -> CGSize {
        
        return loopScrollView.bounds.size
    }
}

