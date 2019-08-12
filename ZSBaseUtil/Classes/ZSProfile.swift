//
//  JDProfile.swift
//  JadeKing
//
//  Created by 张森 on 2019/8/3.
//  Copyright © 2019 张森. All rights reserved.
//

import Foundation

enum KDevice {
    
    // MARK: - 屏幕宽高、frame
    static let width: CGFloat = UIScreen.main.bounds.width
    static let height: CGFloat = UIScreen.main.bounds.height
    static let frame: CGRect = UIScreen.main.bounds
    
    // MARK: - 屏幕16:9比例系数下的宽高
    static let width16_9: CGFloat = KDevice.height * 9.0 / 16.0
    static let height16_9: CGFloat = KDevice.width * 16.0 / 9.0
    
    // MARK: - 关于刘海屏幕适配
    static let tabbarHeight: CGFloat = KDevice.aboveiPhoneX ? 83 : 49
    static let homeHeight: CGFloat = KDevice.aboveiPhoneX ? 34 : 0
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    // MARK: - 设备类型
    static let isPhone: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
    static let isPad: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    static let aboveiPhoneX: Bool = (Float(String(format: "%.2f", 9.0 / 19.5)) == Float(String(format: "%.2f", KDevice.width / KDevice.height)))
}


// MARK: - iPhone以375 * 667为基础机型的比例系数，iPad以768 * 1024为基础机型的比例系数
let KWidthUnit: CGFloat = KDevice.width / (KDevice.isPad ? 768.0 : 375.0)
let KHeightUnit: CGFloat = KDevice.isPad ? KDevice.height / 1024.0 : ( KDevice.aboveiPhoneX ? KDevice.height16_9 / 667.0 : KDevice.height / 667.0 )


// MARK: - 子试图16:9比例系数下的宽高
func KSubViewWidth16_9(_ subViewHeight: CGFloat) -> CGFloat {
    return KDevice.isPad ? subViewHeight * 3.0 / 4.0 : subViewHeight * 9.0 / 16.0
}

func KSubViewHeight16_9(_ subviewWidth: CGFloat) -> CGFloat {
    return KDevice.isPad ? subviewWidth * 4.0 / 3.0 : subviewWidth * 16.0 / 9.0
}


// MARK: - iPad适配
func iPadWidth(_ viewWidth: CGFloat) -> CGFloat {
    return viewWidth / 375.0 * KDevice.width  // 以375宽度进行比例计算
}

func iPadHeight(_ viewHeight: CGFloat) -> CGFloat {
    return viewHeight / 667.0 * KDevice.height  // 以667高度进行比例计算
}

func iPadFullScreenWidthToHeight(_ viewHeight: CGFloat) -> CGFloat {
    return KDevice.isPad ? KDevice.width / 375.0 * viewHeight * KHeightUnit : viewHeight * KHeightUnit
}


// MARK: - 字体和颜色
func KFont(_ font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font * KHeightUnit)
}

func KColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

