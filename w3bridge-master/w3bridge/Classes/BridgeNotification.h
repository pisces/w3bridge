//
//  NotificationBridge.h
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

#import "CDVPlugin.h"
#import "BridgeNotificationDelegate.h"
#import "SimpleBridgeWebViewController.h"

@interface BridgeNotification : CDVPlugin
@property (nonatomic, readonly, retain) NSArray *currentArguments;
@property (nonatomic, readonly, retain) NSMutableDictionary *currentOptions;

- (void)addObserver:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)postNotification:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)removeObserver:(NSArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)clear;
@end
