//
//  UIAlertView+PSUIKit.h
//  PSUIKit
//
//  Created by kofktu on 2014. 8. 24..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
//

/*
 Copyright 2013 ~ 2014 KH Kim
 
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

#import <UIKit/UIKit.h>

@interface UIAlertView (PSUIKit)
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel))completion;
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel))completion;
@end
