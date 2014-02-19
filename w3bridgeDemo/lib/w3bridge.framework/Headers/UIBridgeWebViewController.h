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
#import <PSUIKit/UIThemeDefaultStyle.h>
#import "SimpleBridgeWebViewController.h"
#import "UILayerBridgeWebViewController.h"

#define didClickLeftBarButtonItemNotification @"didClickLeftBarButtonItem"
#define didClickRightBarButtonItemNotification @"didClickRightBarButtonItem"
#define shouldAutorotateNotification @"shouldAutorotate"
#define textViewBlurNotification @"textViewBlur"
#define textViewFocusNotification @"textViewFocus"
#define viewDidAppearNotification @"viewDidAppear"
#define viewDidDisappearNotification @"viewWillAppear"
#define viewWillAppearNotification @"viewWillAppear"
#define viewWillDisappearNotification @"viewWillDisappear"

@interface UIBridgeWebViewController : SimpleBridgeWebViewController <UIScrollViewDelegate>
@property (nonatomic) BOOL closeEnabled;
@property (nonatomic) BOOL hidesBottomBarWhenPushed;
@property (nonatomic) BOOL showModalWhenFirstLoading;
@property (nonatomic) BOOL refreshEnabled;
@property (nonatomic) BOOL useRefreshDisplay;
@property (nonatomic) BOOL useDocumentTitle;
@property (nonatomic) int interfaceOrientationState;
@property (nonatomic) CGFloat progressInterval;
@property (nonatomic) LeftBarButtonItemType leftBarButtonItemType;
@property (nonatomic, retain) NSString *leftBarButtonItemText;
- (void)openLayerBridgeWebViewWithURL:(NSString *)url layerOption:(LayerOption)layerOption;
- (void)setRightBarButtonItemWithText:(NSString *)text buttonClickCallBack:(NSString *)buttonClickCallBack;
@end
