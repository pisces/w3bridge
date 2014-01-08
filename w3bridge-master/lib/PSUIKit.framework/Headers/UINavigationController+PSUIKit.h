//
//  UINavigationController+PSUIKit.h
//  PSUIKit
//
//  Created by KH Kim on 2014. 1. 8..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (org_apache_PSUIKit_UINavigationController)
@property (nonatomic, readonly) UIViewController *previousViewController;
@property (nonatomic, readonly) NSString *previousTitle;
- (void)customize;
- (void)customize:(UIInterfaceOrientation)toInterfaceOrientation;
@end
