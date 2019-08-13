//
//  ZSNoticeManager.m
//  JadeKing
//
//  Created by 张森 on 2018/8/4.
//  Copyright © 2018年 张森. All rights reserved.
//

#import "ZSNoticeManager.h"

@implementation ZSNoticeTool

// Mark - add
- (void)addObservers{
    NSDictionary *dict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
                           [NSValue valueWithPointer:@selector(enterBackground)],        UIApplicationDidEnterBackgroundNotification,
                           [NSValue valueWithPointer:@selector(enterForeground)],        UIApplicationWillEnterForegroundNotification,
                           [NSValue valueWithPointer:@selector(keyboardWillShow:)],      UIKeyboardWillShowNotification,
                           [NSValue valueWithPointer:@selector(keyboardWillHide:)],      UIKeyboardWillHideNotification,
                           nil] copy];
//    SEL_VALUE(userDidTakeScreenshot:), UIApplicationUserDidTakeScreenshotNotification
    
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        SEL aSel = [value pointerValue];
        [dc addObserver:self
               selector:aSel
                   name:key
                 object:nil];
    }];
}

- (void)addKeyboardObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addEnterBackForeObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

//- (void)addTakeScreenshot{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
//}

// Mark - stop
- (void)stopObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopKeyboardObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopEnterBackForeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// Mark - notication
- (void)enterBackground{
    if ([self.delegate respondsToSelector:@selector(enterBackground)]) {
        [self.delegate enterBackground];
    }
}

- (void)enterForeground{
    if ([self.delegate respondsToSelector:@selector(enterForeground)]) {
        [self.delegate enterForeground];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    if ([self.delegate respondsToSelector:@selector(keyboardWillShowFrame:)]) {
        [self.delegate keyboardWillShowFrame:[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    if ([self.delegate respondsToSelector:@selector(keyboardWillHide)]) {
        [self.delegate keyboardWillHide];
    }
}

//- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
//
//}

//- (void)userDidTakeScreenshot:(NSNotification *)notification{
//
//    UIImage *bgImage = [self imageWithScreenshot];
//    UIImage *waterIma = nil; //[UIImage imgLogoGrayscaleSquare];
//
//    //创建一个位图上下文
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bgImage.size.width, bgImage.size.height + waterIma.size.height), NO, 0.0);
//
//    //将背景图片画入位图中
//    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
//
//    //将水印Logo画入背景图中
//    [waterIma drawInRect:CGRectMake((bgImage.size.width - waterIma.size.width) * 0.5, bgImage.size.height, waterIma.size.width, waterIma.size.height)];
//
//    //取得位图上下文中创建的新的图片
//    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
//
//    //结束上下文
//    UIGraphicsEndImageContext();
//
//    UIImageWriteToSavedPhotosAlbum(newimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//
////    //压缩新照片为PNG格式的二进制数据
////    NSData *data = UIImagePNGRepresentation(newimage);
////
////    //将图片写入到手机存储中
////    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"new.png"];
////    [data writeToFile:path atomically:YES];
//}


//- (NSData *)dataWithScreenshotInPNGFormat{
//    CGSize imageSize = CGSizeZero;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIInterfaceOrientationIsPortrait(orientation))
//        imageSize = KSBOUNDS.size;
//    else
//        imageSize = CGSizeMake(KSHEIGHT, KSWIDTH);
//
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, window.center.x, window.center.y);
//        CGContextConcatCTM(context, window.transform);
//        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//        if (orientation == UIInterfaceOrientationLandscapeLeft){
//            CGContextRotateCTM(context, M_PI_2);
//            CGContextTranslateCTM(context, 0, -imageSize.width);
//        }else if (orientation == UIInterfaceOrientationLandscapeRight){
//            CGContextRotateCTM(context, -M_PI_2);
//            CGContextTranslateCTM(context, -imageSize.height, 0);
//        }else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
//            CGContextRotateCTM(context, M_PI);
//            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
//        }
//        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
//            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//        }else{
//            [window.layer renderInContext:context];
//        }
//        CGContextRestoreGState(context);
//    }
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return UIImagePNGRepresentation(image);
//}
//
///**
// *  返回截取到的图片
// *
// *  @return UIImage *
// */
//- (UIImage *)imageWithScreenshot{
//    NSData *imageData = [self dataWithScreenshotInPNGFormat];
//    return [UIImage imageWithData:imageData];
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
