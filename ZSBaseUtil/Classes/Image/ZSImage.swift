//
//  ZSImage.swift
//  Pods-ZSBaseUtil_Example
//
//  Created by 张森 on 2019/11/15.
//

import UIKit

public extension UIImage {
    
    func zs_scaled(_ newSize: CGSize) -> UIImage {
        
        guard size != .zero else { return self }
        
        let clipW = size.width >= newSize.width ? newSize.width : size.width
        let clipH = size.height >= newSize.height ? newSize.height : size.height
        
        guard let sourceImageRef = cgImage else { return self }
        
        guard let newImageRef = sourceImageRef.cropping(to: CGRect(x: (size.width - clipW) * 0.5, y: (size.height - clipH) * 0.5, width: clipW, height: clipH)) else { return self }
        
        return UIImage(cgImage: newImageRef)
    }
    
    func zs_corner(radius: CGFloat) -> UIImage {
        
        let width = size.width * scale
        let height = size.height * scale
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    func zs_mask(image: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        draw(in: rect)
        image.draw(in: rect, blendMode: .destinationIn, alpha: 1)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    class func zs_image(color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func zs_screenShot(view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let complexViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return complexViewImage
    }
}
