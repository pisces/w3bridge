//
//  PSButtonBar.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
//  Modified by KH Kim on 2015. 2. 6..
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

#import "PSView.h"
#import "GraphicsLayout.h"
#import "UIView+PSUIKit.h"

enum {
    UIButtonBarAlignmentHorizontal = 1<<0,
    UIButtonBarAlignmentVertical = 1<<1
};
typedef Byte UIButtonBarAlignment;

@protocol UIButtonBarDelegate;

@interface PSButtonBar : PSView
@property (nonatomic) BOOL toggle;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger numOfButtons;
@property (nonatomic, readonly) NSInteger rowCount;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, readonly) CGFloat buttonWidth;
@property (nonatomic, readonly) CGFloat buttonHeight;
@property (nonatomic) CGFloat horizontalGap;
@property (nonatomic) CGFloat verticalGap;
@property (nonatomic) UIButtonType buttonType;
@property (nonatomic) CGPadding padding;
@property (nonatomic) CGPadding seperatorPadding;
@property (nonatomic) UIButtonBarAlignment alignment;
@property (nonatomic, readonly) NSMutableArray *buttons;
@property (nonatomic, readonly) UIButton *selectedChild;
@property (nonatomic, strong) UIColor *seperatorColor;
@property (nonatomic, weak) IBOutlet id<UIButtonBarDelegate> delegate;
- (NSUInteger)buttonIndex:(UIButton *)button;
- (void)deselect;
@end

@protocol UIButtonBarDelegate <NSObject>
- (void)buttonBar:(PSButtonBar*)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
@optional
- (void)buttonBar:(PSButtonBar*)buttonBar buttonClicked:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
- (void)buttonBar:(PSButtonBar*)buttonBar buttonResized:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
- (void)buttonBar:(PSButtonBar*)buttonBar buttonSelected:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
@end

@interface UIButtonBarDelegateObject : NSObject <UIButtonBarDelegate>
typedef void (^UIButtonBarDelegateBlock)(UIButton *button, NSUInteger buttonIndex);
- (id)initWithRender:(UIButtonBarDelegateBlock)render clicked:(UIButtonBarDelegateBlock)clicked resized:(UIButtonBarDelegateBlock)resized selected:(UIButtonBarDelegateBlock)selected;
- (void)clear;
- (void)render:(UIButtonBarDelegateBlock)render clicked:(UIButtonBarDelegateBlock)clicked resized:(UIButtonBarDelegateBlock)resized selected:(UIButtonBarDelegateBlock)selected;
@end

@interface UIButtonBarSeperatorView : PSView
@property (nonatomic) NSUInteger columnCount;
@property (nonatomic) NSUInteger rowCount;
@property (nonatomic) CGPadding padding;
@property (nonatomic, strong) UIColor *lineColor;
@end