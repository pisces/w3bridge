//
//  w3bridge.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

#import "w3bridge.h"

@implementation w3bridge

// ================================================================================================
//  Public
// ================================================================================================

+ (NSBundle *)bundle
{
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"w3bridge-Bundle" ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}
@end
