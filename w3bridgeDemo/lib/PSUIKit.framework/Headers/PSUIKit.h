//
//  PSUIKit.h
//  PSUIKit
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActivityIndicatorManager.h"
#import "PopUpViewManager.h"
#import "PSUINavigationController.h"
#import "PSUIRefreshViewController.h"
#import "ReachabilityViewManager.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define PSUIKITBundleFilename @"PSUIKIT-Bundle.bundle"

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

@interface PSUIKit : NSObject
+ (NSBundle *)bundle;
+ (NSString *)imageName:(NSString *)name;
@end
