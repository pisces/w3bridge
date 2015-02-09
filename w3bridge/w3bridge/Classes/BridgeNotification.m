//
//  NotificationBridge.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
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

#import "BridgeNotification.h"

@implementation BridgeNotification

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver:(NSArray *)arguments withDict:(NSMutableDictionary*)options
{
    [self clear];
    
    self.currentArguments = arguments;
    self.currentOptions = options;
    
    id<BridgeNotificationDelegate> bridgeController = (id<BridgeNotificationDelegate>) self.viewController;
    [bridgeController addNotification:self];
}

- (void)postNotification:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    [self clear];
    
    self.currentArguments = arguments;
    self.currentOptions = options;
    
    NSString *name = [[self.currentArguments objectAtIndex:1] JSStringValue];
    id object = [((SimpleBridgeWebViewController *) self.viewController) canReceiveNotificationSelfOnly:name] ? self.viewController : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:options];
}

- (void)removeObserver:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    [self clear];
    
    self.currentArguments = arguments;
    self.currentOptions = options;
    
    id<BridgeNotificationDelegate> bridgeController = (id<BridgeNotificationDelegate>) self.viewController;
    [bridgeController removeNotification:self];
}

// ================================================================================================
//  Internal
// ================================================================================================

- (void)clear
{
    self.currentArguments = nil;
    self.currentOptions = nil;
}
@end