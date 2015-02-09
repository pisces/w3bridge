//
//  PSViewController.h
//  PSUIKit
//
//  Created by KH Kim on 2014. 8. 24..
//  Modified by KH Kim on 2015. 2. 6..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
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
#import "PSNavigationController.h"
#import "PSPreloader.h"
#import "Reachability.h"
#import "UIThemeBase.h"

@protocol PSViewControllerProtected <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setLeftBarButtonItem;
- (void)setLeftBarButtonItemWithText:(NSString *)text;
- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme;
- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme leftBarButtonItemText:(NSString *)text;
- (void)updateWithReachability:(Reachability *)aReachability;
@end

@interface PSViewController : UIViewController <PSViewControllerProtected>
@property (nonatomic, readonly) BOOL hasPresentedViewController;
@property (nonatomic) BOOL immediatelyUpdating;
@property (nonatomic, readonly) BOOL isFirstViewAppearence;
@property (nonatomic, readonly) BOOL isNotReachable;
@property (nonatomic, readonly) BOOL isNotReachableBefore;
@property (nonatomic, readonly) BOOL isViewAppeared;
@property (nonatomic, readonly) NSString *gaPageKey;
@property (nonatomic) id<UIThemeProtocol> navigationTheme;
- (void)invalidateProperties;
- (void)layoutSubviews;
- (void)validateProperties;
@end