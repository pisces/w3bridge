//
//  BridgeExternalInterface.m
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

#import "BridgeExternalInterface.h"

@implementation BridgeExternalInterface

// ================================================================================================
//  Overridden: CDVPlugin
// ================================================================================================

// ================================================================================================
//  Public
// ================================================================================================

- (void)addCallback:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    NSString *name = [arguments objectAtIndex:1];
    id<BridgeExternalInterfaceDelegate> delegate = (id<BridgeExternalInterfaceDelegate>) self.viewController;
    [delegate addCallbackId:callbackId withName:name];
}

- (void)call:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    id<BridgeExternalInterfaceDelegate> delegate = (id<BridgeExternalInterfaceDelegate>) self.viewController;
    NSString *name = [arguments objectAtIndex:1];
    NSDictionary *result = [delegate executeExternalInterfaceWithName:name withOptions:options];
    NSString *callbackId = [arguments objectAtIndex:0];
    if (callbackId && ![callbackId isEqualToString:@"INVALID"])
        [self success:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result] callbackId:callbackId];
}
@end