//
//  SimpleBridgeWebViewController.h
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

#import <mach/mach.h>
#import <mach/mach_host.h>
#import <UIKit/UIKit.h>
#import <w3action/w3action.h>
#import <PSUIKit/PSUIKit.h>
#import "BridgeExternalInterfaceDelegate.h"
#import "BridgeNotification.h"
#import "CDVCommandDelegate.h"
#import "CDVInvokedUrlCommand.h"
#import "CDVPlugin.h"
#import "CDVPluginResult.h"
#import "NSDictionary+Extensions.h"
#import "UIDevice-Capabilities.h"
#import "UIDevice-Hardware.h"

#define webViewDidFailLoadWithErrorNotification @"webViewDidFailLoadWithErrorNotification"
#define webViewDidFinishLoadNotification @"webViewDidFinishLoadNotification"
#define webViewDidStartLoadNotification @"webViewDidStartLoadNotification"

@interface UIWebView (WebUI)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
- (BOOL)webView:(id)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
@end

@interface SimpleBridgeWebViewController : UIViewController <UIWebViewDelegate, BridgeExternalInterfaceDelegate, CDVCommandDelegate, BridgeNotificationDelegate>
@property (nonatomic, readonly) BOOL isFirstLoad;
@property (nonatomic) BOOL noreachable;
@property (nonatomic) BOOL reloadable;
@property (nonatomic) BOOL viewPushed;
@property (nonatomic, readonly) BOOL receiveShouldStartLoading;
@property (nonatomic, readonly, strong) NSMutableDictionary* pluginObjects;
@property (nonatomic, readonly, strong) NSDictionary* pluginsMap;
@property (nonatomic, readonly, strong) NSDictionary* settings;
@property (nonatomic, readonly, copy)   NSString* sessionKey;
@property (nonatomic, readwrite, strong) id<CDVCommandDelegate> commandDelegate;
@property (nonatomic, readonly, strong) UIScrollView *scrollViewOnWebView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *destination;
@property (nonatomic) BOOL scrollEnabled;
- (BOOL)canReceiveNotificationSelfOnly:(NSString *)name;
- (void)clear;
- (NSString *)executeJSFunc:(NSString *)functionName withObject:(NSDictionary *)object;
- (NSDictionary *)executeExternalInterfaceWithName:(NSString *)name withOptions:(NSDictionary *)options;
- (int)executeQueuedCommands;
- (void)flushCommandQueue;
- (void)load;
@end
