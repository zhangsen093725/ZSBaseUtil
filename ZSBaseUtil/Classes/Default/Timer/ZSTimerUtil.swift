//
//  ZSTimerUtil.swift
//  Pods-ZSBaseUtil_Example
//
//  Created by 张森 on 2019/12/31.
//

import Foundation

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



@objc public class ZSDisplayLink: NSObject {
    
    private var userInfo: ((_ displayLink: CADisplayLink) -> Void)?
    private var displayLink: CADisplayLink?
    
    /// 初始化CADisplayLink
    /// - Parameters:
    ///   - fps: 刷新频率，必须是60的约数
    ///   - block: 回调
    class func zs_displayLink(_ fps: Int,
                              block: @escaping (_ displayLink: CADisplayLink) -> Void) -> ZSDisplayLink {
        
        let weak_displayLink = ZSDisplayLink()
        weak_displayLink.userInfo = block
        
        weak_displayLink.displayLink = CADisplayLink(target: weak_displayLink, selector: #selector(runDisplayLink(_:)))
        
        guard fps > 0 else { return weak_displayLink }
        
        if #available(iOS 10.0, *) {
            weak_displayLink.displayLink?.preferredFramesPerSecond = Int(60 / fps)
        } else {
            weak_displayLink.displayLink?.frameInterval = Int(60 / fps)
        }
        weak_displayLink.displayLink?.add(to: RunLoop.current, forMode: .default)
        
        return weak_displayLink
    }
    
    @objc private func runDisplayLink(_ displayLink: CADisplayLink) -> Void {
        
        guard userInfo != nil else { return }
        userInfo!(displayLink)
    }
    
    func invalidate() {
        displayLink?.remove(from: RunLoop.current, forMode: .default)
        displayLink?.invalidate()
        displayLink = nil
        userInfo = nil
    }
}




@objc public class ZSTimer: NSObject {
    
    var timerQueue: DispatchQueue?
    
    var timer: DispatchSourceTimer?
    
    convenience init(interval: TimeInterval,
                     repeats: Bool = true,
                     block: @escaping () -> Void) {
        self.init()
        
        self.timerQueue = DispatchQueue(label: "com.ZSTimer.zhangsen", qos: .userInitiated)
        
        let repeating: DispatchTimeInterval = repeats ? .nanoseconds(Int(interval * pow(10, 9))) : .never
        
        self.timer = DispatchSource.makeTimerSource(queue: self.timerQueue)
        timer?.schedule(deadline: .now() + interval, repeating: repeating)
        timer?.setEventHandler(handler: block)
    }
    
    override init() {
        super.init()
    }
    
    func resume() {
        timer?.resume()
    }
    
    func invalidate() {
        timer?.cancel()
        timer = nil
    }
}
