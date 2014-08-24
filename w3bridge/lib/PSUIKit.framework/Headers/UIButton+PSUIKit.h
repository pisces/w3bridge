//
//  UIButton+PSUIKit.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 ~ 2014 KH Kim
 
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
#import "UIView+PSUIKit.h"
#import "UIViewController+PSUIKit.h"

@interface UIButton (org_apache_PSUIKit_UIButton)
@property (nonatomic, readonly, strong) NSMutableDictionary *resourceDictionary;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state forViewMetrics:(UIViewMatrics)viewMetrics;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state forViewMetrics:(UIViewMatrics)viewMetrics;
- (void)updateView;
- (void)updateView:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateBackgroundImage;
- (void)updateBackgroundImage:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateTitleColor;
- (void)updateTitleColor:(UIInterfaceOrientation)interfaceOrientation;
@end
