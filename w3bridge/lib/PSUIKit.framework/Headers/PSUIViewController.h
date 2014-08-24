//
//  PSUIViewController.h
//  PSUIKit
//
//  Created by KH Kim on 2014. 8. 24..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
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
#import "Reachability.h"
#import "UIThemeBase.h"

@protocol PSUIViewControllerProtected <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme;
- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme leftBarButtonItemText:(NSString *)text;
- (void)updateWithReachability:(Reachability *)aReachability;
@end

@interface PSUIViewController : UIViewController <PSUIViewControllerProtected>
@property (nonatomic, readonly) BOOL hasPresentedViewController;
@property (nonatomic, readonly) BOOL isFirstViewAppearence;
@property (nonatomic, readonly) BOOL isNotReachable;
@property (nonatomic, readonly) BOOL isViewAppeared;
- (void)invalidateProperties;
- (void)layoutSubviews;
@end