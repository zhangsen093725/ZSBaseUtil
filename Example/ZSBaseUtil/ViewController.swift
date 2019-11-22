//
//  ViewController.swift
//  ZSBaseUtil
//
//  Created by zhangsen093725 on 08/12/2019.
//  Copyright (c) 2019 zhangsen093725. All rights reserved.
//

import UIKit
import ZSBaseUtil

class ViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        phoneField.frame = CGRect(x: 20, y: 100, width: 200, height: 30)
        // Do any additional setup after loading the view, typically from a nib.
        safariView.load(url: "https://www.baidu.com".zs_url!)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        safariView.frame = view.bounds
    }
    
}

