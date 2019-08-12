//
//  ZSView.swift
//  JadeKing
//
//  Created by 张森 on 2019/8/3.
//  Copyright © 2019 张森. All rights reserved.
//

import Foundation

// MARK: - UIView扩展
@objc extension UIView {
    
    public var zs_x: CGFloat {
        set{
            self.frame.origin.x = newValue
        }
        get{
            return self.frame.minX
        }
    }
    
    public var zs_y: CGFloat {
        set{
            self.frame.origin.y = newValue
        }
        get{
            return self.frame.minY
        }
    }
    
    public var zs_w: CGFloat {
        set{
            self.frame.size.width = newValue
        }
        get{
            return self.frame.width
        }
    }
    
    public var zs_h: CGFloat {
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.height
        }
    }
    
    public var zs_maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    public var zs_maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
}


// MARK: - Timer扩展 
@objc extension Timer {
    
    @objc public class func zs_supportiOS_10EarlierTimer(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        
        if #available(iOS 10.0, *) {
            return Timer.init(timeInterval: interval, repeats: repeats, block: block)
        } else {
            return Timer.init(timeInterval: interval, target: self, selector: #selector(runTimer(_:)), userInfo: block, repeats: repeats)
        }
    }
    
    @objc private class func runTimer(_ timer: Timer) -> Void {
        
        guard let block: ((Timer) -> Void) = timer.userInfo as? ((Timer) -> Void) else { return }
        
        block(timer)
    }
}



// MARK: - NSObject扩展
@objc extension NSObject {
    
    public class func isEmpty(_ object: Any?) -> Bool {
        
        guard object != nil else { return true }
        
        if let array: NSArray = object as? NSArray {
            return array.count == 0
        }
        
        if let dictionary: NSDictionary = object as? NSDictionary {
            return dictionary.count == 0
        }
        
        if let set: NSSet = object as? NSSet {
            return set.count == 0
        }
        
        if let string: NSString = object as? NSString {
            return string.length == 0
        }
        
        return false
    }
    
    public class func paramsValue(_ object: Any?) -> Any {
        
        guard isEmpty(object) else { return object! }
        
        return ""
    }
}
