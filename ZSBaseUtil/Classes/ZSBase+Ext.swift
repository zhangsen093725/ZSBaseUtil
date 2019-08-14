//
//  ZSView.swift
//  JadeKing
//
//  Created by 张森 on 2019/8/3.
//  Copyright © 2019 张森. All rights reserved.
//

import Foundation

// MARK: - Timer扩展 
@objc public extension Timer {
    
    class func zs_supportiOS_10EarlierTimer(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        
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



// MARK: - Dictionary扩展
extension Dictionary {
    
    public var zs_json: String? {
        get{
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
                return String.init(data: jsonData, encoding: .utf8)
            } catch {
                return nil
            }
        }
    }
}



// MARK: - NSObject扩展
@objc public extension NSObject {
    
    var zs_json: String? {
        get {

            if let string: String = self as? String {
                return string
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: [])
                return String(data: data, encoding: .utf8)
            } catch {
                return nil
            }
        }
    }
    
    class func zs_isEmpty(_ object: Any?) -> Bool {
        
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
    
    class func zs_paramsValue(_ object: Any?) -> Any {
        
        guard zs_isEmpty(object) else { return object! }
        
        return ""
    }
}


// MARK: - String扩展
public extension String {
    
    var zs_isInt: Bool {
        get {
            let scan = Scanner(string: self)
            var val: Int = 0
            return scan.scanInt(&val) && scan.isAtEnd
        }
    }
    
    var zs_isFloat: Bool {
        get {
            let scan = Scanner(string: self)
            var val: Float = 0
            return scan.scanFloat(&val) && scan.isAtEnd
        }
    }
    
    var zs_isNumber: Bool {
        get {
            return zs_isInt || zs_isFloat
        }
    }
    
    var zs_isValidUrl: Bool {
        get {
            let predcate: NSPredicate = NSPredicate(format: "SELF MATCHES%@", #"http[s]{0,1}://[^\s]*"#)
            return predcate.evaluate(with: self)
        }
    }
    
    var zs_url: NSURL? {
        get {
            return NSURL(string: self)
        }
    }
    
    func zs_size(font: UIFont, textMaxSize: CGSize) -> CGSize {
        return self.boundingRect(with: textMaxSize, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil).size
    }
    
    func zs_add(font: UIFont,
                textMaxSize: CGSize = CGSize.zero,
                attributes: Dictionary<NSAttributedString.Key, Any>? = nil,
                alignment: NSTextAlignment = .left,
                lineHeight: CGFloat = 0,
                headIndent: CGFloat = 0,
                tailIndent: CGFloat = 0,
                isAutoLineBreak: Bool = false) -> NSAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = zs_size(font: font, textMaxSize: textMaxSize).height > font.lineHeight ? lineHeight : 0
        
        if !isAutoLineBreak {
            paraStyle.lineBreakMode = .byTruncatingTail
        }
        
        paraStyle.alignment = alignment
        paraStyle.firstLineHeadIndent = headIndent
        paraStyle.headIndent = headIndent
        paraStyle.tailIndent = tailIndent
        
        var tempAttribute = attributes
        
        tempAttribute?[.font] = font
        tempAttribute?[.paragraphStyle] = paraStyle
        
        return NSAttributedString(string: self, attributes: tempAttribute)
    }
    
    static var deviceVersion: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let plat = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch plat {
            
        case "i386",
             "x86_64": return "iPhone Simulator"
            
        case "iPhone1,1":   return "iPhone 2G"
        case "iPhone1,2":   return "iPhone 3G"
        case "iPhone2,1":   return "iPhone 3GS"
            
        case "iPhone3,1",
             "iPhone3,2",
             "iPhone3,3":   return "iPhone 4"
            
        case "iPhone4,1":   return "iPhone 4S"
            
        case "iPhone5,1",
             "iPhone5,2":   return "iPhone 5"
            
        case "iPhone5,3",
             "iPhone5,4":   return "iPhone 5c"
            
        case "iPhone6,1",
             "iPhone6,2":   return "iPhone 5s"
            
        case "iPhone7,1",
             "iPhone7,2":   return "iPhone 6"
            
        case "iPhone8,1",
             "iPhone8,2":   return "iPhone 6s"
            
        case "iPhone8,3",
             "iPhone8,4":   return "iPhone SE"
            
        case "iPhone9,1",
             "iPhone9,3":   return "iPhone 7"
            
        case "iPhone9,2",
             "iPhone9,4":   return "iPhone 7Plus"
            
        case "iPhone10,1",
             "iPhone10,4":  return "iPhone 8"
            
        case "iPhone10,2",
             "iPhone10,5":  return "iPhone 8Plus"
            
        case "iPhone10,3",
             "iPhone10,6":  return "iPhone X"
            
        case "iPhone11,2":  return "iPhone XS"
        case "iPhone11,8":  return "iPhone XR"
            
        case "iPhone11,4",
             "iPhone11,6":  return "iPhone XS Max"
            
            
        case "iPod1,1":     return "iPodTouch"
        case "iPod2,1":     return "iPodTouch 2"
        case "iPod3,1":     return "iPodTouch 3"
        case "iPod4,1":     return "iPodTouch 4"
        case "iPod5,1":     return "iPodTouch 5"
        case "iPod7,1":     return "iPodTouch 6"
            
            
        case "iPad1,1":     return "iPad"
        case "iPad2,1":     return "iPad 2 (WiFi)"
        case "iPad2,2":     return "iPad 2 (GSM)"
        case "iPad2,3":     return "iPad 2 (CDMA)"
        case "iPad2,4":     return "iPad 2 (32nm)"
        case "iPad3,1":     return "iPad 3 (WiFi)"
        case "iPad3,2":     return "iPad 3 (CDMA)"
        case "iPad3,3":     return "iPad 3 (4G)"
        case "iPad3,4":     return "iPad 4 (WiFi)"
        case "iPad3,5":     return "iPad 4 (4G)"
        case "iPad3,6":     return "iPad 4 (CDMA)"
            
        case "iPad6,12",
             "iPad6,11":    return "iPad 9.7"
            
        case "iPad7,5",
             "iPad7,6":     return "iPad (2018) 9.7"
            
        case "iPad4,1",
             "iPad4,2",
             "iPad4,3":     return "iPad Air"
            
        case "iPad5,3",
             "iPad5,4":     return "iPad Air2"
            
        case "iPad2,5":     return "iPad mini (WiFi)"
        case "iPad2,6":     return "iPad mini (GSM)"
        case "iPad2,7":     return "iPad mini (CDMA)"
            
        case "iPad4,4",
             "iPad4,5",
             "iPad4,6":     return "iPad mini2"
            
        case "iPad4,7",
             "iPad4,8",
             "iPad4,9":     return "iPad mini3"
            
        case "iPad5,1",
             "iPad5,2":     return "iPad mini4"
            
        case "iPad6,3",
             "iPad6,4":     return "iPad Pro 9.7"
            
        case "iPad6,7",
             "iPad6,8":     return "iPad Pro 12.9"
            
        case "iPad7,1",
             "iPad7,2":     return "iPad Pro2 12.9"
            
        case "iPad7,3",
             "iPad7,4":     return "iPad Pro2 10.5"
            
        case "iPad8,1",
             "iPad8,2",
             "iPad8,3",
             "iPad8,4":     return "iPad Pro3 11"
            
        case "iPad8,5",
             "iPad8,6":     return "iPad Pro3 9.7"
            
        case "iPad8,7",
             "iPad8,8":     return "iPad Pro3 12.9"
            
        default: return plat
        }
    }
}


