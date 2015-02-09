//
//  SimpleBridgeWebViewController.h
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Modified by KH Kim on 2015. 2. 9..
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

#import <mach/mach.h>
#import <mach/mach_host.h>
#import <w3action/w3action.h>
#import <PSUIKit/PSUIKit.h>
#import "BridgeExternalInterfaceDelegate.h"
#import "BridgeNotification.h"
#import "CDVCommandDelegate.h"
#import "CDVInvokedUrlCommand.h"
#import "CDVPlugin.h"
#import "CDVPluginResult.h"
#import "NSDictionary+Extensions.h"
#import "UIDevice-Hardware.h"

extern NSString *const webViewDidFailLoadWithErrorNotification;
extern NSString *const webViewDidFinishLoadNotification;
extern NSString *const webViewDidStartLoadNotification;

@interface SimpleBridgeWebViewController : PSViewController <BridgeExternalInterfaceDelegate, BridgeNotificationDelegate, CDVCommandDelegate, PSExceptionViewControllerDelegate, UIWebViewDelegate>
@property (nonatomic, readonly) BOOL isFirstLoad;
@property (nonatomic) BOOL reloadable;
@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) BOOL viewPushed;
@property (nonatomic, readonly) BOOL receiveShouldStartLoading;
@property (nonatomic, readonly, copy)   NSString* sessionKey;
@property (nonatomic, readonly) NSMutableDictionary* pluginObjects;
@property (nonatomic, readonly) NSDictionary* pluginsMap;
@property (nonatomic, readonly) NSDictionary* settings;
@property (nonatomic, strong) NSURL *destination;
@property (nonatomic, readonly) UIScrollView *scrollViewOnWebView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, readwrite, weak) id<CDVCommandDelegate> commandDelegate;
@property (nonatomic, readonly) PSExceptionViewController *exceptionViewController;
- (BOOL)canReceiveNotificationSelfOnly:(NSString *)name;
- (void)clear;
- (NSString *)executeJSFunc:(NSString *)functionName withObject:(NSDictionary *)object;
- (NSDictionary *)executeExternalInterfaceWithName:(NSString *)name withOptions:(NSDictionary *)options;
- (NSInteger)executeQueuedCommands;
- (void)flushCommandQueue;
- (void)load;
@end

@interface UIWebView (org_apache_w3bridge_UIWebView)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
- (BOOL)webView:(id)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
@end
