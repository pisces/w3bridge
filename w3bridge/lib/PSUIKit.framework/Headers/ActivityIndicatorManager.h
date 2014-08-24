//
//  ActivityIndicatorManager.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(int, ActivityIndicatorLayoutStyle) {
    ActivityIndicatorLayoutStyleCenter,
    ActivityIndicatorLayoutStyleTop
};

@interface ActivityIndicatorManager : NSObject
+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle message:(NSString *)message offset:(CGPoint)offset modal:(BOOL)modal;
+ (void)activate:(UIView *)view message:(NSString *)message offset:(CGPoint)offset modal:(BOOL)modal;
+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle message:(NSString *)message modal:(BOOL)modal;
+ (void)activate:(UIView *)view message:(NSString *)message modal:(BOOL)modal;
+ (void)activate:(UIView *)view offset:(CGPoint)offset modal:(BOOL)modal;
+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle modal:(BOOL)modal;
+ (void)activate:(UIView *)view modal:(BOOL)modal;
+ (BOOL)contains:(UIView *)view;
+ (void)deactivate:(UIView *)view;
+ (void)initialize;
+ (UILabel *)label:(UIView *)view;
+ (UIActivityIndicatorView *)indicator:(UIView *)view;
+ (UIView *)modalView:(UIView *)view;
+ (void)layout:(UIView *)view;
+ (void)layout:(UIView *)view layoutStyle:(ActivityIndicatorLayoutStyle)layoutStyle;
+ (void)setMessage:(UIView *)view text:(NSString *)text;
+ (void)setMessage:(UIView *)view text:(NSString *)text layoutStyle:(ActivityIndicatorLayoutStyle)layoutStyle;
@end