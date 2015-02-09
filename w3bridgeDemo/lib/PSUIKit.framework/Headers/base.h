//
//  base.h
//  PSUIKit
//
//  Created by KH Kim on 2014. 8. 25..
//  Modified by KH Kim on 2015. 2. 6..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
//

#ifndef PSUIKit_base_h
#define PSUIKit_base_h

#import "ext.h"
#import "GraphicsLayout.h"
#import "PSNavigationController.h"
#import "PSTableViewCell.h"
#import "PSTableViewController.h"
#import "PSView.h"
#import "PSViewController.h"

#define animationOptions SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 7 << 16 : 0

#define UIViewAutoresizingFlexibleAll UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

/*
 *  Application Versioning Preprocessor Macros
 */
#define APPLICATION_BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*) kCFBundleVersionKey]
#define APPLICATION_VERSION VALIDATE_VERSION(APPLICATION_BUNDLE_VERSION)
#define APPLICATION_VERSION_EQUAL_TO(v)                  ([APPLICATION_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
#define APPLICATION_VERSION_GREATER_THAN(v)              ([APPLICATION_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define APPLICATION_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([APPLICATION_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define APPLICATION_VERSION_LESS_THAN(v)                 ([APPLICATION_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define APPLICATION_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([APPLICATION_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)
#define VALIDATE_VERSION(v) [v substringWithRange:((NSTextCheckingResult *) [[NSRegularExpression regularExpressionWithPattern:@"[0-9].[0-9].[0-9]" options:NSRegularExpressionCaseInsensitive error:NULL] matchesInString:v options:NSMatchingReportProgress range:(NSRange) {0, ((NSString *) v).length}][0]).range]

/*
 *  Application URLSchemes Preprocessor Macros
 */
#define APPLICATION_URL_TYPES [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"]

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION                              [[UIDevice currentDevice] systemVersion]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

#define isValidScreenHeight(h) (fabs((double) [UIScreen mainScreen].bounds.size.height - h) < DBL_EPSILON)
#define IS_WIDESCREEN isValidScreenHeight(568)
#define IS_IPHONE (([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) || ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"]))
#define IS_IPOD   ([[[UIDevice currentDevice]model] isEqualToString:@"iPod touch"])
#define IS_IPHONE_5 ((IS_IPHONE || IS_IPOD) && IS_WIDESCREEN)
#define IS_IPHONE_6PLUS ((IS_IPHONE || IS_IPOD) && isValidScreenHeight(736))
#define IS_RETINA [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0

#endif
