//
//  CustomizedUINavigationController.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
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
#import <objc/runtime.h>
#import "GraphicsLayout.h"
#import "UIButton+PSUIKit.h"
#import "UIThemeBase.h"
#import "PSUIKit.h"

@interface UINavigationController (org_apache_PSUIKit_PSUINavigationController)
@property (nonatomic, strong) UIThemeBase *theme;
@end

@interface PSUINavigationController : UINavigationController
@end