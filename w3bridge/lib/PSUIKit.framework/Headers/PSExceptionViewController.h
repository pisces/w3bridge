//
//  PSExceptionViewController.m
//  PSUIKit
//
//  Created by KH Kim on 2015. 2. 6..
//  Copyright (c) 2015년 hh963103@gmail.com. All rights reserved.
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

#import "base.h"

@protocol PSExceptionViewControllerDelegate;

@interface PSExceptionViewController : PSViewController
{
@protected
    __weak IBOutlet UIButton *actionButton;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIImageView *imageView;
}
@property (nonatomic) CGPadding padding;
@property (nonatomic, strong) NSString *buttonTitleText;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<PSExceptionViewControllerDelegate> delegate;
- (id)initWithSuperview:(UIView *)superview;
- (id)initWithSuperview:(UIView *)superview offset:(CGPoint)offset;
- (BOOL)checkVisibility;
@end

@protocol PSExceptionViewControllerDelegate <NSObject>

@required
- (BOOL)exceptionViewShouldShowWithController:(PSExceptionViewController *)controller;

@optional
- (void)controller:(PSExceptionViewController *)controller buttonClicked:(id)sender;

@end