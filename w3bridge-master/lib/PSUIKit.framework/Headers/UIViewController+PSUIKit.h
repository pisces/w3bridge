//
//  UIViewController+PSUIKit.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 KH Kim
 
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

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIButton+PSUIKit.h"
#import "UINavigationItem+PSUIKit.h"

#define willCloseViewNotification @"willCloseViewNotification"

@interface UIViewController (com_pisces_lib_PSUIKit)
@property (nonatomic, retain) UIViewController *relativeController;
+ (UIViewController *)controllerWithViewName:(NSString *)viewName;
+ (UIViewController *)controllerWithViewName:(NSString *)viewName bundle:(NSBundle *)bundle;
+ (UIViewController *)controllerWithViewName:(NSString *)viewName suffix:(char *)suffix bundle:(NSBundle *)bundle;
- (void)close;
- (void)close:(id)sender;
- (void)closeAnimated:(BOOL)animated;
- (UIViewController *)topMostController;
- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
- (void)updateBarButtonItems:(UIInterfaceOrientation)interfaceOrientation;
@end
