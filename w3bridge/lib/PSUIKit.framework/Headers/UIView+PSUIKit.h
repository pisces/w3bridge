//
//  UIView+PSUIKit.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

enum {
	UIViewMatricsNormal,
	UIViewMatricsLanscape
};
typedef Byte UIViewMatrics;

@interface UIView (org_apache_PSUIKit_UIView)
@property (nonatomic) BOOL bubble;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, readonly) UIImage *image;
+ (instancetype)nibBasedInstance;
+ (instancetype)nibBasedInstanceWithBundle:(NSBundle *)bundle;
- (id)initWithColor:(UIColor *)color withFrame:(CGRect)frame;
- (void)drawGradientRect:(CGFloat[])colors;
- (void)removeAllSubviews;
- (void)setX:(CGFloat)x y:(CGFloat)y;
- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width;
- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)showGuideLines;
@end