//
//  UIGridView.h
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

#import <QuartzCore/QuartzCore.h>
#import "GraphicsLayout.h"
#import "UIGridViewCell.h"

@protocol UIGridViewDataSource;
@protocol UIGridViewDelegate;

enum {
    UIGridViewItemAlignVertical = 0,
    UIGridViewItemAlignHorizontal = 1
};
typedef int UIGridViewItemAlign;

@interface UIGridView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet id<UIGridViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<UIGridViewDelegate, UIScrollViewDelegate> delegate;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic) UIGridViewItemAlign itemAlign;
@property (nonatomic) int columnCount;
@property (nonatomic) int rowCount;
@property (nonatomic) CGPadding padding;
- (UIGridViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)initProperties;
- (void)reloadData;
- (void)removeSelectionWithIndexPathWillBeSelect:(NSIndexPath *)indexPath;
@end

@protocol UIGridViewDataSource <NSObject>
@required
- (NSInteger)sectionCountInGridView:(UIGridView *)gridView;

@required
- (NSInteger)gridView:(UIGridView *)gridView itemCountInSection:(NSInteger)section;

@required
- (UIGridViewCell *)gridView:(UIGridView *)gridView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UIView *)gridView:(UIGridView *)gridView headerViewInSection:(NSInteger)section;

@optional
- (UIView *)gridView:(UIGridView *)gridView footerViewInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(UIGridView *)gridView headerHeightInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(UIGridView *)gridView headerWidthInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(UIGridView *)gridView footerHeightInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(UIGridView *)gridView footerWidthInSection:(NSInteger)section;
@end

@protocol UIGridViewDelegate <NSObject>
@optional
- (void)gridView:(UIGridView *)gridView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)gridView:(UIGridView *)gridView willDisplayCell:(UIGridViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)gridView:(UIGridView *)gridView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;

@optional
- (void)gridView:(UIGridView *)gridView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
@end
