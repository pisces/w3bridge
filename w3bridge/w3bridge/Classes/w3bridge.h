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

/*
 *  Application Versioning Preprocessor Macros
 */
#define APPLICATION_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]
#define APPLICATION_VERSION_EQUAL_TO(v)                  ([[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] compare:v options:NSNumericSearch] == NSOrderedSame)
#define APPLICATION_VERSION_GREATER_THAN(v)              ([[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define APPLICATION_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define APPLICATION_VERSION_LESS_THAN(v)                 ([[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define APPLICATION_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE (([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) || ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"]))
#define IS_IPOD   ([[[UIDevice currentDevice]model] isEqualToString:@"iPod touch"])
#define IS_IPHONE_5 ((IS_IPHONE || IS_IPOD) && IS_WIDESCREEN)

@interface w3bridge : NSObject
+ (NSBundle *)bundle;
@end
