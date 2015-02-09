//
//  w3bridge.h
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BridgeExternalInterface.h"
#import "BridgeNotificationDelegate.h"
#import "BridgeView.h"
#import "CDVInvokedUrlCommand.h"
#import "CDVPlugin.h"
#import "CDVPluginResult.h"
#import "CDVDebugConsole.h"
#import "SimpleBridgeWebViewController.h"
#import "UIBridgeWebViewController.h"
#import "UILayerBridgeWebViewController.h"

@interface w3bridge : NSObject
+ (NSBundle *)bundle;
+ (NSString *)localizedStringWithKey:(NSString *)key;
@end
