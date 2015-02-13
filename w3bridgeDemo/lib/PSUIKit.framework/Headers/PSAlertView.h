//
//  PSAlertView.h
//  PSUIKit
//
//  Created by KH Kim on 2015. 2. 6..
//  Copyright (c) 2015년 KH Kim. All rights reserved.
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

#import <CommonCrypto/CommonDigest.h>
#import "PSAttributedDivisionLabel.h"
#import "GraphicsLayout.h"
#import "base.h"
#import "PSButtonBar.h"
#import "PSLinedBackgroundView.h"

@class PSAlertView;
@protocol PSAlertViewDelegate;

typedef void (^PSAlertViewDismission)(PSAlertView *alertView, NSInteger buttonIndex, BOOL cancel);

@interface PSAlertView : PSView <PSButtonBarDelegate>
@property (nonatomic) CGFloat buttonHeight;
@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGPadding contentPadding;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, readonly) CGFloat contentViewHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, readonly) PSAttributedDivisionLabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, strong) id<PSAlertViewDelegate> delegate;
+ (PSAlertView *)alertViewWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
+ (PSAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
+ (void)dismissAll;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;
- (void)showWithDismission:(PSAlertViewDismission)dismission;
@end

@protocol PSAlertViewDelegate <NSObject>
@optional
- (void)PSAlertView:(PSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)PSAlertViewCancel:(PSAlertView *)alertView;
- (void)willPresentPSAlertView:(PSAlertView *)alertView;
- (void)didPresentPSAlertView:(PSAlertView *)alertView;
- (void)PSAlertView:(PSAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)PSAlertView:(PSAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (BOOL)PSAlertViewShouldEnableFirstOtherButton:(PSAlertView *)alertView;
@end

@interface NSString (MD5)
- (NSString*)MD5;
@end