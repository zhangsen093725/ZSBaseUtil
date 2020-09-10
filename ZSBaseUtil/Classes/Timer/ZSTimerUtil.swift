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
    
    private override init() {
        super.init()
    }
    
    /// 初始化CADisplayLink
    /// - Parameters:
    ///   - fps: 刷新频率，表示一秒钟刷新多少次，默认是60次
    ///   - block: 回调
    public convenience init(fps: Int = 60,
                            block: @escaping (_ displayLink: CADisplayLink) -> Void) {
        
        self.init()
        
        userInfo = block
        
        displayLink = CADisplayLink(target: self, selector: #selector(runDisplayLink(_:)))
        
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = fps
        } else {
            displayLink?.frameInterval = fps
        }
        displayLink?.add(to: RunLoop.current, forMode: .default)
    }
    
    @objc private func runDisplayLink(_ displayLink: CADisplayLink) -> Void {
        
        guard userInfo != nil else { return }
        userInfo!(displayLink)
    }
    
    public func invalidate() {
        displayLink?.remove(from: RunLoop.current, forMode: .default)
        displayLink?.invalidate()
        displayLink = nil
        userInfo = nil
    }
}




@objc public class ZSTimer: NSObject {
    
    var timerQueue: DispatchQueue?
    
    var timer: DispatchSourceTimer?
    
    public convenience init(interval: TimeInterval,
                            repeats: Bool = true,
                            block: @escaping () -> Void) {
        self.init()
        
        timerQueue = DispatchQueue(label: "com.ZSTimer.zhangsen", qos: .userInitiated)
        
        let repeating: DispatchTimeInterval = repeats ? .nanoseconds(Int(interval * pow(10, 9))) : .never
        
        self.timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timer?.schedule(deadline: .now() + interval, repeating: repeating)
        timer?.setEventHandler(handler: block)
    }
    
    private override init() {
        super.init()
    }
    
    public func resume() {
        timer?.resume()
    }
    
    public func invalidate() {
        timer?.cancel()
        timer = nil
    }
}
