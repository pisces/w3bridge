//
//  BridgeWeb.h
//  w3bridge
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
#import "CDVPlugin.h"
#import "UIBridgeWebViewController.h"

#define bridgeViewFrameSizeChangedNotification @"bridgeViewFrameSizeChangedNotification"

@interface BridgeView : CDVPlugin
- (void)close:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)hideActivityIndicatorView:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)openBrowser:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)openLayerBridgeWebView:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)popWithURL:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)popToRootView:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)pushWithURL:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)setProperty:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)setRightBarButtonItem:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)setSize:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)setTitle:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)showActivityIndicatorView:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
@end

enum {
    BridgeViewTypePush,
    BridgeViewTypePop
};
typedef int BridgeViewType;

@interface BridgeViewOption : NSObject
+ (BridgeViewOption *)optionWithArguments:(NSArray *)arguments withViewController:(UIBridgeWebViewController *)viewController viewType:(BridgeViewType)viewType;
@property (nonatomic) BOOL closeEnabled;
@property (nonatomic) BOOL refreshEnabled;
@property (nonatomic) BOOL hidesBottomBarWhenPushed;
@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) int interfaceOrientationState;
@property (nonatomic) UIModalTransitionStyle modalTransitionStyle;
@property (nonatomic, strong) NSString *leftBarButtonItemText;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *destination;
@end