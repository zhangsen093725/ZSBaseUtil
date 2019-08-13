//
//  ZSNoticeManager.h
//  JadeKing
//
//  Created by 张森 on 2018/8/4.
//  Copyright © 2018年 张森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSNoticeToolDelegate <NSObject>

@optional
- (void)enterBackground;
- (void)enterForeground;
- (void)keyboardWillShowFrame:(CGRect)keyboardFrame;
- (void)keyboardWillHide;

@end

@interface ZSNoticeTool : NSObject
@property (nonatomic, weak) id<ZSNoticeToolDelegate> delegate;  // delegate

- (void)addObservers;
- (void)addKeyboardObserver;
- (void)addEnterBackForeObserver;
//- (void)addTakeScreenshot;

- (void)stopObservers;
- (void)stopKeyboardObserver;
- (void)stopEnterBackForeObserver;
@end
