//
//  UIBridgeViewController.h
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 KH Kim
 
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
#import <PSUIKit/PSUIRefreshViewController.h>
#import "SimpleBridgeWebViewController.h"
#import "UILayerBridgeWebViewController.h"

#define textViewBlurNotification @"textViewBlur"
#define textViewFocusNotification @"textViewFocus"
#define viewDidAppearNotification @"viewDidAppear"
#define viewDidDisappearNotification @"viewWillAppear"
#define viewWillAppearNotification @"viewWillAppear"
#define viewWillDisappearNotification @"viewWillDisappear"
#define shouldAutorotateNotification @"shouldAutorotate"

@interface UIBridgeWebViewController : SimpleBridgeWebViewController <UIScrollViewDelegate>
@property (nonatomic) BOOL hidesBottomBarWhenPushed;
@property (nonatomic) int interfaceOrientationState;
@property (nonatomic) BOOL showModalWhenFirstLoading;
@property (nonatomic, readonly, retain) UIView *textEditor;
@property (nonatomic) BOOL refreshEnabled;
@property (nonatomic) BOOL useRefreshDisplay;
@property (nonatomic) BOOL useDocumentTitle;
@property (nonatomic) CGFloat progressInterval;
- (void)openLayerBridgeWebViewWithURL:(NSString *)url layerOption:(LayerOption)layerOption;
@end
