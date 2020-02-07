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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        
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
}