// MARK: - NSString扩展
@objc public extension NSString {
    
    var zs_isInt: Bool {
        get {
            return String(self).zs_isInt
        }
    }
    
    var zs_isFloat: Bool {
        get {
            return String(self).zs_isFloat
        }
    }
    
    var zs_isNumber: Bool {
        get {
            return String(self).zs_isNumber
        }
    }
    
    var zs_isValidUrl: Bool {
        get {
            return String(self).zs_isValidUrl
        }
    }
    
    var zs_url: NSURL? {
        get {
            return String(self).zs_url
        }
    }
    
    func zs_size(font: UIFont, textMaxSize: CGSize) -> CGSize {
        
        return String(self).zs_size(font: font, textMaxSize: textMaxSize)
    }
    
    func zs_add(font: UIFont,
                textMaxSize: CGSize = CGSize.zero,
                attributes: Dictionary<NSAttributedString.Key, Any>? = nil,
                alignment: NSTextAlignment = .left,
                lineHeight: CGFloat = 0,
                headIndent: CGFloat = 0,
                tailIndent: CGFloat = 0,
                isAutoLineBreak: Bool = false) -> NSAttributedString {
        
        return String(self).zs_add(font: font, textMaxSize: textMaxSize, attributes: attributes, alignment: alignment, lineHeight: lineHeight, headIndent: headIndent, tailIndent: tailIndent, isAutoLineBreak: isAutoLineBreak)
    }
    
    class var deviceVersion: String {
        return String.deviceVersion
    }
}



// MARK: - NSAttributedString扩展
@objc public extension NSAttributedString {
    
    class func imageAttribute(_ image: UIImage, textFont: UIFont, imageFont: UIFont? = nil) -> NSAttributedString {
        
        let attchment = NSTextAttachment()
        attchment.image = image
        
        let height = (imageFont == nil ? textFont.lineHeight : imageFont?.lineHeight) ?? 0
        let width = (image.size.width / image.size.height) * height
        let y = (imageFont == nil ? textFont.descender : (textFont.lineHeight - (imageFont?.lineHeight ?? 0)) * 0.5 + textFont.descender)
    
        attchment.bounds = CGRect(x: 0, y: y, width: width, height: height)
        
        return NSAttributedString(attachment: attchment)
    }
    
    func zs_add(font: UIFont,
                textMaxSize: CGSize = CGSize.zero,
                attributes: Dictionary<NSAttributedString.Key, Any>? = nil,
                alignment: NSTextAlignment = .left,
                lineHeight: CGFloat = 0,
                headIndent: CGFloat = 0,
                tailIndent: CGFloat = 0,
                isAutoLineBreak: Bool = false) -> NSAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = zs_size(textMaxSize: textMaxSize).height > font.lineHeight ? lineHeight : 0

        if !isAutoLineBreak {
            paraStyle.lineBreakMode = .byTruncatingTail
        }
        
        paraStyle.alignment = alignment
        paraStyle.firstLineHeadIndent = headIndent
        paraStyle.headIndent = headIndent
        paraStyle.tailIndent = tailIndent
        
        var tempAttribute = attributes
        
        tempAttribute?[.font] = font
        tempAttribute?[.paragraphStyle] = paraStyle
        
        let mutable: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        
        guard let attribute = tempAttribute else { return self }
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: self.string.count))
        
        return mutable.copy() as! NSAttributedString
    }
    
    func zs_size(textMaxSize: CGSize) -> CGSize {
        return self.boundingRect(with: textMaxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
    }

}

