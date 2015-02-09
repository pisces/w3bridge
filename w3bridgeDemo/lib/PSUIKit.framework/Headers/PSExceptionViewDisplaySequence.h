//
//  PSExceptionViewDisplaySequence.m
//  GUIKit
//
//  Created by KH Kim on 2015. 2. 6..
//  Copyright (c) 2015년 hh963103@gmail.com. All rights reserved.
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

#import "PSExceptionViewController.h"

@interface PSExceptionViewDisplaySequence : NSObject
@property (nonatomic, weak) id<PSExceptionViewControllerDelegate> delegate;
- (void)addControllers:(NSArray *)controllers;
- (void)addController:(PSExceptionViewController *)controller;
- (BOOL)checkVisibility;
- (id)initWithDelegate:(id<PSExceptionViewControllerDelegate>)delegate;
- (NSInteger)indexOfController:(PSExceptionViewController *)controller;
- (void)removeController:(PSExceptionViewController *)controller;
- (void)removeAllController;
@end
