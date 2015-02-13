//
//  UITheme+Base.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 ~ 2015 KH Kim
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+PSUIKit.h"
#import "UIButton+PSUIKit.h"
#import "UINavigationController+PSUIKit.h"
#import "UIViewController+PSUIKit.h"

@protocol UIThemeProtocol <NSObject>
@required
- (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIImage *)navigationBarBackgroundImage:(UIInterfaceOrientation)interfaceOrientation;
- (UIColor *)navigationBarBarTintColor;
- (UIColor *)navigationBarTintColor;
- (NSDictionary *)navigationBarTitleTextAttributes;
- (BOOL)navigationBarTranslucent;
- (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)homeBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@optional
- (CGFloat)navigationBarBackgroundAlpha;
@end

@protocol UIThemeClient
@property (nonatomic, strong) id<UIThemeProtocol> theme;
@end

@interface UIApplication (UIThemeBase)
@property (nonatomic, strong) id<UIThemeProtocol> theme;
@end

@interface UIViewController (UIThemeBase)
- (void)navigationBack:(id)sender;
- (UIBarButtonItem *)setBackBarButtonItem;
- (UIBarButtonItem *)setBackBarButtonItemWithTheme:(id<UIThemeProtocol>)theme;
- (UIBarButtonItem *)setBackBarButtonItemWithTitle:(NSString *)title;
- (UIBarButtonItem *)setBackBarButtonItemWithTitle:(NSString *)title withTheme:(id<UIThemeProtocol>)theme;
@end

@interface ImageNameObject : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *hightedImageName;
+ (ImageNameObject *)objectWithImageName:(NSString *)imageName hightedImageName:(NSString *)hightedImageName;
@end

@protocol UIThemeBaseProtected
- (UIBarButtonItem *)barButtonItemWithObject:(ImageNameObject *)object target:(id)target action:(SEL)action;
@end

@interface UIThemeBase : NSObject <UIThemeProtocol, UIThemeBaseProtected>
- (UIButton *)navigationButton:(NSString *)title imageName:(NSString *)imageName imageNameForLandscape:(NSString *)imageNameForLandscape textColor:(UIColor *)textColor target:(id)target action:(SEL)action;
- (void)updateView:(UIButton *)button taget:(id)target;
@end