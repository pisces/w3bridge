//
//  PSNavigationController.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
//  Modified by KH Kim on 2015. 2. 6..
//  Copyright (c) 2013 KH Kim. All rights reserved.
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

#import "base.h"
#import <objc/runtime.h>
#import "GraphicsLayout.h"
#import "UIButton+PSUIKit.h"
#import "UIThemeBase.h"

@interface UINavigationController (org_apache_PSUIKit_PSUINavigationController)
@property (nonatomic, strong) id<UIThemeProtocol> theme;
@end

@interface UINavigationBar (org_apache_PSUIKit_UINavigationBar)
@property (nonatomic, readonly) UIView *backgroundView;
@end

@interface PSNavigationController : UINavigationController
@end