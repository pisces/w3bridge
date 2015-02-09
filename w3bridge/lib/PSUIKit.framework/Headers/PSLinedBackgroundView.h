//
//  UILinedBackgroundView.h
//  PSUIKit
//
//  Created by KH Kim on 2013. 12. 31..
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

#import <UIKit/UIKit.h>
#import "GraphicsLayout.h"

enum {
    LineDrawPositionBottom = 1<<0,
    LineDrawPositionTop = 1<<1
};
typedef int LineDrawPosition;

@interface PSLinedBackgroundView : UIView
@property (nonatomic) LineDrawPosition lineDrawPosition;
@property (nonatomic, strong) NSArray *seperatorColors;
@property (nonatomic, assign) CGPadding linePadding;
@property (nonatomic, assign) CGFloat lineHeight;
@end